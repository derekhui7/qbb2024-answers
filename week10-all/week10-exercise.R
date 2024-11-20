library(tidyverse)

#Load the file
nuclei_df <- read_csv("~/qbb2024-answers/week10-all/Nuclei_data.csv")

#Create violin plot for nascentRNA, PCNA, and the ratio 
nRNAplot <- ggplot(nuclei_df, aes(gene, nascentRNA)) + 
  geom_violin(fill = "cyan", alpha = 0.7) + 
  stat_summary(fun = median, geom = "crossbar", width = 0.5, color = "black") + 
  labs(title = "Nascent RNA Signal by Gene Knockdown",
       x = "Gene",
       y = "Nascent RNA Signal") 

ggsave("~/qbb2024-answers/week10-all/NascentRNASignal.png", nRNAplot)

PCNAplot <- ggplot(nuclei_df, aes(gene, PCNA)) + 
  geom_violin(fill = "maroon", alpha = 0.7) + 
  stat_summary(fun = median, geom = "crossbar", width = 0.5, color = "black") + 
  labs(title = "PCNA Signal by Gene Knockdown",
       x = "Gene",
       y = "PCNA Signal") 

ggsave("~/qbb2024-answers/week10-all/PCNASignal.png", PCNAplot)

ratioplot <- ggplot(nuclei_df, aes(gene, log2_ratio_nas_RNA_PCNA)) + 
  geom_violin(fill = "magenta", alpha = 0.7) + 
  stat_summary(fun = median, geom = "crossbar", width = 0.5, color = "black") + 
  labs(title = "Log2 Ratio of Nascent RNA vs PCNA Signal by Gene Knockdown",
       x = "Gene",
       y = "Log2 Ratio of Nascent RNA vs PCNA Signal")

ggsave("~/qbb2024-answers/week10-all/Ratioplot.png", ratioplot)


