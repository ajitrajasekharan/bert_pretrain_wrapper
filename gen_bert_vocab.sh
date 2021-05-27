input=${1?"Specify input file"}
output=${2-"vocab_dir"}
min_freq=${3-"2"}
size=${4-"30522"}
echo "Generating vocab with size: $size. Make sure this is correct size. cased defaults is 28996 and uncased is 30552 (min freq: $min_freq)"
time python gen_bert_vocab.py -input $input -output $output -size $size -min_freq $min_freq
