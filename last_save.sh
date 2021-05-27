iter=0
save_model=save_$iter
while :
do
	count=`ls -ltr model.ckpt* | awk '{print $9}' | tail -3 | wc -l`
	echo "iter: $iter"
	if [ $count -ge 3 ]
	then
		#rm -rf save_model
        save_model=save_$iter
        ((iter=iter+1))
		mkdir $save_model
		for i in `ls -ltr model.ckpt* | awk '{print $9}' | tail -3`; do  echo $i;mv $i $save_model; done
		cp bert_config.json $save_model/config.json
		cp checkpoint $save_model
		cp vocab.txt $save_model
        echo "model saved: $save_model"
        ls -ltr $save_model
	else
	    sleep 30
	fi
done
