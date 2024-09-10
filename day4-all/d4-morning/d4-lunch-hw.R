library(tidyverse)
library(broom)

expression_data <- read_tsv("/Users/cmdb/qbb2024-answers/day4-all/d4-morning/Expression_values.tsv")

names(expression_data) <- c("GeneID", "Tissue", "Expression")

pseudo_count <- 1

log_expression_data <- expression_data %>% 
  mutate(
    Tissue_Gene = paste0(Tissue, " ", GeneID),
    log_values = log10(Expression + pseudo_count)
    )


violin_plot <- ggplot(log_expression_data, aes(x = Tissue_Gene, y = log_values)) + 
  geom_violin() + 
  coord_flip() + 
  labs(
    x = "Tissue and Gene ID",
    y = "Log-transformed Gene Expression", 
    title = "Relationship between log10 transformed gene expression and tissue specific genes")

ggsave("d4-violin-plot.pdf", plot = violin_plot)

#Out of the all these tissues, they are differences between expression levels
#Testis and stomach had 3 highly expressed genes out of 4
#Small intestine had similar level of gene expression
#The Pituitary gland had 2 out of 3 high expression level
#Pancreas saw 8 of 13 of its genes express high levels which is varied
#Gene expression levels are heavily dependent on multiple factors, including tissue specificity and sample individuality
#The result does prove some of the hypothesis 
#Firstly, testis and stomach have the role to produce similar functions thus having low variability 
#Pancreas, on the other hand, have several functions as it has to produce several different proteins which calls for higher variability