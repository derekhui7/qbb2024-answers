library(tidyverse)
library(palmerpenguins)
library(ggthemes)

?penguins
glimpse(penguins)

penguins[2:39 , c("island","species")]

penguins <- penguins
ggplot(penguins, aes(x=flipper_length_mm, y=body_mass_g)) + 
  geom_point(aes(color = species, shape = species)) + 
  scale_color_colorblind() +
  #scale_color_manual(values = c("maroon", "turquoise", "magenta")) +
  geom_smooth(method = "lm") + 
  xlab("Flipper Length (mm)") + 
  ylab("Body Mass (g)") + 
  labs(title = "Relationship between body mass and flipper length", color = "Species", shape = "Species")
ggsave(filename = "~/qbb2024-answers/d1-afternoon/penguin-plot.pdf")

####

#does bill length or depth depend on sex of the penguins 

ggplot(penguins %>% filter (!is.na(sex)), aes(x = bill_length_mm, fill = sex)) + 
  geom_histogram(bins = 20) + 
  scale_fill_colorblind() + 
  facet_grid(sex ~ species)

#Bodymass change depend on year 
ggplot(penguins %>% filter(!is.na(sex)), aes(x = factor(year), y=body_mass_g)) + 
  geom_violin(aes(fill = sex)) + 
  facet_grid(island ~ species)




