export INPUT_PRETRAIN_FILE=${1-`pwd`/records/bert.tfrecord*}
export OUTPUT_DIR=${2-`pwd`/eval}
echo "Eval checkpoint"


. ./config.sh

echo "Input dir:" $INPUT_PRETRAIN_FILE " Output dir: " $OUTPUT_DIR
echo "Scripts path:" $BERT_SCRIPTS


cp $BERT_VOCAB_FILE $OUTPUT_DIR
cp $BERT_CONFIG_FILE $OUTPUT_DIR

echo "time python $BERT_SCRIPTS/run_pretraining.py \
            --input_file=$INPUT_PRETRAIN_FILE \
            --output_dir=$OUTPUT_DIR \
            --do_eval=True \
            --bert_config_file=$BERT_CONFIG_FILE \
            --train_batch_size=$EVAL_BATCH_SIZE \
            --max_seq_length=$MAX_SEQ_LENGTH \
            --max_eval_steps=$MAX_EVAL_STEPS \
            --save_checkpoints_steps=$SAVE_CHECKPOINT_STEPS \
            --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
            --num_train_steps=$NUM_TRAIN_STEPS \
            --num_warmup_steps=$NUM_WARMUP_STEPS \
            --learning_rate=$LEARNING_RATE"



time python $BERT_SCRIPTS/run_pretraining.py \
            --input_file=$INPUT_PRETRAIN_FILE \
            --output_dir=$OUTPUT_DIR \
            --do_eval=True \
            --bert_config_file=$BERT_CONFIG_FILE \
            --train_batch_size=$EVAL_BATCH_SIZE \
            --max_seq_length=$MAX_SEQ_LENGTH \
            --max_eval_steps=$MAX_EVAL_STEPS \
            --save_checkpoints_steps=$SAVE_CHECKPOINT_STEPS \
            --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
            --num_train_steps=$NUM_TRAIN_STEPS \
            --num_warmup_steps=$NUM_WARMUP_STEPS \
            --learning_rate=$LEARNING_RATE

