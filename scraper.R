# webscraper
# gets content from website and saves results to csv file in data folder

library(rvest)
library(dplyr)
library(tidyr)

url <- "https://www.lepokestation.com/en"
html <- read_html(url)
mydata <- data.frame(
  # get menu items
  menu = html %>% html_elements(".card-title") %>% html_text2(),
  # get pricelist
  pricelist = html %>% html_elements(".m-0") %>% html_text2()
)

# convert prices to numeric
mydata$pricelist <- sub("\\$", "", mydata$pricelist)
mydata$pricelist <- as.numeric(mydata$pricelist)

# sort output
mydata <- mydata %>%
  # transform to long format
  pivot_wider(names_from=menu, values_from=pricelist) %>%
  # add date
  mutate(Date = Sys.Date())

# write to csv
write.table(mydata, "data/data.csv", append = T, row.names = F, col.names = F, sep = ",")

