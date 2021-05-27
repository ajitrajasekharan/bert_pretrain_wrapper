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


** (a) Corpus for vocabulary generation**

*Example:*
```
./gen_filtered_vocab_text.sh combined.txt corpus_for_vocab_gen.txt 
```

** (b) Corpus for pre-training**

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


## Single GPU run



## Multi GPU run using Nvidia container




## License

MIT License
