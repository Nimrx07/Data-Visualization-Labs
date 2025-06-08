# Part 1

# 1. Loads libraries
library(readxl)
library(tidyverse)
library(dplyr)


# 2. Reads excel file and skip 5 lines of input

data <- read_xlsx("C:/Users/nimra/Downloads/bc_trade.xlsx", skip = 5)

# 3. Rename column 1 to ‘month’ and column 3 to ‘energy
colnames(data)[1] <- "month"
colnames(data)[3] <- "energy"



# Part 2

#1: Set colour codes of  months matching June, July, and August to “firebrick”, and all other months to “#cccccc”
data$colour <- ifelse(substr(data$month, 1, 3) %in% C("Jun", "Jul", "Aug"), "firebrick", "#cccccc")


#2: Create the bar plot
barplot(height = data$energy,      # Use energy values as bar heights
        names.arg = data$month,    #  Assigns the month names to each bar on the x-axis
        col = data$colour,          # Colors assigned based on the color vector
        space = 0,                 # Spacing is set to 0
        xlab = "Month",            # x-axis label
        ylab = "Exports ($ thousands)",  # y-axis label
        main = "British Columbia Energy Exports")  # Title
