# Scraping results from search on Federal Science Libraries Network
# C. Mimeault and M. Williamson
# October 2021

# link to the Federal Science Libraries Network
# https://science-libraries.canada.ca/eng/home/
# searches are not case sensitive

# clear memory
remove(list = ls())
knitr::opts_chunk$set(echo = TRUE)

# load libraries
library(rvest)
library(tidyverse)
library(glue)
library(urltools)
library(zeallot)

# Initial search ----------------------------------------------------------

# search terms: (("British Columbia" OR BC ) AND (salmon OR Chinook OR pink OR chum OR coho OR Sockeye) AND (juvenile OR immature))
# # returns 850 results (Oct 31, 2021) which is too many (maximum allowed is 500 records)
# so breaking it down per species

# ensuring that we can reproduce the results from initial search"

intial_search_terms <-
  '(("British Columbia" OR BC ) AND (salmon OR Chinook OR pink OR chum OR coho OR Sockeye) AND (juvenile OR immature))'

intial_search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(intial_search_terms)) %>%
  param_set("sm", 1)

# Chinook salmon search ----------------------------------------------------------

# search terms:
# returns 326 results (Oct 31, 2021)

chinook_search_terms <-
  '("British Columbia" OR BC) AND ("Chinook salmon" OR "Chinook" OR "Oncorhynchus tshawytscha" OR "O. tshawytscha") AND (juvenile* OR immature* OR smolt*)'

chinook_search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(chinook_search_terms)) %>%
  param_set("sm", 1)

# open and maintain a session across multiple requests (being the various pages and calls to save results)
results_page <- session(chinook_search_url)

# move to the next page
while (results_page) {
  tryCatch({
    results_page <- session_follow_link(css = "a[rel=next]")
  },
  error = function(e) {
    results_page = FALSE
  })
  print("got a page")
  
}
print("no more pages")

# TESTING looping ----------------------------------------------------------

source("connect.R")

test_search_terms <-
  '("British Columbia" OR BC) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile* OR immature* OR smolt*) AND (neville OR trudel OR riddell)'
test_search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(test_search_terms)) %>%
  param_set("sm", 1)

c(has_next, get_next, get_ids) %<-% connect(test_search_url)

save_item_by_id <- function(id) {
  print(glue(
    "https://science-libraries.canada.ca/eng/search/save-items/?id={id}"
  ))
}

repeat {
  for (id in get_ids()) {
    save_item_by_id(id)
    test_search_url
  }
  if (has_next()) {
    get_next()
  } else {
    break
  }
}







print("there are no more pages (and no next button)")
print("download a csv")















# Chum salmon search ----------------------------------------------------------

# search terms:
# returns 178 results (Oct 31, 2021)

chum_search_terms <-
  '("British Columbia" OR BC) AND ("Chum salmon" OR "Chum" OR "Oncorhynchus keta" OR "O. keta") AND (juvenile* OR immature* OR smolt*)'


# Coho salmon search ----------------------------------------------------------

# search terms:
# returns 491 results (Oct 31, 2021)

coho_search_terms <-
  '("British Columbia" OR BC) AND ("Coho salmon" OR "Coho" OR "Oncorhynchus kisutch" OR "O. kisutch") AND (juvenile* OR immature* OR smolt*)'


# Pink salmon search ----------------------------------------------------------

# search terms:
# returns 139 results (Oct 31, 2021)

pink_search_terms <-
  '("British Columbia" OR BC) AND ("Pink salmon" OR "Pink" OR "Oncorhynchus gorbuscha" OR "O. gorbuscha") AND (juvenile* OR immature* OR smolt*)'


# Sockeye salmon search ----------------------------------------------------------

# search terms:
# returns 303 results (Oct 31, 2021)

sockeye_search_terms <-
  '("British Columbia" OR BC) AND ("Sockeye salmon" OR "Sockeye" OR "Oncorhynchus nerka" OR "O. nerka") AND (juvenile* OR immature* OR smolt*)'




# Collate all search results ----------------------------------------------------------

all_results <-
  bind_rows(chinook_results,
            chum_results,
            coho_results,
            pink_results,
            sockeye_results)
all_results_no_dups <- unique(all_results)
