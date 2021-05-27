INPUT_DIR=`pwd`/pieces
#INPUT_DIR=`pwd`/sm
export INPUT_DIR

export OUTPUT_DIR=`pwd`/records

export BERT_SCRIPTS=`pwd`/bert

export BERT_VOCAB_FILE=`pwd`/vocab_dir/vocab.txt


#Remember to set this to False for cased models
export DO_LOWER_CASE=False

#This needs to be same for both training record gen and actual training
export MAX_SEQ_LENGTH=128

export DUPE_FACTOR=10

#This needs to be same for both training record gen and actual training
export MAX_PREDICTIONS_PER_SEQ=20

export MASKED_LM_PROB=0.15 
export RANDOM_SEED=12345 

rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
#NOTE: Whole word masking needs to be set at traiing record gen. It is not even relevant during actual training. The option is ignored during training even if set
#Dupe factor is key - controls how many times a sentence is duplicated to generate diffferent maskings of the sentence


#export NUM_THREADS=`nproc`
#I can only schedule 24 - my quota is 32
export NUM_THREADS=24
#to install parallel on ubuntu: apt-get install -y parallel
export PARALLEL_EXEC=`which parallel`

function create_pretrain_data
{
    INPUT_FILE=$1 
    SUFFIX=$2
    echo "Bert vocab file for word gen is :$BERT_VOCAB_FILE" | tee -a $LAST_RUN_LOG
    export OUTPUT_PRETRAIN_FILE=$OUTPUT_DIR/bert.tfrecord$2
    echo $BERT_SCRIPTS $INPUT_FILE $OUTPUT_PRETRAIN_FILE | tee -a $LAST_RUN_LOG

    echo "python $BERT_SCRIPTS/create_pretraining_data.py \
    --input_file=$INPUT_FILE \
    --output_file=$OUTPUT_PRETRAIN_FILE \
    --vocab_file=$BERT_VOCAB_FILE \
    --do_lower_case=$DO_LOWER_CASE \
    --max_seq_length=$MAX_SEQ_LENGTH \
    --max_predictions_per_seq=$MAX_PREDICTIONS_PER_SEQ \
    --masked_lm_prob=$MASKED_LM_PROB \
    --random_seed=$RANDOM_SEED \
    --do_whole_word_mask=True\
    --dupe_factor=$DUPE_FACTOR"

    python $BERT_SCRIPTS/create_pretraining_data.py \
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


}
export -f create_pretrain_data



function check_mandatory_files
{
    param=${!1}
    if [ -z "$param" ]
    then
        echo "Param: $1  NOT set"  | tee -a $ERR_LOG
        exit
    else
        if [ -f $param ]
        then
            echo "$1 words file: $param found"  | tee -a $LAST_RUN_LOG
        else
            echo "$1 words file: $param NOT found"  | tee -a $ERR_LOG
            exit
        fi
    fi
}




function par_task
{
	param=$1
	file_name=$INPUT_DIR/$1/$1
	echo "par_task -input $file_name $1 " | tee -a  $LAST_RUN_LOG
	ls -l $file_name | tee -a $LAST_RUN_LOG
	#sleep $(( ( RANDOM % 10 )  + 1 ))
	##DO NOT DO A TEE ON Command below. return status will be lost
	create_pretrain_data $file_name $param 2>> $ERR_LOG
	##do not add code here after command - return code passed to parallel for resuming
}
export -f par_task



function start_task
{
	export TMP_JOBS_LOG=tmpjobs.log
	export INTER_PROC_DELAY=1
	export LAST_RUN_LOG=last_run.log
	PARALLEL_EXEC=parallel
	export ERR_LOG=error.log
	rm -f $ERR_LOG $TMP_JOBS_LOG $LAST_RUN_LOG
	ls -1v $INPUT_DIR* | $PARALLEL_EXEC -k --no-notice -j $NUM_THREADS --joblog $TMP_JOBS_LOG  --resume-failed   --delay $INTER_PROC_DELAY par_task {} 2>> $ERR_LOG

}



function main
{
	check_mandatory_files "PARALLEL_EXEC"
	start_task $INPUT_DIR
}




main


