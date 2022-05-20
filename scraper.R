# mini-webscraper
# gets menu and prices from website and save results to csv file

# packages:
# install.packages("tidyverse")
# install.packages("rvest") = see: https://rvest.tidyverse.org/articles/rvest.html
# install.packages("lubridate")

# load library
library(rvest)
library(lubridate)
library(tidyverse)

url <- "https://www.lepokestation.com/en"
html <- read_html(url)
poke <- data.frame(
  # get menu items
  menu = html %>% html_elements(".card-title") %>% html_text2(),
  # get pricelist
  pricelist = html %>% html_elements(".m-0") %>% html_text2()
)

# sort output
poke <- poke %>%
  # transform to long format
  pivot_wider(names_from=menu, values_from=pricelist) %>%
  # add date
  mutate(Date = today())

# convert date to write to csv
poke$Date <- format(poke$Date, "%m/%d/%Y")
poke <- data.frame(poke)

# open csv file and add new row to dataframe
all <- read.csv("pokebowl.csv")
all <- rbind(all, poke[1,])

# write to file
write.csv(all, file = "pokebowl.csv", row.names = FALSE)

