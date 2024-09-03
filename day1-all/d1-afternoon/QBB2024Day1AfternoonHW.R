##Q1
#load the packages
library(tidyverse)

#Read Metadata 
df <- read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

##Q2
#Examine data type and first entries of columns
glimpse(df)

##Q3 
#Filter RNA seq data
df_rnaseq <- subset(df, SMGEBTCHT == "TruSeq.v1")

##Q4
#Plot SMTSD data
ggplot(df_rnaseq, aes(x=SMTSD)) + 
  geom_bar() + 
  labs(x = "Tissue Type", y = "Amount of samples in each tissue") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

##Q5
#Plot SMRIN data
ggplot(df_rnaseq, aes(x=SMRIN)) + 
  geom_histogram(bins = 25) 
  #geom_density() can also be used to evaluate the distribution 
#The histogram is unimodal 

##Q6
#Stratifying the plot
ggplot(df_rnaseq, aes(x=SMRIN, y = SMTSD)) + 
  geom_boxplot() + 
  labs(x = "RNA Integrity Number", y = "Tissue Types")
#Boxplots allow us to visualize the difference between different tissues in terms of RNA integrity number
#There are sight difference across tissues, however, there are three outliers, e.g.the cells (Leukemia cell line, EBV lymphocytes, and fibroblasts) maintain their RNA integrity much better compare to their tissue counterparts
#The hypothesis is that, during the process of RNAseq, the mRNAs can be more easily extracted in cell lines compare to tissue cells. 
#The cell lines are grown in a more controlled environment while the tissue cells have more variation 

##Q7
#Visualize genes detected
ggplot(df_rnaseq, aes(x=SMGNSDTC, y = SMTSD)) + 
  geom_boxplot() + 
  labs(x = "Genes Detected", y = "Tissue Types")
#Similarly, boxplots allow us to visualize the difference between different tissues in terms of genes detected
#There are slight difference across tissues, however, there is one clear outlier, e.g. The testis has significantly more genes detected compare to any other tissue
#In the testis, the DNA sequence are more often repaired while having low mutation rate compare to other tissues. 
#Thus, the DNA sequence integrity in the testis is more greater than other tissues which resulted in the increased genes detected.

#Q8
#Relationship between Ischemic and RIN
ggplot(df_rnaseq, aes(x=SMTSISCH, y = SMRIN)) + 
  geom_point(size = 0.5, alpha = 0.5) + 
  geom_smooth(method = "lm") +
  facet_wrap(~ SMTSD) +
  labs(x = "Ischemic Time", y = "RNA Integrity Number")
#Generally, the RNA integrity number decreases as the ischemic time increases
#However, there are trends you can spot. Firstly, the brain/nerve tissues tend to have a lower rate of decrease as ischmeic time increase compare to organs
#A hypothesis could be that these tissues are the ones that needs to survive the longest as blood circulation is cutoff (ischemic time), thus having less of a dercease in RNA integrity.

#Q9
#Color by autolysis
ggplot(df_rnaseq, aes(x=SMTSISCH, y = SMRIN)) + 
  geom_point(size = 0.5, alpha = 0.5, aes(color=SMATSSCR)) + 
  geom_smooth(method = "lm") +
  facet_wrap(~ SMTSD) +
  labs(x = "Ischemic Time", y = "RNA Integrity Number", color = "Autolysis Score")
#The tissues with low autolysis score tend to not have significant RNA integrity number decrease as ischemic time went on.
#The autolysis score is the rate of cell destruction by their own enzymes, thus, if the score is lower, the cells would be less likely to be destructed and thus having a higher RNA integrity number. 

#10
#10.1 Distribution of total reads aligned
ggplot(df_rnaseq %>% filter(!is.na(SMMPPD)), aes(x = SMMPPD)) + 
  geom_histogram(bins=50) 


#10.2 Total reads aligned vs Genes detected across different tissues 
#Hypothesis: the genes detected increase until they plateau at one point as the total reads increase
ggplot(df_rnaseq %>% filter(!is.na(SMMPPD)), aes(x = SMMPPD, y = SMGNSDTC)) + 
  geom_point(aes(color = SMTS)) + 
  geom_smooth() + 
  facet_wrap(~ SMTS) + 
  theme(legend.position = "none")
#Conclusion: there is evidence proving the hypothesis 

