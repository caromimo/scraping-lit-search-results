# Mike explaining closure

counter <- function(number){
  count = number
  observe <- function(){
    count
  }
  increment <- function(){
    count <<- count + 1
  }
  decrement <- function(){
    count <<- count - 1
  }
  list(observe = observe, increment = increment, decrement = decrement)
}