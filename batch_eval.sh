input=${1-save_}
for i in `ls -1vd $input*`
do
    echo $i
    (cd $i; pwd; ../../eval_checkpoint.sh `pwd`)
done
ls -1v $input*/eval_results.txt | xargs ../dump_evals.sh > full_evals.txt
