# Load the data
load("C:/R-Language/Ontario.RDATA")

# Part 1
library(ggplot2)
library(scales)

# Creates scatterplot with smoothing regression fit
plot <- ggplot(df_on, aes(x = Year, y = Population)) +
  geom_point() +
  geom_smooth(method = "loess", color = "darkgrey")

# Limit x-axis from 2010 to 2020
plot <- plot + xlim(2010, 2020)

# Pretty breaks on the x axis
plot <- plot + scale_x_continuous(breaks = pretty_breaks())

# Comma labels on the y axis, with a scale of 1000
plot <- plot + scale_y_continuous(labels = comma, breaks = seq(4750000, 5750000, by = 250000))

# Adding titles to the graph and the x and y axis
plot <- plot + labs(title = "Ontario Population over Time", y = "Total population")

# Part 2

# Update point color 
plot <- ggplot(df_on, aes(x = Year, y = Population, color = pop_change)) +
  geom_point() +
  geom_smooth(method = "loess", color = "darkgrey")

# Using colorbrewer to scale the color points using the PuRd palette
plot <- plot + scale_color_distiller(palette = "PuRd")

# Giving the color scale a name and set breaks of (5, 10, 15)
plot <- plot + scale_color_distiller(
  palette = "PuRd", 
  name = "Pop change", 
  limits = c(5, NA), 
  breaks = c(5, 10, 15)
)

# Apply remaining styling
plot <- plot + 
  xlim(2010, 2020) +
  scale_x_continuous(breaks = pretty_breaks()) +
  scale_y_continuous(labels = comma, breaks = seq(4750000, 5750000, by = 250000)) +
  labs(title = "Ontario Population over Time, Colored by Yearly Change", 
       y = "Total population")

# Print plot
print(plot)








