set -v
echo "Pretraining with an fresh start -no checkpoint used"

export INPUT_PRETRAIN_FILE=`pwd`/records/bert.tfrecord*

export OUTPUT_DIR=`pwd`/output



export BERT_VOCAB_FILE=`pwd`/vocab_dir/vocab.txt

export BERT_SCRIPTS=`pwd`/bert

#****** this must match data generation
export MAX_PREDICTIONS_PER_SEQ=20 

export TRAIN_BATCH_SIZE=32


#***** this must match data generation
export MAX_SEQ_LENGTH=512

export NUM_TRAIN_STEPS=200000

#WARMUP is 1% of full train steps
export NUM_WARMUP_STEPS=1000
#export NUM_WARMUP_STEPS=0

export MAX_EVAL_STEPS=5

#export SAVE_CHECKPOINT_STEPS=100000
export SAVE_CHECKPOINT_STEPS=40000

export LEARNING_RATE=2e-5
#export LEARNING_RATE=1e-6

export BERT_CONFIG_FILE=`pwd`/configs/uncased_base/bert_config.json

mkdir -p $OUTPUT_DIR
cp $BERT_VOCAB_FILE $OUTPUT_DIR
cp $BERT_CONFIG_FILE $OUTPUT_DIR

export CONTINUED_TRAINING=0

#enable this for continued training
#export CONTINUED_TRAINING=1
#export INIT_CHECKPOINT=`pwd`/run1/save_5/model.ckpt-500000


if [ $CONTINUED_TRAINING -eq 0 ]
then
        echo "TRAINING FROM START******"
        sleep 5
        time python $BERT_SCRIPTS/run_pretraining.py \
            --input_file=$INPUT_PRETRAIN_FILE \
            --output_dir=$OUTPUT_DIR \
            --do_train=True \
            --do_eval=True \
            --bert_config_file=$BERT_CONFIG_FILE \
            --train_batch_size=$TRAIN_BATCH_SIZE \
            --max_seq_length=$MAX_SEQ_LENGTH \
            --max_eval_steps=$MAX_EVAL_STEPS \
            --save_checkpoints_steps=$SAVE_CHECKPOINT_STEPS \
            --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
            --num_train_steps=$NUM_TRAIN_STEPS \
            --num_warmup_steps=$NUM_WARMUP_STEPS \
            --learning_rate=$LEARNING_RATE
else
        echo "CONTINUING TRAINING FROM CHECKPOINT******"
        sleep 5
        time python $BERT_SCRIPTS/run_pretraining.py \
            --input_file=$INPUT_PRETRAIN_FILE \
            --output_dir=$OUTPUT_DIR \
            --do_train=True \
            --do_eval=True \
            --bert_config_file=$BERT_CONFIG_FILE \
            --train_batch_size=$TRAIN_BATCH_SIZE \
            --max_seq_length=$MAX_SEQ_LENGTH \
            --max_eval_steps=$MAX_EVAL_STEPS \
            --save_checkpoints_steps=$SAVE_CHECKPOINT_STEPS \
            --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
            --num_train_steps=$NUM_TRAIN_STEPS \
            --num_warmup_steps=$NUM_WARMUP_STEPS \
            --init_checkpoint=$INIT_CHECKPOINT \
            --learning_rate=$LEARNING_RATE
fi

