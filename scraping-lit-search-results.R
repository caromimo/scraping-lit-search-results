# Scraping results from search on Federal Science Libraries Network
# C. Mimeault and M. Williamson
# October 2021

# link to the Federal Science Libraries Network
# https://science-libraries.canada.ca/eng/home/
# searches are not case sensitive

# clear memory
remove(list=ls())
knitr::opts_chunk$set(echo = TRUE)

# load libraries
library(rvest)
library(tidyverse)
library(glue)
library(urltools)

# Initial search ----------------------------------------------------------

# search terms: (("British Columbia" OR BC ) AND (salmon OR Chinook OR pink OR chum OR coho OR Sockeye) AND (juvenile OR immature))
# # returns 850 results (Oct 31, 2021) which is too many (maximum allowed is 500 records) 
# so breaking it down per species

# ensuring that we can reproduce the results from initial search"

intial_search_terms <- '(("British Columbia" OR BC ) AND (salmon OR Chinook OR pink OR chum OR coho OR Sockeye) AND (juvenile OR immature))'

intial_search_url <- "https://science-libraries.canada.ca/eng/search/" %>% 
  param_set("fc", "Library%3ADFO-MPO") %>% 
  param_set("fs", "IsLibraryCatalogue%3A1") %>% 
  param_set("q", url_encode(intial_search_terms)) %>%
  param_set("sm", 1)

# Chinook salmon search ----------------------------------------------------------

# search terms: 
# ("British Columbia" OR BC ) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile* OR immature* OR smolt*)
# returns 277 results (Oct 31, 2021)

chinook_search_terms <- '("British Columbia" OR BC) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile* OR immature* OR smolt*)'

chinook_search_url <- "https://science-libraries.canada.ca/eng/search/" %>% 
  param_set("fc", "Library%3ADFO-MPO") %>% 
  param_set("fs", "IsLibraryCatalogue%3A1") %>% 
  param_set("q", url_encode(chinook_search_terms)) %>%
  param_set("sm", 1)

# open and maintain a session across multiple requests (being the various pages and calls to save results)
results_page <- session(chinook_search_url)

# move to the next page
while(results_page) {
  tryCatch({results_page <- session_follow_link(css = "a[rel=next]")},
           error = function(e) {results_page = FALSE})
  print("got a page")
  
}
  print("no more pages")
  
# TESTING looping ----------------------------------------------------------
  
test_search_terms <- '("British Columbia" OR BC) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile* OR immature* OR smolt*) AND (neville OR trudel OR riddell)'
test_search_url <- "https://science-libraries.canada.ca/eng/search/" %>% 
  param_set("fc", "Library%3ADFO-MPO") %>% 
  param_set("fs", "IsLibraryCatalogue%3A1") %>% 
  param_set("q", url_encode(test_search_terms)) %>%
  param_set("sm", 1)

# open and maintain a session across multiple requests (being the various pages and calls to save results)
results_page <- session(test_search_url)

get_ids <- function(page){
  page %>%
    html_nodes("a.save-search-result") %>%
    html_attr("id")
}

save_item_by_id <- function(id){
  print(glue("https://science-libraries.canada.ca/eng/search/save-items/?id={id}"))
}

# move to the next page
has.next <- TRUE

while(has.next) {
  ids <- results_page %>% get_ids()
  print("here are the fetched ids for this page:")
  print(ids)
  print("now saving results to session")
  for(id in ids){
    save_item_by_id(id)
    }
  tryCatch(
    {
      results_page <<- results_page %>% session_follow_link(css = "a[rel=next]")
      },
      error = function(e) {
        has.next <<- FALSE
        }
    )
}

print("there are no more pages (and no next button)")
print("download a csv")















# Chum salmon search ----------------------------------------------------------

# search terms: 
# ("British Columbia" OR BC ) AND ("Chum salmon" OR "Oncorhynchus keta") AND (juvenile* OR immature* OR smolt*)
# returns 129 results (Oct 31, 2021)

# Coho salmon search ----------------------------------------------------------

# search terms: 
# ("British Columbia" OR BC ) AND ("Coho salmon" OR "Oncorhynchus kisutch") AND (juvenile* OR immature* OR smolt*)
# returns 406 results (Oct 31, 2021)

# Pink salmon search ----------------------------------------------------------

# search terms: 
# ("British Columbia" OR BC ) AND ("Pink salmon" OR "Oncorhynchus gorbuscha") AND (juvenile* OR immature* OR smolt*)
# returns 99 results (Oct 31, 2021)

# Sockeye salmon search ----------------------------------------------------------

# search terms: 
# ("British Columbia" OR BC ) AND ("Sockeye salmon" OR "Oncorhynchus nerka") AND (juvenile* OR immature* OR smolt*)
# returns 256 results (Oct 31, 2021)




















