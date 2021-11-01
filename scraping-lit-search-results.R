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

# ensuring that we can reproduce the results from initial search: done

intial_search_terms <-
  '(("British Columbia" OR BC ) AND (salmon OR Chinook OR pink OR chum OR coho OR Sockeye) AND (juvenile OR immature))'

intial_search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(intial_search_terms)) %>%
  param_set("sm", 1)

# Testing 10 at a time search ----------------------------------------------------------
# 23 search results

search_terms <-
  '("British Columbia" OR BC) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile* OR immature* OR smolt*) AND (neville OR trudel OR riddell)'

search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(search_terms)) %>%
  param_set("sm", 1)

source("connect.R")

count <- 1
repeat {
  c(has_next, get_next, get_ids, save_item, saved_items, download_csv) %<-% connect(search_url)
  for (id in get_ids()) {
    save_item(id)
    Sys.sleep(1)
  }
  download_csv(glue("test-page-{count}.csv"))
  count <- count + 1
  if (has_next()) {
    get_next()
  } else {
    break
  }
}


# Testing search ----------------------------------------------------------

search_terms <-
  '("British Columbia" OR BC) AND ("Chinook salmon" OR "Oncorhynchus tshawytscha") AND (juvenile* OR immature* OR smolt*) AND (neville OR trudel OR riddell)'

search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(search_terms)) %>%
  param_set("sm", 1)

source("connect.R")

c(has_next, get_next, get_ids, save_item, saved_items, download_csv) %<-% connect(search_url)

repeat {
  for (id in get_ids()) {
    save_item(id)
    Sys.sleep(1)
  }
  if (has_next()) {
    get_next()
  } else {
    break
  }
}

download_csv("test.csv")

# Chinook salmon search ----------------------------------------------------------
# search terms returned 326 results (Oct 31, 2021)

search_terms <-
  '("British Columbia" OR BC) AND (juvenile* OR immature* OR smolt*) AND ("Chinook salmon" OR "Chinook" OR "Oncorhynchus tshawytscha" OR "O. tshawytscha")'





# Chum salmon search ----------------------------------------------------------
# search terms returned 178 results (Oct 31, 2021)

search_terms <-
  '("British Columbia" OR BC) AND (juvenile* OR immature* OR smolt*) AND ("Chum salmon" OR "Chum" OR "Oncorhynchus keta" OR "O. keta")'
  
search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(search_terms)) %>%
  param_set("sm", 1)

source("connect.R")

c(has_next, get_next, get_ids, save_item, saved_items, download_csv) %<-% connect(search_url)

repeat {
  for (id in get_ids()) {
    save_item(id)
    Sys.sleep(1)
  }
  if (has_next()) {
    get_next()
  } else {
    break
  }
}

download_csv("chum.csv")

# Coho salmon search ----------------------------------------------------------
# search terms returned 491 results (Oct 31, 2021)

search_terms <-
  '("British Columbia" OR BC) AND (juvenile* OR immature* OR smolt*) AND ("Coho salmon" OR "Coho" OR "Oncorhynchus kisutch" OR "O. kisutch")'


# Pink salmon searches ----------------------------------------------------------
# search terms returned 139 results (Oct 31, 2021)

search_terms <-
  '("British Columbia" OR BC) AND (juvenile* OR immature* OR smolt*) AND ("Pink salmon" OR "Pink" OR "Oncorhynchus gorbuscha" OR "O. gorbuscha")'
  
search_url <-
  "https://science-libraries.canada.ca/eng/search/" %>%
  param_set("fc", "Library%3ADFO-MPO") %>%
  param_set("fs", "IsLibraryCatalogue%3A1") %>%
  param_set("q", url_encode(search_terms)) %>%
  param_set("sm", 1)

source("connect.R")

c(has_next, get_next, get_ids, save_item, saved_items, download_csv) %<-% connect(search_url)

repeat {
  for (id in get_ids()) {
    save_item(id)
    Sys.sleep(1)
  }
  if (has_next()) {
    get_next()
  } else {
    break
  }
}

download_csv("pink.csv")

# Sockeye salmon search ----------------------------------------------------------
# search terms returned 303 results (Oct 31, 2021)

search_terms <-
  '("British Columbia" OR BC) AND (juvenile* OR immature* OR smolt*) AND ("Sockeye salmon" OR "Sockeye" OR "Oncorhynchus nerka" OR "O. nerka")'




# All search results ----------------------------------------------------------

# collate searches for all five species
all_results <-
  bind_rows(chinook,
            chum,
            coho,
            pink,
            sockeye)

# remove duplicates
all_results_no_duplicates <- unique(all_results)

# save csv
write_csv(all_results_no_dups, "all_results_no_duplicates.csv")