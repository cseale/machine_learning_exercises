library(ggplot2)

ufo <- read.delim(file.path("data", "ufo", "ufo_awesome.tsv"),
                  sep = "\t",
                  stringsAsFactors = FALSE,
                  header = FALSE, 
                  na.strings = "")

head(ufo)
