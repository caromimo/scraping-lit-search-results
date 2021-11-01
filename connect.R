library(rvest)
library(glue)

connect <- function(url){
  current_page <- session(url)
  
  has_next <- function(){
    ifelse(length(current_page %>% html_node("a[rel=next]")), TRUE, FALSE)
  }
  
  get_next <- function(){
    if(has_next()){
      current_page <<- current_page %>% session_follow_link(css = "a[rel=next]")
    }
    current_page
  }
  
  get_ids <- function(){
    current_page %>%
      html_nodes("a.save-search-result") %>%
      html_attr("id")
  }
  
  save_item <- function(id){
    current_page %>% session_jump_to(glue("save-items/?id={id}"))
  }
  
  saved_items <- function(){
    saved_items_page <- current_page %>% session_follow_link("View saved items")
    saved_items_page %>% html_nodes("h2.h3") %>% html_text2()
  }
  
  download_csv <- function(filename = "results.csv"){
    saved <- current_page %>% session_follow_link("View saved items")
    csv <- saved %>% session_follow_link("Export to CSV")
    writeBin(csv$response$content, filename)
  }
  
  list(has_next = has_next, get_next = get_next, get_ids = get_ids, save_item = save_item, saved_items = saved_items, download_csv = download_csv)
}