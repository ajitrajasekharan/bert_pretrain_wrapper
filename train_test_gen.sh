inp_file=${1?"Specify input file"}
train_percent=${2-.8}

export train_percent



export rec_count=`cat $inp_file | awk '{if (NF == 0) count++;} END { print count}'`
echo $rec_count
export train_limit=`echo | awk '{printf "%.0f", ENVIRON["rec_count"]*ENVIRON["train_percent"]}'`
echo $train_limit
cat $inp_file | awk '{if (NF == 0) count++; if (count < ENVIRON["train_limit"]) print $0;}' > train.txt
cat $inp_file | awk '{if (NF == 0) count++; if (count >= ENVIRON["train_limit"]) print $0;}' > test.txt
wc -l  $inp_file
wc -l train.txt test.txt 

