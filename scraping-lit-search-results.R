# Scraping results from search on Federal Science Libraries Network
# C. Mimeault and M. Williamson
# October 2021

# clear memory
remove(list=ls())
knitr::opts_chunk$set(echo = TRUE)

# load libraries
library(rvest)
library(tidyverse)
library(glue)

# identify webpage (with search results)
# (("British Columbia" OR BC ) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile) AND (riddell OR beamish) 
# 12 results (2021-10-30)
url <- "https://science-libraries.canada.ca/eng/search/?q=%28%28%22British+Columbia%22+OR+BC+%29+AND+%28%22Chinook+salmon%22+OR+%22Oncorhynchus+tshawytscha%22%29+AND+%28juvenile%29+AND+%28beamish+OR+trudel+OR+ridell%29&sm=1&fc=Library%3ADFO-MPO&fs=IsLibraryCatalogue%3A1"

# open a session in the browser
session(url)

# read html
html <- read_html(url)

# identify number of pages (maximum of 50 allowed on website)
# number_of_pages <- c(1:50)

# extract titles to explore (just for interest)
titles <- html %>% 
  html_nodes("ol.search-results h3") %>%
  html_text()

# extract search result id numbers
id_numbers <- html %>%
  html_nodes("a.save-search-result") %>%
  html_attr("id")

for(id in id_numbers){
  print(glue("https://science-libraries.canada.ca/eng/search/save-items/?id={id}"))
}

# move to the next page
session(url) %>%
  session_follow_link(css = "a[rel=next]")





