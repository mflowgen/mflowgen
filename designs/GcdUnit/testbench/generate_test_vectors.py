from random import random
import math
import numpy as np
import binascii
import struct

num_vectors = 100

f = open("test_vectors.txt", "w")

def get_hex (x):
  return str(binascii.hexlify(struct.pack('>H', x)))[2:6] # H is for unsigned short -- 16 bits

i = 0

while (i < num_vectors):
  a = np.uint16(math.floor(random() * (2**16 - 1)))
  b = np.uint16(math.floor(random() * (2**16 - 1)))
  if (a != 0) and (b != 0):
    c = math.gcd(a, b)
    f.write(str(get_hex(c)) + '_' + str(get_hex(a)) + '_' + str(get_hex(b)) + '\n') 
    i = i + 1
f.close()
