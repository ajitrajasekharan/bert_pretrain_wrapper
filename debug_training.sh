INPUT_FILE="pieces/p1/p1"
#INPUT_FILE="pieces/p10001/p10001"
#INPUT_FILE="pieces/p20001/p20001"
OUTPUT_PRETRAIN_FILE="test/bert.tfrecord"
BERT_VOCAB_FILE="vocab_dir/vocab.txt"
DO_LOWER_CASE=False
export DUPE_FACTOR=10
export MAX_PREDICTIONS_PER_SEQ=20
export MASKED_LM_PROB=0.15 
export RANDOM_SEED=12345 
MAX_SEQ_LENGTH=128
rm -f debug_gen.txt
rm -rf test
mkdir -p test
export DUPE_FACTOR=10
    python bert/amino_create_pretraining_data.py \
    --input_file=$INPUT_FILE \
    --output_file=$OUTPUT_PRETRAIN_FILE \
    --vocab_file=$BERT_VOCAB_FILE \
    --do_lower_case=$DO_LOWER_CASE \
    --max_seq_length=$MAX_SEQ_LENGTH \
    --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
    --masked_lm_prob=$MASKED_LM_PROB \
    --random_seed=$RANDOM_SEED \
    --do_whole_word_mask=True\
    --dupe_factor=$DUPE_FACTOR
