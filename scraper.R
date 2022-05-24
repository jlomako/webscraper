# webscraper
# gets content from website and saves results to csv file in data folder

# packages:
# install.packages("tidyverse")
# install.packages("rvest")
# install.packages("lubridate")

# load library
library(rvest)
library(lubridate)
library(tidyverse)

url <- "https://www.lepokestation.com/en"
html <- read_html(url)
mydata <- data.frame(
  # get menu items
  menu = html %>% html_elements(".card-title") %>% html_text2(),
  # get pricelist
  pricelist = html %>% html_elements(".m-0") %>% html_text2()
)

# sort output
mydata <- mydata %>%
  # transform to long format
  pivot_wider(names_from=menu, values_from=pricelist) %>%
  # add date
  mutate(Date = today())

# convert date to write to csv
mydata$Date <- format(mydata$Date, "%m/%d/%Y")
mydata <- data.frame(mydata)

# open csv file and add new row to dataframe
all <- read.csv("data/data.csv")
all <- rbind(all, mydata[1,])
all

# write to file
write.csv(all, file = "data/data.csv", row.names = FALSE)
