#!/usr/bin/env python3

import sys 

my_grep = open(sys.argv[2])

gene = sys.argv[1]

for line in my_grep:
    if gene in line:
        line = line.rstrip("\n")
        print(line) 

my_grep.close()

