input=${1-"version number"}
release_name=`printf "pretrain_%s_release.tar" $input`
echo $release_name
tar cvf /tmp/$release_name *.py *.sh configs/ bert nvidia README
