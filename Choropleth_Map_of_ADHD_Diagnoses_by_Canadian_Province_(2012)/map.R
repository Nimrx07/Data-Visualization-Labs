# Load libraries
library(ggplot2)
library(sf)      # For handling spatial data
library(dplyr)   # For data manipulation
library(rnaturalearth)  # Provides Canada map
library(rnaturalearthdata)

# Load dataset
data1 <- read.csv("C:/InfoVisualization/assignment/mhi/mental_health_indicator.csv")

# Clean the dataset
data_cleaned <- data1 %>% 
  filter(Indicators == "Attention deficit disorder, current diagnosed condition") %>% 
  filter(Age.group == "Total, 15 years and over") %>% 
  filter(Gender == "Total, gender of person") %>% 
  filter(Characteristics == "Number of persons") %>% 
  filter(GEO != "Canada") %>% 
  na.omit()  # Remove rows with any missing values

# Check the cleaned data
head(data_cleaned)

# Load Canada provinces map
canada_map <- ne_states(country = "canada", returnclass = "sf")

# View column names in canada_map and data_cleaned
colnames(canada_map)
colnames(data_cleaned)

# Rename the column "GEO" to "name" for merging
data_cleaned <- data_cleaned %>% rename(name = GEO)

# Fix name in canada_map
canada_map <- canada_map %>%
  mutate(name = recode(name, "Québec" = "Quebec", "Ontario" = "Ontario"))

# Fix name in data_cleaned (ensure Quebec and Ontario match)
data_cleaned <- data_cleaned %>%
  mutate(name = recode(name, "Quebec" = "Québec", "Ontario" = "Ontario"))

# Create a data frame with the missing provinces/territories and their correct values
missing_values <- data.frame(
  name = c("Ontario","Quebec", "Yukon", "Nunavut", "Northwest Territories"),
  VALUE = c(230611,262586, 3724, 0, 0)  # Replace these with the correct values
)

# Merge the map with the ADHD dataset
canada_adhd <- left_join(canada_map, data_cleaned, by = "name")

# Now merge the missing values into the map dataset
canada_adhd <- canada_adhd %>%
  left_join(missing_values, by = "name", suffix = c("", "_missing"))

ontario_in_adhd <- canada_adhd %>% filter(name == "Ontario")
print(ontario_in_adhd)


# Use coalesce to ensure we use the correct VALUE (either from the original or missing_values)
canada_adhd <- canada_adhd %>%
  mutate(VALUE = coalesce(VALUE, VALUE_missing)) %>%
  select(-VALUE_missing)  # Remove the extra column after merging

# Check the rows to see if the missing values are now updated
canada_adhd %>%
  filter(name %in% c("Ontario","Quebec", "Yukon", "Nunavut", "Northwest Territories"))

# Check the result to make sure the merge worked
head(canada_adhd)

# Plot the map
p <- ggplot(canada_adhd) +
  geom_sf(aes(fill = VALUE), color = "black") +  # Fill provinces based on ADHD cases
  scale_fill_viridis_c(option = "magma", name = "ADHD Cases",
                       labels = scales::comma,  
                       limits = c(3724, 262586)) +  # Color scale
  labs(title = "ADHD Diagnoses by Province (2012)",
       subtitle = "Number of persons diagnosed with ADHD",
       caption = "Source: Mental Health Indicator Dataset") +
  theme_minimal()
print(p)


#p <- ggplot(data1, aes(x = time, y = adhd, group = 1)) + 
#  geom_line(color = "blue", size = 1) + 
#  geom_point(color = "red", size = 2) +  
#  labs(title = "ADHD Cases Over Time", x = "Time", y = "ADHD Cases") +
#  theme_minimal()
#print(p)
