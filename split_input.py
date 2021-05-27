import os
import pdb
import sys

def split_file(inp_file,output_dir,doc_size,prefix_name):
	doc_count = 1
	line_count = 0
	dir_name = output_dir + '/'+ prefix_name + str(doc_count)
	file_name = dir_name + '/' + prefix_name + str(doc_count)
	os.mkdir(dir_name)
	wfp = open(file_name,"w",encoding="utf-8")
	with open(inp_file,"r",encoding="utf-8") as fp:
		for line in fp:
			line_count += 1
			#print(line_count)
			wfp.write(line)
			if (len(line) == 1):
				doc_count += 1
			if (doc_count % doc_size == 0):
				print("Completed split:", doc_count)
				wfp.close()
				doc_count += 1
				dir_name = output_dir + '/'+ prefix_name + str(doc_count)
				file_name = dir_name + '/' + prefix_name + str(doc_count)
				os.mkdir(dir_name)
				wfp = open(file_name,"w",encoding="utf-8")	
	wfp.close()
	
				
			

def main():
	if (len(sys.argv) != 5):
		print("Usage: <input file> <output dir> count for split> <prefix>")
	else:
		split_file(sys.argv[1],sys.argv[2],int(sys.argv[3]),sys.argv[4])


if __name__ == "__main__":
	main()
