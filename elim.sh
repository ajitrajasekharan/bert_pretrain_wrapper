cat debug_gen.txt | sed 's/\[//g' |  sed 's/\]//g' | sed "s/'//g" | sed 's/,//g' | sed 's/ //g' > d1.txt
