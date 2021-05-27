ver=${1?"Enter release version number"}
input=`printf "pretrain_%s_release.tar" $ver`
echo "Creating tar file: $input"
find . -name __pycache__ -exec rm -rf {} \;
tar cvf $input *.sh *.py bert configs nvidia
