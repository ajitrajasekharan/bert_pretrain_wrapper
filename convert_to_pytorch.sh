#Specify the model name directory
BERT_BASE_DIR=${1-.}

transformers-cli convert --model_type bert \
  --tf_checkpoint $BERT_BASE_DIR \
  --config $BERT_BASE_DIR/config.json \
  --pytorch_dump_output $BERT_BASE_DIR/pytorch_model.bin
