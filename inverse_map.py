import sys
import pdb
from collections import OrderedDict


def read_vocab(vocab_file):
    vocab_dict = OrderedDict()
    index = 0
    with open(vocab_file) as fp:
        for line in fp:
            if (len(line) > 1):
                vocab_dict[str(index)] = line.rstrip('\n')
                index += 1
    return vocab_dict


def inv_map(input_file,vocab_file):
    vocab_dict = read_vocab(vocab_file)

    with open(input_file,"r") as fp:
        for line in fp:
            line = line.rstrip('\n')
            if (line.lstrip().startswith("value:")):
                val = line.split(':')[1].strip()
                if (val in vocab_dict):
                    print(line + ' ' + vocab_dict[val])
                else:
                    print(line)
            else:
                print(line)
           




if __name__ == "__main__":
    inv_map(sys.argv[1],sys.argv[2]) 
