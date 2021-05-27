#
#Env specific to actual training
#


##########
#Use this script to pretrain tabular data that cannot be split/broken or packed like sentences.
#export TRAINING_RECORD_GEN_SCRIPT=amino_create_pretraining_data.py

#Use this script for sentences
export TRAINING_RECORD_GEN_SCRIPT=create_pretraining_data.py
#########

export BERT_CONFIG_FILE=`pwd`/configs/uncased_base/bert_config.json

export TRAIN_BATCH_SIZE=32
export EVAL_BATCH_SIZE=8

export NUM_TRAIN_STEPS=200000

#WARMUP is 1% of full train steps
export NUM_WARMUP_STEPS=1000
#export NUM_WARMUP_STEPS=0

export MAX_EVAL_STEPS=5

#export SAVE_CHECKPOINT_STEPS=100000
export SAVE_CHECKPOINT_STEPS=40000


export LEARNING_RATE=2e-5

#
#Env common to Training record gen and actual training
#

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


#export NUM_THREADS=`nproc`
#I can only schedule 24 - my quota is 32
export NUM_THREADS=24

#to install parallel on ubuntu: apt-get install -y parallel
export PARALLEL_EXEC=`which parallel`

