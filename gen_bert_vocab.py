from tokenizers import BertWordPieceTokenizer
import os
import sys
import argparse
import pdb



DEFAULT_MIN_FREQ=2


#This code almost verbatim is based on simpletransformers.

class BERTVocabGen:
	def __init__(self,vocab_size,tolower,min_freq):
		self.clean_text = True
		self.handle_chinese_chars = True
		self.strip_accents = True
		self.do_lowercase = tolower
		self.vocab_size = vocab_size
		self.min_frequency = min_freq #this is to avoid infrequent chars from entering into vocab
		self.special_tokens = ["[PAD]", "[UNK]", "[CLS]", "[SEP]", "[MASK]"]
		self.wordpieces_prefix = "##"


	def create(self,train_files,output_dir):
		tokenizer = BertWordPieceTokenizer(
			clean_text=self.clean_text,
			handle_chinese_chars=self.handle_chinese_chars,
			strip_accents=self.strip_accents,
			lowercase=self.do_lowercase
    		)

		tokenizer.train(
			files=train_files,
			vocab_size=self.vocab_size,
			min_frequency=self.min_frequency,
			special_tokens=self.special_tokens,
			wordpieces_prefix=self.wordpieces_prefix
   		 )
		os.makedirs(output_dir, exist_ok=True)

		tokenizer.save_model(output_dir)




def main(args):
	input_file = args.input
	output_dir = args.output
	vocab_size = args.size
	tolower = args.tolower
	min_freq = args.min_freq
	obj = BERTVocabGen(vocab_size,tolower,min_freq)
	obj.create([input_file],output_dir)
	print("vocab gen complete")



if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Vocab generator',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
	parser.add_argument('-input', action="store", dest="input",required=True, help='Input to file containing sentences.')
	parser.add_argument('-output', action="store", dest="output",required=True,help='Output dir')
	parser.add_argument('-size', action="store", dest="size",required=True,type=int,help='Vocab size; BERT defaults - uncased = 30552; cased = 28996')
	parser.add_argument('-min_freq', action="store", dest="min_freq",default=DEFAULT_MIN_FREQ,type=int,help='Min frequency to consider for a word. Setting it to any value > 1 will potentially results in [UNK] tokens during tokenization')
	parser.add_argument('-tolower', action="store", dest="tolower", default=False,type=bool,help='Lower case input')
	args = parser.parse_args()
	print(vars(args).items())
	main(args)
