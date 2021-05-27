input=${1?"Specify input file"}
output_file=${2?"Specify output file"}
tmp_file=tmp$$
set -v
#This just removes predominantly chinese character lines - present in pubmed. There is little to learn from just replacing those characters in the line
#We dont remove special characters interspersed in lines. They will be replaced by UNK tokens if they are not in vocab preserving sentence structure to some degree (in constast to removing them completely)
python filter_predominantly_chinese.py $input > $tmp_file
python remove_contiguous_nl.py $tmp_file > $output_file
rm $tmp_file
