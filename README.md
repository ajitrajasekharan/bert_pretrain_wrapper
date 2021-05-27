## bert_pretrain_wrapper



Details of the pre-training evaluation as well pre-training tips in [the medium post](https://towardsdatascience.com/quantitative-evaluation-of-a-pre-trained-bert-model-73d56719539e) 

## Environment setup 
Setup pytorch environment with/without GPU support using [link](https://github.com/ajitrajasekharan/multi_gpu_test)


## Steps to pretrain starting with corpus pre-processing


### Step 1. Corpus pre-processing for sentence boundary detection

*One of BERT's objective is next sentence prediction. The corpus having sentences separated by newline is critical for this reason.*

Use [this repository code](https://github.com/ajitrajasekharan/simple_sbd.git) for sentence boundary detection

Perform sentence boundary detection using script bert_sbd.py. It filters out lines less than min_words (3) and > max_words (word not characters)
Then “tr” the output to lowercase approx. This is only required for uncased model pretraining.

*Example:*
```
 python bert_sbd.py -input pubmed.txt -single True  | tr 'A-Z' 'a-z' > combined.txt 
```

### Step 2.  Create two versions of corpus for vocab generation and pre-training

The output from the previous step is used to generate two versions of corpus. One is purely for vocab generation and the other is for pre-training


**(a) Corpus for vocabulary generation**

> This step can be **skipped** if we want to retain numbers and non-english characters. We can directly use the corpus from step 1 for vocab gen in that case.Note numbers within token like cd20 will be preserved anyays. Filtering numbers is only useful for some domains to avoid a large number of years making way into the base vocab. 

*Example:*
```
./gen_filtered_vocab_text.sh combined.txt corpus_for_vocab_gen.txt 
```

**(b) Corpus for pre-training**

*Example:*
```
time ./gen_filtered_corpus.sh combined.txt filtered.txt
```

### Step 3. Generate BERT vocabulary

Use the corpus from *Step 2a.*  to generate vocabulary

*Example:*
```
./gen_bert_vocab.sh corpus_for_vocab_gen.txt  
```


### Step 4. Create pretrain records for training

**(a) This step converts the corpus into pieces (honoring document boundaries)  which is then used by next step to create training records **

*Example:*
```
./gen_pieces.sh   filtered.txt pieces
```

**(b) This step creates actual training records. **

```
The configuration parameters that need to be set are in this script file itself. They are 
INPUT_DIR  - this is directory where the pieces from step 4a are stored
OUTPUT_DIR - output where checkpoints will be stored
BERT_VOCAB_FILE - absolute path of vocab file from step 3.
BERT_SCRIPTS  - location where github scripts of Google’s pretraining scripts are
DO_LOWER_CASE - set this to false for lower case models
MAX_SEQ_LENGTH  - this is the max length of words in a sentence (after tokenization)
DUPE_FACTOR - this controls how many times a sentence is duplicated to create different masked positions of the same sentence.  
MAX_PREDICTIONS_PER_SEQ - This controls the maxiumum predictions per sentence (this would be both masked and replaced words)
```

*Example*

```
./training_record_gen.sh
```

## Step 5. Actual training of model
This step uses the trained records from *step 4* to do actual model training

**Google's pretraining code can be used as is only for single GPU runs. Nvidia's repository has a version that utilizes multiple GPUS. Training steps for both single and multiple GPUs is described below**


## Single GPU run
```
Parameters to be set.
INPUT_PRETRAIN_FILE - location where all the training records are stored
OUTPUT_DIR - location where training outputs are stored - the checkpoints
BERT_VOCAB_FILE - location of vocab from step 3
BERT_SCRIPTS  - location where github scripts of Google’s pretraining scripts are
MAX_PREDICTIONS_PER_SEQ - should match what was used in step 4. 
TRAIN_BATCH_SIZE - 64 for < 20; 32 for < 40; 8 for rest
MAX_SEQ_LENGTH - should match what was used in step 4. 
NUM_TRAIN_STEPS - I did 100k for < 20; 500k < 40; and 30k for rest. This may need to be done based on how the cum distribution of words shifts - we don’t want the histogram tails to be too short. 
NUM_WARMUP_STEPS - this is 1% of train steps for the first checkpoint. 0 for all subsequent trainings
MAX_EVAL_STEPS - number of evaluations. Only the last evaluation results  are saved though. I haven't figured how to make it save all eval results.
SAVE_CHECK_POINT_STEPS - too many checkpoints can cause us to run out of diskspace if we are low on it. I did checkpointing every 5k steps
 
LEARNING_RATE - default works reasonably well.  Range to experiment 1 e-4 to 4 e-5
 
CONTINUED_TRAINING - set this to 0 for initial training and to 1 for subsequent training
INIT_CHECKPOINT - location of the checkpoint to resume from when CONTINUED_TRAINING is set to 1

```

*Example*
```
./actual_training.sh
```


## Multi GPU run using Nvidia container

When using multi GPU training, BERT’s code for pretraining record generation is a better option, since whole word masking is not supported in Nvidia’s code base to date (they plan to add it in a future product release).  Nvidia  code can then only be used for the pre-training step.

The two scripts for pretraining with different hyperparams (they are nearly identical other than the params) are in the *nvidia* sub directory

```
nv_train.sh
nv2_train.sh
```

*Note. I had to patch Nvidia code due to some compile errors. The patched code is also present in the nvidia sub directory.*

## Additional notes

- To convert Tensorflow checkpoint to PyTorch  use
  -  ```convert_to_pytorch.sh```
-  To examine model vectors use the [link](https://github.com/ajitrajasekharan/bert_vector_clustering.git)
-  When training model with Google's tensorflow code, checkpoint saving can be done with these scripts. Checkpoint saving tends to delete and keep last n checkpoint. So within the output directory  run a script ../last_save.sh - it will periodically check for checkpoints and save the checkpoint, the vocab and config.json file - all three are needed for pytorch model conversion. Also once all checkpoints are created, run batch_eval.sh from within the output directory to create eval results for all checkpoints.
-  As mentioned earlier, details of the pre-training evaluation as well pre-training tips in [the medium post](https://towardsdatascience.com/quantitative-evaluation-of-a-pre-trained-bert-model-73d56719539e) 



## License

MIT License
