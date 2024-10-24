#Load the required libraries 
library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(hexbin)
library(ggfortify)

#Load the file 
RNAseq_data <- readr::read_tsv("/Users/cmdb/qbb2024-answers/week5-all/salmon.merged.gene_counts.tsv")
#Convert gene names into row names 
RNAseq_data <- column_to_rownames(RNAseq_data, var="gene_name")
#Remove the gene ID column
RNAseq_data <- RNAseq_data %>% select (-gene_id)
#Change data into integers 
RNAseq_data <- RNAseq_data %>% mutate_if(is.numeric, as.integer)
#Filter low coverage data 
RNAseq_data <- RNAseq_data[rowSums(RNAseq_data) > 100,]
#Select narrow data 
narrow <- RNAseq_data %>% select("A1_Rep1":"P2-4_Rep3")
#Create metadata tibble
narrow_metadata <- tibble(tissue=as.factor(c("A1", "A1", "A1", "A2-3", "A2-3", "A2-3", "Cu", "Cu", "Cu", "LFC-Fe", "LFC-Fe", "Fe", "LFC-Fe", "Fe", "Fe", "P1", "P1", "P1", "P2-4", "P2-4", "P2-4")),
                        rep=as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 1, 3, 2, 3, 1, 2, 3, 1, 2, 3)))
#Create DESeq data object 
narrowdata <- DESeqDataSetFromMatrix(countData=as.matrix(narrow), colData=narrow_metadata, design=~tissue)
#Correct batch effects
narrowVstdata = vst(narrowdata)
#Remove mean and variance relationship 
meanSdPlot(assay(narrowVstdata))
#Create and plot the PCA data
narrowPcaData = plotPCA(narrowVstdata,intgroup=c("rep","tissue"), returnData=TRUE)
ggplot(narrowPcaData, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5) + 
  labs(title = "PCA plot of midgut tissues") +
  ggsave("~/qbb2024-answers/week5-all/PCAPlot.png")
#Convert into a matrix
matnarrow = as.matrix(assay(narrowVstdata))
#Find replicate means
combined = matnarrow[,seq(1, 21, 3)]
combined = combined + matnarrow[,seq(2, 21, 3)]
combined = combined + matnarrow[,seq(3, 21, 3)]
combined = combined / 3
#Filter low variance genes out
filt = rowSds(combined) > 1
matnarrow = matnarrow[filt,]
#Plot heat map of expressions and clusters
set.seed(42)
k=kmeans(matnarrow, centers=12)$cluster
#Put samples into clusters
ordering = order(k)
#Reorder gene
k = k[ordering]
matnarrow <- matnarrow[ordering,]
#Plot heatmap
heatmap(matnarrow,Rowv=NA,Colv=NA,RowSideColors = RColorBrewer::brewer.pal(12,"Paired")[k])
#Save heatmap
png("~/qbb2024-answers/week5-all/heatmap.jpg")
heatmap(matnarrow,Rowv=NA,Colv=NA,RowSideColors = RColorBrewer::brewer.pal(12,"Paired")[k])
dev.off()
#Pull gene from cluster 1 
genes = rownames(matnarrow[k==1,])
write.table(genes, "~/qbb2024-answers/week5-all/cluster1.txt",sep="\n", quote=FALSE, row.names=FALSE, col.names = FALSE)
