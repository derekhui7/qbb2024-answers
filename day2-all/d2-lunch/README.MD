# d2-lunch answers 

## Answer 1 

- 'cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c' 
- There are 19618 protein_coding genes
- lncRNA, because they are important to modulate the chromatin functions and structure

## Answer 2 

- 'cut -f 1 hg38-gene-metadata-go.tsv | uniq -c | sort -n'
- ENSG00000168036 has the most go_ids at 273
- 'sort -f -k 3 hg38-gene-metadata-go.tsv | grep "ENSG00000168036" > hg38-gene-metadata-go-ENSG00000168036.tsv | less -S'
- Sorted by alphabetical order in name_1006 column, and filter all rows with ENSG00000168036 and view 
- Based on the go terms, we suspect that this gene is a key factor in determining cell fate decisions and development. 

## Answer 3 

- 'grep "IG_._gene" genes.gtf | cut -f 1 | uniq -c | sort -n'
-  IG_gene distribution: 1 in chr21, 6 in chr16, 16 in chr15, 48 in chr22, 52 in chr2, 91 in chr14 
- 'grep "IG_.*pseudogene" genes.gtf | cut -f 1 | uniq -c | sort -n'
-  IG_pseudogene distribution: 1 in chr1, 1 in chr10, 1 in chr18, 1 in chr8, 5 in chr9, 6 in chr15, 8 in chr16, 45 in chr2, 48 in chr22, 84 in chr14
- The distribution of gene vs pseudogene is quite similar 

## Answer 4

- Because if we just use the grep pseudogene code, it collects any row containing the word pseudogene which includes the "overlaps_pseudogene" in tags rather than in gene_types which we want. A better code would be shown in line below
- 'grep "gene_type \".*_pseudogene\";" genes.gtf | cut -f 1 | uniq -c'
- Look for any word that contains "gene_type ".*_pseudogene";" using grep command so that any word containing these characters would be filtered.

## Answer 5 

- "sed "s/ /\t/g" genes.gtf > gene-tabs.gtf"
- To change the tabs into spaces 
- "cut -f 1,4,5,14 gene-tabs.gtf > gene-tabs.bed"
- Print out the desired fields into a bed file



