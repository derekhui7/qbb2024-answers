#load required packages 
library("tidyverse")
library(ggplot2)

#Load sample data 
df <- read_tsv("~/temp/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#group all samples with subject being the first column
df <- df %>% 
  mutate(SUBJECT=str_extract(SAMPID, "[^-]+-[^-]+"), .before=1)

View(df)

#group samples and then arrange based on sample count (Ascending)
df %>%
  group_by(SUBJECT) %>% 
  summarize(sample_count = n()) %>%
  arrange(sample_count)

##Subject with least sample: GTEX-1JMI6, GTEX-1PAR6 with 1 sample 
# (Descending)
df %>%
  group_by(SUBJECT) %>% 
  summarize(sample_count = n()) %>%
  arrange(-sample_count)

##Subject with the most sample: K-562 with 217 samples, and GTEX-NPJ8 with 72 samples 

#group samples and then arrange based on tissue types (SMTSD) (Ascending)
df %>%
  group_by(SMTSD) %>% 
  summarize(tissuetype_count = n()) %>%
  arrange(tissuetype_count)

##Kidney Medulla has the lowest sample count with 4 samples, and Cervix-Etocervix with 9 samples 
#(Descending)
df %>%
  group_by(SMTSD) %>% 
  summarize(tissuetype_count = n()) %>%
  arrange(-tissuetype_count)

##Whole blood has the most sample count with 3288 samples, and Muscle-Skeletal with 1132 samples

#Subset GTEX-NPJ8
df_npj8 <- subset(df, SUBJECT == "GTEX-NPJ8")

#Count the most Tissue Samples within GTEX-NPJ8
df_npj8 %>%
  group_by(SMTSD) %>% 
  summarize(tissuetype_count = n()) %>%
  arrange(-tissuetype_count)

## Whole blood has 9 samples 
df_npj8_wholeblood <- subset(df_npj8, SMTSD == "Whole Blood")
View(df_npj8_wholeblood)
##Difference in batches (date), and sequencing tools


#autolysis Score
df %>%
  filter( !is.na(SMATSSCR) ) %>%
  group_by(SUBJECT) %>% 
  summarize(mean_value = mean(SMATSSCR)) 
  count(mean_value == 0) 

## 15 subjects has SMATSSCR mean of 0 

#identifying the distribution of mean scores
df_mean_subject <- df %>%
  filter( !is.na(SMATSSCR) ) %>%
  group_by(SUBJECT) %>% 
  summarize(mean_value = mean(SMATSSCR)) 
  
ggplot(df_mean_subject, aes(x = mean_value)) + 
  geom_histogram(bins = 20)






  

  



