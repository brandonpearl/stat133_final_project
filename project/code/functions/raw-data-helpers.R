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
