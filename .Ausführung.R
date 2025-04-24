library(tidyverse)
library(zip)

version = 3.8

dropboxpfad="E:/Dropbox/OrbisAsteaDropbox/"
projektepfad = str_remove(getwd(),"###Orbis")

library(leaflet)
library(leafem)
library(readxl)
library(sp)
library(leaflet.extras)
library(htmltools)
library(tidyverse)
library(reactable)
library(lubridate)
library(timevis)

# Copy and get files ------------------------------------------------------

## First Copy the Rmd files from Dropbox to Disk

file.copy(list.files(paste0(dropboxpfad,"Orbis Texte"), ".Rmd", full.names = T),getwd(),recursive = T, overwrite = TRUE)

file.copy(list.files(paste0(dropboxpfad,"Orbis Texte","/BookdownData"), full.names = T),
          paste(getwd(),"BookdownData", sep="/"), recursive = T, overwrite = TRUE)

source(paste0(projektepfad,"SmallCodes/KeyIndexErstellen.R")) # Then make The KeyIndex File

pfad=str_remove(getwd(),"###Orbis")

## Holen der Downloadsheets
file.copy(paste0(dropboxpfad,"Orbis Daten Tools/",c("CCSheetBlank.xlsx","CCrand.xlsx", "Einstieg in Orbis.pdf")),
          "DownloadContainer",overwrite =T)

## Übernehmen des Containers
from <- paste0(dropboxpfad,"Orbis Daten Tools/Container/Data")
file.copy(list.files(from, full.names = TRUE),
          "Container/Data",
          recursive = TRUE, overwrite =T)


zip(
  "DownloadContainer/OrbisAstea.zip",
  c(paste0(projektepfad,"OrbisCodeBase/OrbisGui/auto-py-to-exe-master/output/Orbis Launcher")),
  recurse = TRUE,
  compression_level = 9,
  include_directories = TRUE,
  root = ".",
  mode = c("cherry-pick")
)

from <- "DownloadContainer"
to   <- "docs/DownloadContainer"
file.copy(list.files(from, full.names = TRUE),
          to,
          recursive = TRUE,overwrite =T)

## Kopieren der Bilder

files <- list.files(path = paste0(dropboxpfad,"Orbis Pictures/Pictures"),
                    pattern = "\\.JPG$", recursive = TRUE, full.names = TRUE)

# Rename each file
for (file in files) {
  new_name <- sub("\\.JPG$", ".jpg", file)
  file.rename(file, new_name)
}

file.copy(paste0(dropboxpfad,"Orbis Pictures/Pictures/Maps/OrbisAstea.jpg"),
          "docs",
          recursive = TRUE,overwrite =T)

file.copy(list.files(paste0(dropboxpfad,"Orbis Pictures/Pictures"),
                     full.names = T),
          "./Pictures",
          recursive = TRUE, overwrite =F)

# Render Bookdown ---------------------------------------------------------

bookdown::render_book(output_dir = "docs")
rm(list = ls())
