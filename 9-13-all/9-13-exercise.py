#!/usr/bin/env python3

#Import packages
# import numpy as np 
# import scipy as sp


# #Q1.2
# #Assign relevant parameters
# genomesize = 1000000
# readlength = 100 
# coverage = 3
# num_reads = int(genomesize *  coverage / readlength)

# #Create an array to keep track of the coverage at each position in the genome
# genomecoverage = np.zeros(genomesize, int)

# #Make a random number generator in a uniform distribution and simulate the reading process 
# for i in range(num_reads):

#   startpos = sp.stats.uniform.rvs(1,genomesize-readlength+1)
#   endpos = startpos + readlength 
#   genomecoverage[int(startpos):int(endpos)] += 1

# np.savetxt('poisson_estimates.txt', genomecoverage, fmt='%d', header = "entries")

# #Q1.3
# #Assign relevant parameters
# genomesize = 1000000
# readlength = 100 
# coverage = 10
# num_reads = int(genomesize *  coverage / readlength)

# #Create an array to keep track of the coverage at each position in the genome
# genomecoverage = np.zeros(genomesize, int)

# #Make a random number generator in a uniform distribution and simulate the reading process 
# for i in range(num_reads):

#   startpos = sp.stats.uniform.rvs(1,genomesize-readlength+1)
#   endpos = startpos + readlength 
#   genomecoverage[int(startpos):int(endpos)] += 1

# np.savetxt('poisson_estimates_10X.txt', genomecoverage, fmt='%d', header = "entries")

# #Q1.6
# #Assign relevant parameters
# genomesize = 1000000
# readlength = 100 
# coverage = 30
# num_reads = int(genomesize *  coverage / readlength)

# #Create an array to keep track of the coverage at each position in the genome
# genomecoverage = np.zeros(genomesize, int)

# #Make a random number generator in a uniform distribution and simulate the reading process 
# for i in range(num_reads):

#   startpos = sp.stats.uniform.rvs(1,genomesize-readlength+1)
#   endpos = startpos + readlength 
#   genomecoverage[int(startpos):int(endpos)] += 1

# np.savetxt('poisson_estimates_30X.txt', genomecoverage, fmt='%d', header = "entries")

#2.1 
reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']
graph = set()

edges = {}
print("digraph {")
for read in reads: 
   for i in range(len(read) - 3):
     kmer1 = read[i: i+3]
     kmer2 = read[i+1: i+1+3]
     graph.add((kmer1, kmer2))
     edge = (kmer1, kmer2)
     edges.setdefault(edge, 0)
     edges[edge] += 1
     print(kmer1 + "->" + kmer2)
print("}")
# for edge in edges.keys():
#     line = edge
#     print(edge)


