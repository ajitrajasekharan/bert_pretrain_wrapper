import pdb
import sys

#This is purely for pumbed corpus filtering of lines predominantly with chinese characters. Removing them to avoid vocab entires for these characters.
#also removing them from model trying to learn from these sentences.
#Just a sample of the sentence (first 20 characters is used to estimate if the line is predominantly chinese chars

limit = 20
def filter_nonascii(file_name):
    with open(file_name,"r") as fp:
        threshold = limit/2
        for line in fp:
            count = 0
            for ch in line[:limit]:
                count += (1 if ord(ch) > 128 else 0)
            if (count <  threshold):
                print(line,end='')
                  


if __name__ == "__main__":
    if (len(sys.argv) != 2):
        print("prog <input file_name>")
    else:
        filter_nonascii(sys.argv[1])
            
