#!/usr/bin/env python3
 
import sys

import numpy as np 

#1 Nested List
#Open file
#fs = open("/Users/cmdb/Data/GTEx/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_median_tpm.gct") 
fs = open(sys.argv[1], mode = 'r')

#Skip two lines 
fs.readline()
fs.readline()

#Split the header line and skip the first two entries, retain only tissue name in a list 
headerline = fs.readline().strip("\n").split("\t")
tissues = headerline[2:]
#print(tissues)

#Split to hold gene id, gene name, and expression data
gene_id = []
gene_name = []
expression = []
for line in fs: 
    linesplit = line.strip("\n").split("\t")
    gene_id.append(linesplit[0])
    gene_name.append(linesplit[1])
    expression.append(linesplit[2:])
#print(gene_id)
#print(gene_name)
#print(expression)
fs.close()

#2
#Convert lists into arrays
gene_id_array = np.array(gene_id)
gene_name_array = np.array(gene_name)
expression_array = np.array(expression, dtype = float)
#print(expression_array)
#We needed to specify dtype as float since the expression has decimal point data with needs to be stored as floats

#3
# #Check for mean expression for first 10 genes 
# total = 0
# count = 0 
# for i in range(10): 
#     for j in range()

#4 Numpy mean first 10
e_f10 = np.mean(expression_array[0:10], axis = 1)
#print(e_f10)
#use axis = 1 to get the average expression levels across all tissues for every gene 

#5 Mean vs Median 
mean_ex = np.mean(expression_array)
median_ex = np.median(expression_array)
#print(mean_ex, median_ex)
#Comparing the mean and median, it allows us to realize that outliers can really affect the mean but not the median. Thus, median is a way better estimate for the distribution of the expression data. 

#6 Normalized data 
count = np.array(expression_array)
pseudo_c = 1
adjusted_c = count + pseudo_c
e_array_normalized = np.log2(adjusted_c)
mean_ex_n = np.mean(e_array_normalized)
median_ex_n = np.median(e_array_normalized)
#print(mean_ex_n, median_ex_n)
#The mean and median is now a lot closer to each other which means the normalization we did decrease the effect of outliers 

#7 Highest expression tissue
ex_copy = np.copy(e_array_normalized)
ex_sorted = np.sort(ex_copy)
#print(ex_sorted)
diff_array = ex_sorted[:, -1] - ex_sorted[:, -2]
#print(diff_array)

#8 Identification of the diff_array genes
genes_high_dif = np.where(diff_array >= 10)
#print(np.shape(genes_high_dif))
#33 genes have a 1000 fold difference

# #9 Highly expressed gene 
# ex_zero = np.zeros_like(e_array_normalized)
# max_i = np.argmax(e_array_normalized, axis = 0)












