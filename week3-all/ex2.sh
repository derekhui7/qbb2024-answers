#!/usr/bin/env bash

#Q2
##2.1
wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
gunzip sacCer3.fa.gz
#Obtain the file from online
bwa index sacCer3.fa
#Create index for the file
###Q2.1
grep "^>" sacCer3.fa
#Identify the things that were grepped
grep -c "^>" sacCer3.fa
#Identify the amount of lines 
# cat sacCer3.fa.amb | less -S can also help inspect the amount of chromosomes
#If we include mitochondria chromosome (chrM) as a chromosome, then we have 17 chromosomes for yeast
#If we don't then it would be 16

##2.2 
#select the our desired samples
for my_sample in A01_*.fastq
do 
    #obtain the sample names in a variable 
    my_sample=`basename ${my_sample} .fastq`
    #echo ${my_sample}
    #Use -t to get 3 computer cores to process faster, added headerline using -R and use bwa mem to pipe into a sam file 
    bwa mem -t 3 -R "@RG\tID:${my_sample}\tSM:${my_sample}" sacCer3.fa ${my_sample}.fastq > ${my_sample}.sam
    #Use samtools sort to obtain a bam file from our sam file
    samtools sort -@ 4 -O bam -o ${my_sample}.bam ${my_sample}.sam
    #index the bam file
    samtools index ${my_sample}.bam
done

##2.3
###Q2.2
#grep only the lines that start with HWI-ST387 which are the read sequence files and use wc to count amount of lines
grep "^HWI-ST387" A01_09.sam | wc -l
#669548 read alignments were recorded 

###Q2.3
#grep only the lines that contain chrIII which are the read sequence on chromosome III and use wc to count lines 
grep -w "chrIII" A01_09.sam | wc -l
#18196 reads are to loci on chromosome III

###Q2.4 
#See previous code in 2.2 

#2.5
###Q2.4
#If we take the average of all coverage depth, we may get a similar result as in Step1.3
#However, there are multiple regions with no coverage while other regions with way more than 4 coverage 
#The coverage is not uniform 

###Q2.5
#Three SNPs are clearly visible
#two SNPs have 4 reads which make us more confident
#one SNP has only 2 read which could be down to sequencing errors

###Q2.6
#The SNP exists at chromIII: 825834
#The SNP is between 2 genes, SCC2 and SAS4 so it does not fall within a gene 