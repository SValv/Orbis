library(tidyverse)
library(zip)

version = 3.7

dropboxpfad="E:/Dropbox/OrbisAsteaDropbox/"
projektepfad = str_remove(getwd(),"###Orbis")


# Copy and get files ------------------------------------------------------

## First Copy the Rmd files from Dropbox to Disk

file.copy(list.files(paste0(dropboxpfad,"Orbis Texte"), ".Rmd", full.names = T),getwd(),recursive = T)

file.copy(list.files(paste0(dropboxpfad,"Orbis Texte","/BookdownData"), full.names = T),
          paste(getwd(),"BookdownData", sep="/"), recursive = T)

source(paste0(projektepfad,"SmallCodes/KeyIndexErstellen.R")) # Then make The KeyIndex File

pfad=str_remove(getwd(),"###Orbis")

## Holen der Downloadsheets
file.copy(paste0(dropboxpfad,"Orbis Daten Tools/",c("CCSheetBlank.xlsx","CCrand.xlsx", "Einstieg in Orbis.pdf")),
          "DownloadContainer",overwrite =T)

## Übernehmen des Containers
from <- paste0(dropboxpfad,"Orbis Daten Tools/Container/Data")
file.copy(list.files(from, full.names = TRUE),
          "Container/Data",
          recursive = TRUE,overwrite =T)

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

file.copy(paste0(dropboxpfad,"Orbis Pictures/Pictures/Maps/OrbisAstea.jpg"),
          "docs",
          recursive = TRUE,overwrite =T)

file.copy(list.files(paste0(dropboxpfad,"Orbis Pictures/Pictures"),
                     full.names = T),
          "./Pictures",
          recursive = TRUE)

# Render Bookdown ---------------------------------------------------------

bookdown::render_book(output_dir = "docs")
rm(list = ls())
