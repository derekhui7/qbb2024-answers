library(zellkonverter)
library(scuttle)
library(scater)
library(scran)
library(ggplot2)

#Step1
gut <- readH5AD( "~/qbb2024-answers/week8-all/v2_fca_biohub_gut_10x_raw.h5ad")
assayNames(gut) <- "counts"
gut <- logNormCounts(gut)
gut

#Q1
#13407 gene are quantitated
#11788 cells are included
#3 dimension reduction datasets are present
#X_pca, X_tsne, X_umap

colData(gut)
as.data.frame(colData(gut))
colnames(colData(gut))
View(columndata@metadata)
set.seed(1234)
plotReducedDim(gut, "X_umap", colour_by="broad_annotation")

#Q2
#There are 39 columns
#The broad_annotations are interesting since it help identify the cell cluster types
#Additionally, n_counts and n_genes both look interesting as they are important QC metrics


#Step2
genecount <- rowSums(assay(gut))
summary(genecount)
hist(genecount)
head(sort(genecount, decreasing=TRUE))

#Q3
#The mean is 3185 and the median is 254
#This distribution suggests that most genes are not highly expressed but there are some highly expressed genes
#The genes are Hsromega, CR45845, and roX1 and they are all RNAs

cellcounts <- colSums(assay(gut))
summary(cellcounts)
hist(cellcounts)

#Q4a
#The mean was 3622 
#Cells with over 10000 total counts probably come from very abundant and common cell types 

celldetected <- colSums(assay(gut)>0)
summary(celldetected)
hist(celldetected)

#Q4b
#The mean was 1059 
#1059/13407=0.0789=7.89%
#It accounts for about 7.89% of the genes.

mito <- grep(rownames(gut), pattern = "^mt:", value = TRUE)
df <- perCellQCMetrics(gut, subsets=list(Mito=mito))
df <- as.data.frame(df)
summary(df)
colData(gut) <- cbind( colData(gut), df)
mito_percent_reads <- plotColData(gut, "subsets_Mito_percent", "broad_annotation") + 
  theme( axis.text.x=element_text( angle=90 ) )
ggsave("~/qbb2024-answers/week8-all/Mitochondria_percent_reads.png", mito_percent_reads)

#Q5
#Enteroendocrine cells, epithelial cells, and somatic precursor cells have higher percentage of mitochondria reads
#They are likely more active cells that require more energy thus more mitochondria reads

#Q6a
coi <- colData(gut)$broad_annotation == "epithelial cell"
epi <- gut[,coi]
set.seed(1234)
epi_umap <- plotReducedDim(epi, "X_umap", colour_by="annotation")
ggsave("~/qbb2024-answers/week8-all/Epithelial_cell_umap.png", epi_umap)

marker.info <- scoreMarkers(epi,colData(epi)$annotation)
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]
ordered <- chosen[order(chosen$mean.AUC, decreasing=TRUE),]
head(ordered[,1:6])

epi_top_genes <- plotExpression(epi, c("Mal-A6","Men-b","vnd","betaTry","Mal-A1","Nhe2") , x = "annotation")
ggsave("~/qbb2024-answers/week8-all/Top_epithelial_marker_genes.png", epi_top_genes)

#Q6b 
#The top 6 genes are Mal-A6, Men-b, vnd, betaTry, Mal-A1, Nhe2.
#It would seem that the anterior adult focuses on the digestion of carbohydrate 

coi_soma <- colData(gut)$broad_annotation == "somatic precursor cell"
epi_soma <- gut[,coi_soma]
marker.info <- scoreMarkers(epi_soma,colData(epi_soma)$annotation)
chosen_soma <- marker.info[["intestinal stem cell"]]
ordered_soma <- chosen[order(chosen_soma$mean.AUC, decreasing=TRUE),]
goi <- rownames(ordered_soma)[1:6]
intsc_top_genes <- plotExpression(epi_soma, goi, x = "annotation")
ggsave("~/qbb2024-answers/week8-all/Top_somatic_precursor_marker_genes.png", intsc_top_genes)

#Q7
#Enteroblasts and intestinal stem cells are the more similar based on these markers 
#Dl seemed to be specific for intestinal stem cell


