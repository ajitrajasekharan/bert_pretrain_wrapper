#input=${1-/home/acc/pretrain_4.0_release/pbm_bookc_records/}
input=${1-/home/acc/pretrain_4.0_release/cased_records/}
count=1
for i in `ls -1v $input`
do
	echo $i
	((count=count+1))
	if [ $count -lt 4328 ]
	then
		echo "copying to training"
		cp $input/$i training/
	else
		echo "copying to testing"
		cp $input/$i test/
	fi
done
