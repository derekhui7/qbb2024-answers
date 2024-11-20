#!/usr/bin/env python

import numpy as np
import scipy
import matplotlib.pyplot as plt
import imageio
import plotly.express as px
import plotly
import pandas as pd 


#Exercise 1 
na = np.newaxis

#Create a dictionary for images 
images = {}

#Hard coding genename, fields and channels for images to be selected and then opened 
genename = ["APEX1", "PIM2", "POLR2B", "SRSF1"]
fields = ["field0", "field1"]
channels = ["DAPI", "PCNA", "nascentRNA"]

#Test the size of the images
sampleimg = imageio.v3.imread("~/qbb2024-answers/week10-all/APEX1_field0_DAPI.tif").astype(np.uint16)

#Load the images
for name in genename: 
    for field in fields:
        for channel in channels:
            file_path = f"~/qbb2024-answers/week10-all/{name}_{field}_{channel}.tif"
            try: 
                img = imageio.v3.imread(file_path).astype(np.uint16)
                images[f"{name}_{field}_{channel}"] = img
                #print(img.shape)
                #print(f"Processed image: {name}_{field}_{channel}")
            # except FileNotFoundError:
            #     print(f"File not found: {file_path}")
            # except Exception as e: 
            #     print(f"Error processing {file_path}: {e}")
            except: 
                continue


allarrays = []

#Combie images into image arrays by gene and field
for name in genename: 
    for field in fields: 
        imgarray = np.zeros((sampleimg.shape[0], sampleimg.shape[1], 3), np.uint16)
        for i, channel in enumerate(channels):
            try: 
                imgarray[:, :, i] = images[f"{name}_{field}_{channel}"]
                imgarray[:, :, i] -= np.amin(imgarray[:, :, i])
                imgarray[:, :, i] /= np.amax(imgarray[:, :, i])
            except: continue 
        allarrays.append(imgarray)
        #print(imgarray.shape)
        #plt.imshow(imgarray)
        #plt.show()
        
allarrays = np.array(allarrays)
# print(allarrays)



#Exercise 2 
#Step 2.1
#Create a binary mask list 
mask = []
for image in allarrays:
    mean = np.mean(image[:,:,0])
    binary = (image[:,:,0]) >= mean
    mask.append(binary)

#plt.imshow(mask[7])
#plt.show()

#Step 2.2 
def find_labels(mask):
    # Set initial label
    l = 0
    # Create array to hold labels
    labels = np.zeros(mask.shape, np.int32)
    # Create list to keep track of label associations
    equivalence = [0]
    # Check upper-left corner
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    # For each non-zero column in row 0, check back pixel label
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                # If back pixel has a label, use same label
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    # For each non-zero row
    for x in range(1, mask.shape[0]):
        # Check left-most column, up  and up-right pixels
        if mask[x, 0]:
            if mask[x - 1, 0]:
                # If up pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                # If up-right pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        # For each non-zero column except last in nonzero rows, check up, up-right, up-right, up-left, left pixels
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    # If up pixel has label, use that label
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    # If not up but up-right pixel has label, need to update equivalence table
                    if mask[x - 1, y - 1]:
                        # If up-left pixel has label, relabel up-right equivalence, up-left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        # If left pixel has label, relabel up-right equivalence, left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        # If neither up-left or left pixels are labeled, use up-right equivalence label
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    # If not up, or up-right pixels have labels but up-left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    # If not up, up-right, or up-left pixels have labels but left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    # Otherwise, add new label
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        # Check last pixel in row
        if mask[x, -1]:
            if mask[x - 1, -1]:
                # if up pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                # if not up but up-left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                # if not up or up-left but left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                # Otherwise, add new label
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = np.array(equivalence)
    # Go backwards through all labels
    for i in range(1, len(equivalence))[::-1]:
        # Convert labels to the lowest value in the set associated with a single object
        labels[np.where(labels == i)] = equivalence[i]
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

#Create label array list
label_array = []

#Load label array with labels 
for i in range(len(mask[:])):
    label = find_labels(mask[i])
    label_array.append(label)

label_array = np.array(label_array)
#print(len(label_array))
#Step 2.3

def filter_by_size(labels, minsize=100, maxsize=999999999):
    # Find label sizes
    sizes = np.bincount(labels.ravel())
    # Iterate through labels, skipping background
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < minsize or sizes[i] > maxsize:
            # Find all pixels for label
            where = np.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

#Load first filtered label into the array
for i in range(len(label_array)):
    label_array[i] = filter_by_size(label_array[i])

def filter_by_size_msd(labels):
    sizes = np.bincount(label_array.ravel())
    mean = np.mean(sizes[1:])
    sd = np.std(sizes[1:])
    upper = mean + sd 
    lower = mean - sd 
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < lower or sizes[i] > upper:
            # Find all pixels for label
            where = np.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

#Load second filtered label into the array 
for i in range(len(label_array)):
    label_array[i] = filter_by_size_msd(label_array[i])
    
#Exercise 3
#Step 3.1 

#Hardcode genenames and fields_list for data selection
genenames = np.array(["APEX1", "APEX1", "PIM2", "PIM2", "POLR2B", "POLR2B", "SRSF1", "SRSF1"])
genenames_list = []
field_list = np.array(["field0", "field1", "field0", "field1", "field0", "field1", "field0", "field1"])
fields_list = []

#Create empty lists for data
nuclei = []
mean_PCNA = []
mean_nas_RNA = []
log2_ratio = []

#Sort through the nucleus for every gene and fields
for gene_field in range(len(label_array)):
    for nucleus in range(np.amax(label_array[gene_field]+1)): 
        if nucleus == 0: 
            continue 
        else: 
            #Identify each individual nucleus 
            where = np.where(label_array[gene_field] == nucleus)
            #Find nascent RNA and PCNA signals
            pcna = np.mean(allarrays[gene_field][where][1])
            nas_RNA = np.mean(allarrays[gene_field][where][2])
            ratio = np.log2(nas_RNA / pcna)
            #Load the data
            genenames_list.append(genenames[gene_field])
            fields_list.append(field_list[gene_field])
            nuclei.append(nucleus)
            mean_PCNA.append(pcna)
            mean_nas_RNA.append(nas_RNA)
            log2_ratio.append(ratio)

#Load data into a dataframe and into a file
nuclei_data = pd.DataFrame({'gene': genenames_list, 'field': fields_list, 'nucleus': nuclei, 'PCNA': mean_PCNA, 'nascentRNA': mean_nas_RNA, 'log2_ratio_nas_RNA_PCNA': log2_ratio})
nuclei_data.to_csv("Nuclei_data.csv", sep=",", header = True, index = False, mode = "w")
