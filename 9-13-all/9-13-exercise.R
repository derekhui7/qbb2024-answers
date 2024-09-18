library(tidyverse)
library(ggplot2)

##Q1.2
##Load the genome distribution data
#poisson_data <- read_tsv("/Users/cmdb/qbb2024-answers/9-13-all/poisson_estimates.txt")
#names(poisson_data) <- c("entries")

#Plot a histogram plot using the data and label it 
#p_histogram <- ggplot(poisson_data, aes(x = entries)) + 
  #geom_histogram(binwidth = 1) + 
  #labs(title = "Plot of the genome coverage using python simulation, poisson, and normal simulation",
       #x = "Genome coverage",
       #y = "Frequency")

##Assign values to help R create distributions
#mean <- 3
#sd <- sqrt(3)
#genome_length <- 1000000

##Poisson distribution
### Create the distribution and normalize it by multiplying the genome length 
#poisson_R_3 <- dpois(poisson_data$entries, lambda = 3)*genome_length
##Overlay onto the previous distribution 
#overlay_plot_poisson <- p_histogram +
  #geom_line(aes(x = poisson_data$entries, y = poisson_R_3), color = "salmon", linewidth = 1, linetype = "solid")
#overlay_plot_poisson

#Normal distribution
## Create the distribution and normalize it by multiplying the genome length 
#normal_R_3 <- dnorm(poisson_data$entries, mean = mean, sd = sd)*genome_length
#Overlay onto the previous distribution
#overlay_plot_p_n <- p_histogram +
  #geom_line(aes(x = poisson_data$entries, y = poisson_R_3), color = "salmon", linewidth = 1, linetype = "solid") +
  #geom_line(aes(x = poisson_data$entries, y = normal_R_3), color = "magenta", linewidth = 1, linetype = "solid")
#overlay_plot_p_n

#View the amount of nucleotides that have not been covered
#poisson_0 <- sum(poisson_data == 0)
#print(poisson_0)
#The amount of 0s is 45787 using our simulation 

#View the amount of nucleotides that have not been covered
#View(poisson_R_3)
#The amount of 0s estimated is 49787 using the poisson R simulation

#View the amount of nucleotides that have not been covered
#View(normal_R_3)
#The amount of 0s estimated is 51393 using the normal R simulation
#ggsave("ex1_3x_cov.png", plot = overlay_plot_p_n)


#Q1.5
#Load the genome distribution data
#poisson_data_10X <- read_tsv("/Users/cmdb/qbb2024-answers/9-13-all/poisson_estimates_10X.txt")
#names(poisson_data_10X) <- c("entries")

#Plot a histogram plot using the data and label it 
#p_histogram_10X <- ggplot(poisson_data_10X, aes(x = entries)) + 
 # geom_histogram(binwidth = 1) + 
  #labs(title = "Plot of the genome coverage using python simulation, poisson, and normal simulation",
   #    x = "Genome coverage",
    #   y = "Frequency")

#Assign values to help R create distributions
#mean <- 10
#sd <- sqrt(10)
#genome_length <- 1000000

#Poisson distribution
## Create the distribution and normalize it by multiplying the genome length 
#poisson_R_10 <- dpois(poisson_data_10X$entries, lambda = 10)*genome_length
#Overlay onto the previous distribution 
#overlay_plot_poisson_10 <- p_histogram_10X +
 # geom_line(aes(x = poisson_data_10X$entries, y = poisson_R_10), color = "salmon", linewidth = 1, linetype = "solid")
#overlay_plot_poisson_10

#Normal distribution
## Create the distribution and normalize it by multiplying the genome length 
#normal_R_10 <- dnorm(poisson_data_10X$entries, mean = mean, sd = sd)*genome_length
#Overlay onto the previous distribution
#overlay_plot_p_n_10 <- p_histogram_10X +
 # geom_line(aes(x = poisson_data_10X$entries, y = poisson_R_10), color = "salmon", linewidth = 1, linetype = "solid") +
  #geom_line(aes(x = poisson_data_10X$entries, y = normal_R_10), color = "magenta", linewidth = 1, linetype = "solid")
#overlay_plot_p_n_10

#View the amount of nucleotides that have not been covered
#poisson_0_10 <- sum(poisson_data_10X == 0)
#print(poisson_0_10)
#The amount of 0s is 76 using our simulation 

#View the amount of nucleotides that have not been covered
#View(poisson_R_10)
#The amount of 0s estimated is 45.4 using the poisson R simulation

#View the amount of nucleotides that have not been covered
#View(normal_R_10)
#The amount of 0s estimated is 850 using the normal R simulation
#ggsave("ex1_10x_cov_.png", plot = overlay_plot_p_n_10)

#Q1.6
#Load the genome distribution data
poisson_data_30X <- read_tsv("/Users/cmdb/qbb2024-answers/9-13-all/poisson_estimates_30X.txt")
names(poisson_data_30X) <- c("entries")

#Plot a histogram plot using the data and label it 
p_histogram_30X <- ggplot(poisson_data_30X, aes(x = entries)) + 
  geom_histogram(binwidth = 1) + 
  labs(title = "Plot of the genome coverage using python simulation, poisson, and normal simulation",
       x = "Genome coverage",
       y = "Frequency")

#Assign values to help R create distributions
mean <- 30
sd <- sqrt(30)
genome_length <- 1000000

#Poisson distribution
## Create the distribution and normalize it by multiplying the genome length 
poisson_R_30 <- dpois(poisson_data_30X$entries, lambda = 30)*genome_length
#Overlay onto the previous distribution 
overlay_plot_poisson_30 <- p_histogram_30X +
  geom_line(aes(x = poisson_data_30X$entries, y = poisson_R_30), color = "salmon", linewidth = 1, linetype = "solid")
overlay_plot_poisson_30

#Normal distribution
## Create the distribution and normalize it by multiplying the genome length 
normal_R_30 <- dnorm(poisson_data_30X$entries, mean = mean, sd = sd)*genome_length
#Overlay onto the previous distribution
overlay_plot_p_n_30 <- p_histogram_30X +
  geom_line(aes(x = poisson_data_30X$entries, y = poisson_R_30), color = "salmon", linewidth = 1, linetype = "solid") +
  geom_line(aes(x = poisson_data_30X$entries, y = normal_R_30), color = "magenta", linewidth = 1, linetype = "solid")
overlay_plot_p_n_30

#View the amount of nucleotides that have not been covered
poisson_0_30 <- sum(poisson_data_30X == 0)
print(poisson_0_30)
#The amount of 0s is 76 using our simulation 

#View the amount of nucleotides that have not been covered
View(poisson_R_30)
#The amount of 0s estimated is 45.4 using the poisson R simulation

#View the amount of nucleotides that have not been covered
View(normal_R_30)
#The amount of 0s estimated is 850 using the normal R simulation
ggsave("ex1_30x_cov_.png", plot = overlay_plot_p_n_30)