# This file contains helper functions to be used by get-raw-data.R

library(rvest)
library(stringr)
library(dplyr)

# Wrapper for rvest function "read_html"
# @param url, the url of the xml_document to fetch
# @return list of class "xml_document" and "xml_node"
get_xml_document <- function(url) {
  if (url == "" || is.null(url)) {
    stop("Please provide url")
  }
  xml_document <- xml2::read_html(url)
  return(xml_document)
}

# Given the location of an html table and an xml_document, returns a data frame
# defining the table
# @param xml_data, the xml_document to search
# @param location, a character vector defining the xml_node to retrieve
# @return a data.frame containing player data
get_player_table <- function(xml_data, location) {
  if (is.null(xml_data) ||
      class(xml_data)[1] != "xml_document" ||
      class(xml_data)[2] != "xml_node" ||
      location == "" ||
      is.null(location)) {
    stop("Bad inputs. Please make sure xml_data is an xml_document and location
         is a valid non-empty string")
  }
  player_frame <- xml_data %>%
                  rvest::html_node(location) %>%
                  rvest::html_table()
  return(player_frame)
}

# Given the location of a table header and an xml_document, returns a list of
# column names (the header of the future table)
# @param xml_data, the xml_document to search
# @param location, a character vector defining the xml_node to retrieve
# @return a character vector of column names
get_header <- function(xml_data, location) {
  if (is.null(xml_data) ||
      class(xml_data)[1] != "xml_document" ||
      class(xml_data)[2] != "xml_node" ||
      location == "" ||
      is.null(location)) {
    stop("Bad inputs. Please make sure xml_data is an xml_document and location
         is a valid non-empty string")
  }
  raw_header <- xml_data %>% 
                rvest::html_node(location) %>% 
                rvest::html_text()
  to_trim <- stringr::str_split(raw_header, "\n")[[1]]
  header_with_blanks <- stringr::str_trim(to_trim)
  header_no_blanks <- header_with_blanks[header_with_blanks != ""]
  return(header_no_blanks)
}

# Given the location of a table body and an xml_document, returns a data.frame
# with rows defining individual players
# @param xml_data, the xml_document to search
# @param location, a character vector defining the xml_node to retrieve
# @return a dataframe with all player data
get_player_dataframe <- function(xml_data, location) {
  if (is.null(xml_data) ||
      class(xml_data)[1] != "xml_document" ||
      class(xml_data)[2] != "xml_node" ||
      location == "" ||
      is.null(location)) {
    stop("Bad inputs. Please make sure xml_data is an xml_document and location
         is a valid non-empty string")
  }
  xml_rows <- xml_data %>%
              rvest::html_node(location) %>%
              rvest::html_children()
  player_list = list()
  for (i in 1:length(xml_rows)) {
    player_data = xml_rows[i] %>%
                  rvest::html_children() %>%
                  rvest::html_text()
    player_list = append(player_list, list(player_data))
  }
  player_frame = data.frame()
  for (i in 1:length(xml_rows)) {
    player_frame = rbind(player_frame,
                         player_list[[i]],
                         stringsAsFactors = FALSE)
  }
  return(player_frame)
}
