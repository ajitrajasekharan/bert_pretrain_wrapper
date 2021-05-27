input=${1?"Specify input file"}
output_file=${2?"Specify output file"}
set -v
python  ./filter_nonascii.py $input 0 > $output_file
cat numbers.txt >> $output_file
#./elim_chinese.sh $tmp_file >> $output_file


