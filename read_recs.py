import tensorflow as tf
import pdb
import json

tf.enable_eager_execution()

#filenames = ["amino_records/bert.tfrecordp1"]
#raw_dataset = tf.data.TFRecordDataset(filenames)
#for raw_record in raw_dataset.take(10):
#    print(repr(raw_record))


#for raw_record in raw_dataset.take(1):
#  example = tf.train.Example()
#  pdb.set_trace()
#  example.ParseFromString(raw_record.numpy())
#  print(example)


count = 0
max_count = 100



for example in tf.python_io.tf_record_iterator("amino_records/bert.tfrecordp1"):
    print(tf.train.Example.FromString(example))
    count += 1  
    if (count >= max_count):
       break




