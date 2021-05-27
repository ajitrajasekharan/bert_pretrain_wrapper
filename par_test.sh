input=${1?"Specify input dir"}
export input
export TMP_JOBS_LOG=tmpjobs.log
export INTER_PROC_DELAY=1
export LAST_RUN_LOG=last_run.log
PARALLEL_EXEC=parallel
export ERR_LOG=error.log
rm -f $ERR_LOG $TMP_JOBS_LOG $LAST_RUN_LOG



function par_task
{
	file_name=$input/$1
	echo "par_task -input $file_name $1 " | tee -a  $LAST_RUN_LOG
	ls -l $file_name | tee -a $LAST_RUN_LOG
	#sleep $(( ( RANDOM % 10 )  + 1 ))
	sleep 1
	##DO NOT DO A TEE ON Command below. return status will be lost
	#gen_vocab -input $i -output $file_name >>$OUT_LOG
	##do not add code here after command - return code passed to parallel for resuming
	echo "par_task -input $file_name" | tee -a $LAST_RUN_LOG
}
export -f par_task


ls -1v $input* | $PARALLEL_EXEC -k --no-notice --joblog $TMP_JOBS_LOG  --resume-failed   --delay $INTER_PROC_DELAY par_task {} 2>> $ERR_LOG
