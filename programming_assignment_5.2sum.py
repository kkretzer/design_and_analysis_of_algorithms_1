import sys
from string import *
from math import ceil

import sys

def read_integers_file():
    with open(sys.argv[1], 'r') as file:
        integers = []
        for line in file:
            integers.append(int(strip(line)))
    return integers

def has_2sum(target, ints):
    # i gave *very* little thought to this hash function
    # => TODO try better ones
    def hash(i, integers):
        max = len(integers) - 1
        h = int(ceil(i*17 / 19.0))
        return h % max
    def hashtable(integers):
        htable = [[] for x in range(2*len(ints))]
        for i in integers:
            h = hash(i, integers)
            htable[h].append(i)
        return htable

    htable = hashtable(ints)
    for i in ints:
        diff = target - i
        h = hash(diff, ints)
        bucket = htable[h]
        if diff in bucket:
            if diff != i:
                return 1
            if diff == i and len([i for i,x in enumerate(bucket) if x == i]) > 1:
                return 1 
    return 0

print "reading in file..."
integers = read_integers_file()
print "done reading in file"

target_sums = [231552,234756,596873,648219,726312,981237,988331,1277361,1283379]

print [has_2sum(target_sum, integers) for target_sum in target_sums]
