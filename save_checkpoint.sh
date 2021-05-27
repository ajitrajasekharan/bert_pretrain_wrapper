dir=${1?"Specify directory"}
prefix=${2?"Model prefix"}
mkdir $dir
cp $prefix* $dir
cp bert_config.json $dir/config.json
cp checkpoint $dir
cp vocab.txt $dir
