#!/usr/bin/env python3 

import sys 

my_bed = open(sys.argv[1])

for line in my_bed: 
    if "##" in line: 
        continue  
    
    fields = line.split("\t")
    line1 = fields[8]
    fields1 = line1.split(";")

    chrom = fields[0] 
    start = fields[3]
    end = fields[4]

    gene = "" 

    for column in fields1: 
        if "gene_name" in column: 
            gene = column
    gene = gene.rstrip("\"")
    gene = gene.lstrip("gene_name \"")

    print(chrom + "\t" + start + "\t" + end + "\t" + gene)

my_bed.close()