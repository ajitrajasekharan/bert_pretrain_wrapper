#! /bin/bash

# Copyright (c) 2019 NVIDIA CORPORATION. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "Container nvidia build = " $NVIDIA_BUILD_ID

train_batch_size=${1:-16}
eval_batch_size=${2:-8}
learning_rate=${3:-"1e-5"}
precision=${4:-"fp16"}
use_xla=${5:-"true"}
num_gpus=${6:-4}
warmup_steps=${7:-"10"}
train_steps=${8:-100}
save_checkpoints_steps=${9:-50}
bert_model=${10:-"large"}
num_accumulation_steps=${11:-128}
seq_len=${12:-512}
max_pred_per_seq=${13:-20}

#DATA_DIR=/home/acc/pretrain_4.0_release/pbm_bookc_records/
#DATA_DIR=/home/acc/DeepLearningExamples/TensorFlow/LanguageModeling/BERT/scratch/tfrecord/lower_case_1_seq_len_128_max_pred_20_masked_lm_prob_0.15_random_seed_12345_dupe_factor_5_shard_1472_test_split_10/wikicorpus_en/
DATA_DIR=/home/acc/DeepLearningExamples/TensorFlow/LanguageModeling/BERT/scratch/tfrecord2/
BERT_CONFIG="/home/acc/pretrain_4.0_release/configs/uncased_large/bert_config.json"
PHASE1_CKPT=/home/acc/results/128_run/model.ckpt-7820



PREC=""
if [ "$precision" = "fp16" ] ; then
   PREC="--amp"
elif [ "$precision" = "fp32" ] ; then
   PREC="--noamp"
elif [ "$precision" = "tf32" ] ; then
   PREC="--noamp"
elif [ "$precision" = "manual_fp16" ] ; then
   PREC="--noamp --manual_fp16"
else
   echo "Unknown <precision> argument"
   exit -2
fi

if [ "$use_xla" = "true" ] ; then
    PREC="$PREC --use_xla"
    echo "XLA activated"
else
    PREC="$PREC --nouse_xla"
fi

export GBS=$(expr $train_batch_size \* $num_gpus \* $num_accumulation_steps)
printf -v TAG "tf_bert_pretraining_adam_%s_%s_gbs%d" "$bert_model" "$precision" $GBS
DATESTAMP=`date +'%y%m%d%H%M%S'`

#Edit to save logs & checkpoints in a different directory
RESULTS_DIR=${RESULTS_DIR:-/results/${TAG}_${DATESTAMP}}
LOGFILE=$RESULTS_DIR/$TAG.$DATESTAMP.log
mkdir -m 777 -p $RESULTS_DIR
printf "Saving checkpoints to %s\n" "$RESULTS_DIR"
printf "Logs written to %s\n" "$LOGFILE"

INPUT_FILES="$DATA_DIR/training"
EVAL_FILES="$DATA_DIR/test"

horovod_str=""
mpi=""
if [ $num_gpus -gt 1 ] ; then
   mpi="mpiexec --allow-run-as-root -np $num_gpus --bind-to socket"
   horovod_str="--horovod"
fi


$mpi python3 run_pretraining.py \
--input_files_dir=$INPUT_FILES \
--init_checkpoint=$PHASE1_CKPT \
--eval_files_dir=$EVAL_FILES \
--output_dir=$RESULTS_DIR \
--bert_config_file=$BERT_CONFIG \
--do_train=True \
--do_eval=True \
--train_batch_size=$train_batch_size \
--eval_batch_size=$eval_batch_size \
--max_seq_length=$seq_len \
--max_predictions_per_seq=$max_pred_per_seq \
--num_train_steps=$train_steps \
--num_warmup_steps=$warmup_steps \
--num_accumulation_steps=$num_accumulation_steps \
--save_checkpoints_steps=$save_checkpoints_steps \
--learning_rate=$learning_rate \
--optimizer_type=lamb \
$horovod_str $PREC \
--allreduce_post_accumulation=True

#Check if all necessary files are available before training
for DIR_or_file in $DATA_DIR $BERT_CONFIG $RESULTS_DIR; do
  if [ ! -d "$DIR_or_file" ] && [ ! -f "$DIR_or_file" ]; then
     echo "Error! $DIR_or_file directory missing. Please mount correctly"
     exit -1
  fi
done

set -x
if [ -z "$LOGFILE" ] ; then
   $CMD
else
   (
     $CMD
   ) |& tee $LOGFILE
fi
set +x
