library(tidyverse)
library(DESeq2)
library(broom)

#Step 1.1
#Set working directory
setwd("~/qbb2024-answers/week7-all/")

#Step 1.1.1
#Load metadata and data
metadata <- read_delim("gtex_metadata_downsample.txt")
whole_blood_data <- read_delim("gtex_whole_blood_counts_downsample.txt")
metadata[1:5,]
whole_blood_data[1:5,]

#Step 1.1.2
#Move subject id to row names
metadata <- column_to_rownames(metadata, var = "SUBJECT_ID")

#Step 1.1.3
#Move gene name to row names 
whole_blood_data <- column_to_rownames(whole_blood_data, var = "GENE_NAME")

#Step 1.1.4
#Inspect the tibbles
metadata[1:5,]
whole_blood_data[1:5,]

#Step 1.2
#Step 1.2.1
#Check the column counts are identical 
colnames(whole_blood_data) == rownames(metadata)
table(colnames(whole_blood_data) == rownames(metadata))

#Step 1.2.2
#Create DEseq object
dds <- DESeqDataSetFromMatrix(countData = whole_blood_data,
                                   colData = metadata,
                                   design = ~ SEX + AGE + DTHHRDY)

#Step 1.3
#Step 1.3.1
#Apply VST normalization
vsd <- vst(dds)

#Step 1.3.2
#Apply and plot principal components
SEXPCA <- plotPCA(vsd, intgroup = "SEX") + 
  labs(title= "PCA of Sex") 
AGEPCA <- plotPCA(vsd, intgroup = "AGE") + 
  labs(title= "PCA of Age") 
DeathPCA <- plotPCA(vsd, intgroup = "DTHHRDY") + 
  labs(title= "PCA of cause of death") 
ggsave("SexPCA.png",SEXPCA)
ggsave("AgePCA.png",AGEPCA)
ggsave("DeathPCA.png",DeathPCA)

#Step 1.3.3
#48% and 7%
#Cause of death explains about 48% of the variance as the PC1 axis 
#Age explains about 7% of the variance as the PC2 axis


#Step 2.1 
#Extract the normalized expression data and bind to metadata
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata, vsd_df)

#Test sex-differential expression of WASH7P
hist(vsd_df$WASH7P)
lm(data = vsd_df, formula = WASH7P ~ DTHHRDY + AGE + SEX) %>%
  summary() %>%
  tidy()

#Test sex-differential expression of SLC25A47
hist(vsd_df$SLC25A47)
lm(data = vsd_df, formula = SLC25A47 ~ DTHHRDY + AGE + SEX) %>%
  summary() %>%
  tidy()

#Step 2.1.1
#No, it doesn't seem to have significant effect on expression change based on sex
#The p-value of 2.79e-1 is greater than p=0.05, making it statistically insignificant 

#Step 2.1.2
#Yes, it does seem to have significant effect on expression when the sample is male
#The p-value of 2.57e-2 is less than p=0.05, making it statistically significant 

#Step 2.2
#Step 2.2.1
#Use DESeq2 to perform differential expression analysis across all genes
dds <- DESeq(dds)

#Step 2.3
#Step 2.3.1
whole_blood_res <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")

#Step 2.3.2
#Remove N/A padj values
whole_blood_res <- whole_blood_res %>%
  filter(!is.na(padj)) %>%
  arrange(padj)

#Select padj values < 0.1
whole_blood_res %>%
  filter(padj < 0.1) %>% 
  nrow()
#262 genes show significant differential expression between male and female at 10% FDR

#Step 2.3.3
#Load the gene location data
gene_loci <- read_delim("gene_locations.txt")
#Merge the data 
merged_df <- left_join(whole_blood_res, gene_loci, by = "GENE_NAME") %>% 
  arrange(padj)
#The top differential expression genes were exclusively found on sex chromosomes
#It matches with our prediction as we focused on the sex difference 
#The genes are mainly male-upregulated since female gene expression levels were used as a reference

#Step 2.3.4
#Examine WASH7P
merged_df %>% filter(GENE_NAME == "WASH7P")

#Examine SLC25A47
merged_df %>% filter(GENE_NAME == "SLC25A47")
#The result is consistent since WASH7P is not a part of the padj < 0.1 gene groups
#SLC25A47, however is part of the 10% FDR dataset 

#Step 2.4
#Step 2.4.1
#Use DESeq2 to perform differential expression analysis across all genes
dds <- DESeq(dds)

whole_blood_death_res <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_NAME")

whole_blood_death_res <- whole_blood_death_res %>%
  filter(!is.na(padj)) %>%
  arrange(padj)

whole_blood_death_res %>%
  filter(padj < 0.1) %>% 
  nrow()
#16069 genes were marked as differentially expressed using the 10% FDR threshold

#Step 2.4.2
#The result makes sense since sex only explains 7% of the variance while cause of death explains 48% 
#Thus, since 48% of these genes are investigated in the filtered dataset, it makes sense to have more genes 

#Step 3 
#Step 3.1 
VolcanoPlot <- ggplot(data = whole_blood_res, aes(x = log2FoldChange, y = -log10(pvalue))) +
  geom_point(aes(color = (abs(log2FoldChange) > 1 & -log10(padj) > 1))) +
  geom_text(data = whole_blood_res %>% filter(abs(log2FoldChange) > 2 & -log10(padj) > 100),
            aes(x = log2FoldChange, y = -log10(padj) + 5, label = GENE_NAME), size = 3,) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("darkgray", "coral")) +
  labs(title = "Volcano Plot", y = expression(-log[10]("padj")), x = expression(log[2]("fold change"))) 
ggsave("VolcanoPlot.png",VolcanoPlot)
