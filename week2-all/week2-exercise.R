library(tidyverse)

#Load data
snpdata <- read_tsv("/Users/cmdb/qbb2024-answers/week2-all/snp_counts.txt")

#Log transform data 
log_snpdata <- snpdata %>% 
  mutate(
    log_enrichment = log2(Enrichment)
  )

#Subset data
exons <- subset(log_snpdata, Feature == "exons")
cCRES <- subset(log_snpdata, Feature == "cCREs")
introns <- subset(log_snpdata, Feature == "introns")
other <- subset(log_snpdata, Feature == "other")

#Plot the data 
snp_enrichment <- ggplot() + 
  geom_line(exons, mapping = aes(MAF, log_enrichment, color = "exons")) + 
  geom_line(cCRES, mapping = aes(MAF, log_enrichment, color = "cCREs")) + 
  geom_line(introns, mapping = aes(MAF, log_enrichment, color = "introns")) + 
  geom_line(other, mapping = aes(MAF, log_enrichment, color = "other")) + 
  labs(x = "MAF", y = "Log2 transformed enrichment", title = "MAF vs Enrichment", colour = "Legend")
#Save the plot 
ggsave("/Users/cmdb/qbb2024-answers/week2-all/snp_enrichments.pdf", plot = snp_enrichment)
