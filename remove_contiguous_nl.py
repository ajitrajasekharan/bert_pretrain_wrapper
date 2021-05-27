import pdb
import sys


def emptyline(line):
    for ch in line.rstrip('\n'):
        if (ch != ' '):
            return False
    return True

def remove_contig_nl(file_name):
    with open(file_name,"r") as fp:
        is_prev_nl = False
        count = 1
        for line in fp:
            count += 1
            if (len(line) > 1 and not emptyline(line)):
                print(line,end='')
                is_prev_nl = False
            else:
                if (not is_prev_nl):
                    is_prev_nl = True
                    print(line,end='')
                


if __name__ == "__main__":
    if (len(sys.argv) != 2):
        print("prog <input file_name>")
    else:
        remove_contig_nl(sys.argv[1])
            
