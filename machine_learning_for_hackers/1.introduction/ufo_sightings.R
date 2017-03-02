library(ggplot2)

# read data
ufo <- read.delim(file.path("data", "ufo", "ufo_awesome.tsv"),
                  sep = "\t", # tab delimited
                  stringsAsFactors = FALSE, # leave as strings
                  header = FALSE, # first line are headers
                  na.strings = "") # values for na
# print top 6 lines
head(ufo)

# assign column names to dataframe
names(ufo) <- c('DateOccured', 'DateReported', 'Location', 'ShortDescription', 'Duration', 'LongDescription')

# collect rows with right date format
good.rows <- ifelse(nchar(ufo$DateOccured)!=8 | nchar(ufo$DateOccured)!=8, FALSE, TRUE)
length(which(!good.rows))

# keep only those rows
ufo <- ufo[good.rows,]

# parse date strings to date type fields
ufo$DateOccured <- as.Date(ufo$DateOccured, format='%Y%m%d')
ufo$DateReported <- as.Date(ufo$DateReported, format='%Y%m%d')
