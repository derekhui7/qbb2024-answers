#!/bin/bash 

#Q1
##1.1
tar xzf chr1_snps.tar.gz

##1.4
#Sort and merge the gene.bed files 
bedtools sort -i V46_chr1_tx.bed | bedtools merge -i V46_chr1_tx.bed > genes_chr1.bed 
#Sort exons first and then merged
bedtools sort -i V46_chr1_exon.bed > sorted_V46_chr1_exon.bed
bedtools merge -i sorted_V46_chr1_exon.bed > exons_chr1.bed
#Merged chromosomes
 bedtools sort -i V46_chr1_chrom.bed | bedtools merge -i V46_chr1_chrom.bed > cCREs_chr1.bed

##1.5
#Use subtract
bedtools subtract -a genes_chr1.bed -b exons_chr1.bed > introns_chr1.bed 

##1.6
#Use subtract again 
bedtools subtract -a genome_chr1.bed -b exons_chr1.bed introns_chr1.bed cCREs_chr1.bed > other_chr1.bed

#Q2
##2.1
#Create the results file with a header
echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt
#Loop through each possible MAF value
for MAF in 0.1 0.2 0.3 0.4 0.5
do
    #Use the MAF value to get the file name for the SNP MAF file
    SNPMFAfile=chr1_snps_${MAF}.bed
    #Find the SNP coverage of the whole chromosome
    bedtools coverage -a genome_chr1.bed -b ${SNPMFAfile} > coverage${MFA}.txt
    #Since the SNPs are reported by bedtools coverage in column 4 while the lengths of bases are reported in column 6
    #Sum SNPs from coverage by summing column 4
    SNPSUM=$(awk '{s+=$4}END{print s}' coverage${MFA}.txt)
    #Sum total bases from coverage by summing column 6
    BaseSUM=$(awk '{s+=$6}END{print s}' coverage${MFA}.txt)
    #Since SNP density = total SNP/chrom length), calculate the SNP density
    SNPdensity=$(bc -l -e " ${SNPSUM} / ${BaseSUM}")
    #Loop through each feature name
    for Feature in exons cCREs introns other
    do 
        #Use the feature value to get the file name for the feature file
        Featurefile=${Feature}_chr1.bed 
        #Find the SNP coverage of the current feature
        bedtools coverage -a ${Featurefile} -b ${SNPMFAfile} > coverage${Featurefile}_${MFA}.txt
        #Since the SNPs are reported by bedtools coverage in column 4 while the lengths of bases are reported in column 6
        #Sum SNPs from coverage from column 4
        FSNPSUM=$(awk '{s+=$4}END{print s}' coverage${Featurefile}_${MFA}.txt)
        #Sum total bases from coverage from column 6
        FBaseSUM=$(awk '{s+=$6}END{print s}' coverage${Featurefile}_${MFA}.txt)
        #Since SNP density = total SNP/chrom length), calculate the SNP density for features
        FSNPdensity=$(bc -l -e " ${FSNPSUM} / ${FBaseSUM}")
        #Enrichment is the feature density relative to the original SNP density 
        Enrichment=$(bc -l -e " ${FSNPdensity} / ${SNPdensity}")
        #Save result to results file by appending to the file created using >> 
        echo -e "${MAF}\t${Feature}\t${Enrichment}" >> snp_counts.txt
    done 
done 

#Ran the bash script using chmod +x and ./ 

##2.2 
#See R file 

##2.3 
#See README.md