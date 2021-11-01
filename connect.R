library(rvest)

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

	list(has_next = has_next, get_next = get_next, get_ids = get_ids)
}