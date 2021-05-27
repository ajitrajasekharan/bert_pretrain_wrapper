CONTINUED_TRAINING=${1-0}
INIT_CHECKPOINT=${2-""}
INPUT_PRETRAIN_FILE=${3-`pwd`/records/bert.tfrecord*}
OUTPUT_DIR=${4-`pwd`/output}


export INPUT_PRETRAIN_FILE
export OUTPUT_DIR

. ./config.sh

if [ $CONTINUED_TRAINING -eq 0 ]
then 
        echo "Pretraining with an fresh start -no checkpoint used"
else
        echo "Starting with previous checkpoint: $INIT_CHECKPOINT"
fi


echo "Input dir:" $INPUT_PRETRAIN_FILE " Output dir: " $OUTPUT_DIR
echo "Scripts path:" $BERT_SCRIPTS



mkdir -p $OUTPUT_DIR
cp $BERT_VOCAB_FILE $OUTPUT_DIR
cp $BERT_CONFIG_FILE $OUTPUT_DIR



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

