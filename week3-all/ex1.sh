#!/usr/bin/env bash

#Q1
##1.1
awk 'NR%4 == 2 {print length($0)}' A01_09.fastq
#The length of the sequencing reads are 76
#Use NR%4 to divide the lines in the Fastq file and select just the second line (the sequence)
#length($0) gives the length of the whole line in our selected only sequence file

##1.2 
wc -l A01_09.fastq | awk '{print $1/4}'
#The amount of reads are 669548
#Use wc -l (count amount of lines) of the whole file
#We use awk to calculate the amount of total lines divided by 4 since .fastq is consists of 4-line blocks of the same read

##1.3 
bc -l -e "76 * 669548 / 12200000"
#The S. cerevisiae reference genome is about 12.2 Mb long
#Thus the depth of the read is about 4.171

##1.4
du -sh *.fastq
#The largest file is A01_62.fastq with 149 megabytes
#The smallest file is A01_27.fastq with 110 megabytes
#use -sh to make it humanly readable 

##1.5
fastqc *.fastq 
#use fastqc to create html website and inspect it 
#The median base quality is around 36 
#The probability of error is around 10^(3.6)=3981, thus the error rate is about 1 in 3981 base
#The average is about the same but the middle of the genome has less variation compared to the two ends of the read



