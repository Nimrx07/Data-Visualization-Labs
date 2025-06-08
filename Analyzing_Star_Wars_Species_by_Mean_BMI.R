library(dplyr)
library(stringr)
library(ggplot2)

  # 1. Filters species that end with “man” or start with G, D, or W
plot_data <- starwars %>%
  filter(str_detect(species, "^[GDW]|man$")) %>%
  
  # 2. Calculates BMI for each character and the mean BMI for each species 
  mutate(BMI = mass / ((height / 100) ^ 2)) %>%
  group_by(species) %>%
  summarize(Mean_BMI = mean(BMI, na.rm = TRUE)) %>%
  
  # 3. Creates a column called is_bigger, labeled as "yes" if BMI exceeds 30, otherwise labeled as "no."
  ungroup() %>%
  mutate(is_bigger = if_else(Mean_BMI > 30, "yes", "no"))

  # 4 & 5. Creates a bar graph with axes and title

plot <- ggplot(plot_data, aes(x = species, y = Mean_BMI, fill = is_bigger)) +
  geom_col(position = "dodge") +
  labs(title = "The biggest species in Star Wars",
       x = "Species",
       y = "Body mass index (kg/m^2)",
       fill = "BMI > 30") +
  
  
 # Prints the plot
print(plot)  

