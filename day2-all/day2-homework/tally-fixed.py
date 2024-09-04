#!/usr/bin/env python3 

import sys 

my_file = open( sys.argv[1] )

chr = ""

count = 0

for my_line in my_file:

    if "#" in my_line:
        continue

    fields = my_line.split("\t")

    if fields[0] != chr:
        #added print if count not equal to 0 so it does not print when count = 0 
        if count != 0: 
            
            print(count, chr )

        chr = fields[0]
        #start the count at 1 to avoid printing 0
        count = 1
        continue

    else:
        count = count + 1

#Print after the for loop so we obtain chrM 
print(count, chr)

my_file.close()