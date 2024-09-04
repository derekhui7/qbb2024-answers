#!/usr/bin/env python3

import sys 

my_cut = open(sys.argv[2])

choice = sys.argv[1]
choices = choice.split(",")

print(choice)
print(choices)
    
print(type(choice))
print(type(choices))