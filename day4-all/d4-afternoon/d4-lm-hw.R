library(tidyverse)
library(broom)

#1.1
aau_dnm <- read_csv("/Users/cmdb/qbb2024-answers/day4-all/d4-afternoon/aau1043_dnm.csv")

#1.2
#count number of maternal vs paternal DNMs
aau_d_summary <- aau_dnm %>%
  group_by(Proband_id) %>%
  summarise(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))

aau_dnm_f <- subset(aau_dnm, Phase_combined == "father") 
aau_dnm_m <- subset(aau_dnm, Phase_combined == "mother") 

#20598 paternally inherited data and 5061 materally inherited data 

#1.3
aau_age <- read_csv("/Users/cmdb/qbb2024-answers/day4-all/d4-afternoon/aau1043_parental_age.csv")

#1.4 
aau_combined <- left_join(aau_d_summary, aau_age, by = "Proband_id")

#2.1
ggplot(aau_combined, aes(x = Mother_age, y = n_maternal_dnm)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  labs(x = "Mother age (years)", y = "The count for maternal DNMs")

ggplot(aau_combined, aes(x = Father_age, y = n_paternal_dnm)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  labs(x = "Father age (years)", y = "The count for paternal DNMs")

#2.2
#Mother model
lm(aau_combined, formula = n_maternal_dnm ~ 1 + Mother_age) %>%
  summary()
#The coefficient on the mother's age is 0.37757 which means that for every year the mother gets older, the number of maternal dnms increase by 0.37757
#The p-value of 2^(-16) indicates that it is a statistically significant relationship and it has a quite significant impact
#The R^2 value, however, suggests only 22.55% of the data can be explained through the model


#2.3
#Father model
lm(aau_combined, formula = n_paternal_dnm ~ 1 + Father_age) %>%
  summary()
#The coefficient on the mother's age is 1.35384 which means that for every year the father gets older, the number of paternal dnms increase by 1.35384
#The p-value of 2^(-16) indicates that it is a statistically significant relationship
#As mentioned before, the R^2 value suggests that 61.78% of the data can be explained through the model
#The association is significant as the p-value for the F-statistic is less than 0.001

#2.4
given_father_age <- 50.5
predicted_pdnm <- 10.32632 + 1.35384*given_father_age
predicted_pdnm
#The predicted amount of mutation is then estimated to be 78.69524

#2.5
ggplot(aau_combined) + 
  geom_histogram(aes(x = n_paternal_dnm, fill = 'plum'), alpha = 0.5) + 
  geom_histogram(aes(x = n_maternal_dnm, fill = 'salmon'), alpha = 0.5) +
  labs(x = "number of DNMs", fill = "Father(plum) vs Mother(salmon)")

#2.6
anova(aau_combined)

aau_combined$n_paternal_dnm
rep("Paternal" , times = length(aau_combined$n_paternal_dnm))

testDf <- data.frame(
  n_dnm = c(aau_combined$n_paternal_dnm, aau_combined$n_maternal_dnm),
  parent = c(rep("Paternal" , times = length(aau_combined$n_paternal_dnm)),
                 rep("Maternal" , times = length(aau_combined$n_maternal_dnm)))
)

anova_result <- aov(n_dnm ~ parent, data = testDf)
summary(anova_result)
#I used the anova test to understand the variance of the two groups and thus comparing them to see the difference between the two 
#While a two-way T-test would have worked, the anova test would have worked for even more variables than two that we tested for
#Since we get the p-value of <2^(-16) from anova which is significant, we can confidently say that there is a difference between paternal and materal DNMs.

