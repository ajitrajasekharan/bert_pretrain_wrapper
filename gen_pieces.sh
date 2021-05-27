input=${1?"Specify file to split on document boundaries"}
output_dir=${2?"Specify output dir"}
doc_size=${3-10000}
prefix_name=${4-"p"}



mkdir -p $output_dir
set -v
time python split_input.py $input $output_dir  $doc_size $prefix_name

