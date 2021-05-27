import pdb
import sys

#This is just to check the different nonascii chars in vocab


def pick_nonascii(file_name):
    with open(file_name,"r") as fp:
        for line in fp:
            for ch in line:
                if (ord(ch) >= 128):
                    print(ch)
            
                  


if __name__ == "__main__":
    if (len(sys.argv) != 2):
        print("prog <input file_name>")
    else:
        pick_nonascii(sys.argv[1])
            
