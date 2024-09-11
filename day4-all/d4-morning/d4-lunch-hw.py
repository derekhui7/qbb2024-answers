#!/usr/bin/env python3

#load the modules
import sys 

import numpy as np 

#1 Load the data
#Using wget command to download gene_tissue.tsv file 
#Create a dictionary using the gene tissue file 
#Open the file 
gene_tissue = open(sys.argv[1], mode = "r") 
#Create dict to hold samples
gene_dict = {}
for line in gene_tissue: 
    #Split lines into fields
    linesplit = line.rstrip("\n").split("\t")
    #Create key for gene and tissue
    key = linesplit[0]
    #Create list to hold sample
    gene_dict[key] = linesplit[2]

#print(sample_dict)

#2 Create dictionary by tissue 
#Load metadata 
tissue_id = open(sys.argv[2], mode = "r") 
#Skip one line 
tissue_id.readline()
#Create dict to hold samples
tissue_dict = {}
for line in tissue_id: 
    #Split lines into fields
    linesplit = line.rstrip("\n").split("\t")
    #Create key for tissue and value for sample id 
    key = (linesplit[6])
    value = (linesplit[0])
    #Load samples into dict 
    tissue_dict.setdefault(key, [])
    tissue_dict[key].append(value)



#3 Get sample id and expression data 
#Load expression data
ex_data = open(sys.argv[3], mode = "r") 
#Skip one line 
ex_data.readline()
ex_data.readline()
#Get column name (sample id)
headerline = ex_data.readline().strip("\n").split("\t")
sample_id = headerline[2:]
#print(sample_id)

#4/5 Sample id dictionary 
#Create new dictionary for sample vs tissues
sample_dict = {}
#tissue, samples in original tissue dictionary
for tissue, samples in tissue_dict.items():
    sample_dict.setdefault(tissue, [])
    for sample in samples: 
        if sample in sample_id:
            #identify the position of the samples 
            position = sample_id.index(sample)
            sample_dict[tissue].append(position)
#print(sample_dict)

tissue_number = {}
for tissue, lengths in sample_dict.items():
    tissue_number.setdefault(tissue, [])
    tissue_lengths = len(sample_dict[tissue])
    tissue_number[tissue] = tissue_lengths
#print(tissue_number)

longest_list_key = max(tissue_number, key=tissue_number.get)
#print(longest_list_key)
#The tissue with the most column is skeletal muscle

shortest_list_key = min(tissue_number, key=tissue_number.get)
#print(shortest_list_key)
#The tissue with the least column is Leukemia cell line cells 

#6 Create gene name vs expression 
#Create lists for gene names and expression
gene_name = []
gene_ex = []

for line in ex_data:
    #Split the remaining expression data into fields
    linesplit = line.rstrip("\n").split("\t")
    #The first field is the gene names 
    gene_name.append(linesplit[0])
    #The third field and on are expression data
    gene_ex.append(linesplit[2:])

#Create an array using numpy to store the expression data 
gene_ex_data = np.array(gene_ex, dtype = float)

#Create lists to catalogue the genes in the list and their position, create dictionary to store expression data
gene_sample_pos = []
i = 0
gene_ex_value = {}


#Using in to determine if the gene is in the gene list 
for gene in gene_name:
    if gene in gene_dict:
        #Note position of expression value by the gene 
        gene_sample_pos.append(i)
        tissue_relevent = gene_dict[gene]
        tissue_column = sample_dict[tissue_relevent]
        #Create a key using gene id and tissue name 
        key = (gene, tissue_relevent)
        #Create empty value list
        gene_ex_value.setdefault(key, [])
        ex_value = gene_ex_data[i][tissue_column]
        #Combine key and value
        gene_ex_value[key].append(ex_value)
    i += 1

#print(gene_ex_value)

#7 Create a .tsv file
tsv_file = open("Expression_values.tsv", mode = "w")
#Sort by key first 

for key, value in gene_ex_value.items():
    #Sort by the expression value by espression array
    for i in range(len(value)):
        for j in range(len(value[i])):
            line = str(key[0]) + "\t" + str(key[1]) + "\t" + str(value[i][0]) + "\n"
            tsv_file.write(line)

gene_tissue.close()
tissue_id.close()
ex_data.close()
tsv_file.close()





