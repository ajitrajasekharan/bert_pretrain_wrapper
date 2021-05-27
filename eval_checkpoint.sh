set -v
echo "Eval checkpoint"
export OUTPUT_DIR=${1?"specify output dir"}
export BASE_DIR=${2-/home/ajit/protein_experiment/code/pretrain_5.0_release}



echo $OUTPUT_DIR

export INPUT_PRETRAIN_FILE=$BASE_DIR/records/bert.tfrecord*


export BERT_VOCAB_FILE=$BASE_DIR/vocab_dir/vocab.txt

export BERT_SCRIPTS=$BASE_DIR/bert

export BERT_CONFIG_FILE=$BASE_DIR/configs/uncased_base/bert_config.json

#****** this must match data generation
export MAX_PREDICTIONS_PER_SEQ=20 

export TRAIN_BATCH_SIZE=64


#***** this must match data generation
#export MAX_SEQ_LENGTH=64
#export MAX_SEQ_LENGTH=128
export MAX_SEQ_LENGTH=512


export NUM_TRAIN_STEPS=200000

#export MAX_EVAL_STEPS=100
export MAX_EVAL_STEPS=10

#export SAVE_CHECKPOINT_STEPS=100000
export SAVE_CHECKPOINT_STEPS=5000

export LEARNING_RATE=2e-5
#export LEARNING_RATE=4e-5


export NUM_WARMUP_STEPS=0

cp $BERT_VOCAB_FILE $OUTPUT_DIR
cp $BERT_CONFIG_FILE $OUTPUT_DIR

echo "time python $BERT_SCRIPTS/run_pretraining.py \
            --input_file=$INPUT_PRETRAIN_FILE \
            --output_dir=$OUTPUT_DIR \
            --do_eval=True \
            --bert_config_file=$BERT_CONFIG_FILE \
            --train_batch_size=$TRAIN_BATCH_SIZE \
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
            --train_batch_size=$TRAIN_BATCH_SIZE \
            --max_seq_length=$MAX_SEQ_LENGTH \
            --max_eval_steps=$MAX_EVAL_STEPS \
            --save_checkpoints_steps=$SAVE_CHECKPOINT_STEPS \
            --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
            --num_train_steps=$NUM_TRAIN_STEPS \
            --num_warmup_steps=$NUM_WARMUP_STEPS \
            --learning_rate=$LEARNING_RATE

