library(ggplot2)
library(plyr)
#######################################################
#
# Chapter 1 - Introduction to R
# Part One - Reading and cleaning data for use
#
#######################################################

# read data
ufo <- read.delim(file.path("data", "ufo", "ufo_awesome.tsv"),
                  sep = "\t", # tab delimited
                  stringsAsFactors = FALSE, # leave as strings
                  header = FALSE, # first line are headers
                  na.strings = "") # values for na
# print top 6 lines
head(ufo)

# assign column names to dataframe
names(ufo) <- c('DateOccured'
                , 'DateReported'
                , 'Location'
                , 'ShortDescription'
                , 'Duration'
                , 'LongDescription')

# collect rows with right date format
good.rows <- ifelse(nchar(ufo$DateOccured)!=8 | nchar(ufo$DateOccured)!=8, FALSE, TRUE)
length(which(!good.rows))

# keep only those rows
ufo <- ufo[good.rows,]

# parse date strings to date type fields
ufo$DateOccured <- as.Date(ufo$DateOccured, format='%Y%m%d')
ufo$DateReported <- as.Date(ufo$DateReported, format='%Y%m%d')


get.location <- function(l) {
  # catch error if comma is not matched, and return a vector of NA
  split.location <- tryCatch(
    # [[i]] will return the i-th element of a list
    # [i] will return a list containing the i-th element of a list
    strsplit(l, ",")[[1]], 
    error=function(e) return(c(NA, NA))
    )
  
  clean.location <-gsub("^ ", "", split.location)
  
  # isolate US entires
  if(length(clean.location) > 2) { 
    return (c(NA, NA))
  }
  else {
    return (clean.location)
  }
}

# apply get.location function to all "Location"s in the Dataframe
city.state <- lapply(ufo$Location, get.location)
head(city.state)

# lapply is like map, calling a function on every element in a list
# do call takes a calls a function on a list as a whole
location.matrix <- do.call(rbind, city.state)
ufo <- transform(ufo, 
                 USCity=location.matrix[,1], 
                 USState=tolower(location.matrix[,2]),
                 stringsAsFactors=FALSE)

# list of american state abbreviations
us.states <- c("ak", "al", "ar", "az", "ca", "co", "ct", "de", "fl"
               , "ga", "hi", "ia", "id", "il", "in", "ks", "ky", "la"
               , "ma", "md", "me", "mi", "mn", "mo", "ms", "mt", "nc"
               , "nd", "ne", "nh", "nj", "nm", "nv", "ny", "oh", "or"
               , "pa", "ri", "sc", "sd", "tn", "tx", "ut", "va", "vt"
               , "wa", "wi", "wv", "wy")
# transform non US states to NA
ufo$USState <- us.states[match(ufo$USState, us.states)]
# for each no US state, change the city to NA
ufo$USCity[is.na(ufo$USState)] <- NA

ufo.us <- subset(ufo, !is.na(USState))
head(ufo.us)


#######################################################
#
# Part Two - Aggregating and Organizing data
#
#######################################################

# print summary information for a give column of a DataFrame
summary(ufo$DateOccured)

# plot a history to visualize the occurances over time
# in buckets of 50 years
quick.hist <- ggplot(ufo.us, aes(x=DateOccured)) + 
  geom_histogram() + 
  scale_x_date(date_breaks="50 years", date_labels = "%Y")
ggsave(plot=quick.hist, filename="./images/quick_hist.png", height=6, width=8)

# get data after 1990 to today
ufo.us <- subset(ufo.us, DateOccured >= as.Date('1990-01-01'))
nrow(ufo.us)

# get Month and Year of Occurance
ufo.us$YearMonth <- strftime(ufo.us$DateOccured, format = "%Y-%m")
head(ufo.us$YearMonth)

# get count of data per state and month
sightings.counts <- ddply(ufo.us, .(USState, YearMonth), nrow)
head(sightings.counts)

# need to fill in the YearMonth gaps with 0 values
date.range <- seq.Date(from = min(ufo.us$DateOccured), 
                       to = max(ufo.us$DateOccured),
                       by = "month")
date.strings <- strftime(date.range, format = "%Y-%m")

# create a dataframe with every possible combination or year-month and US state
states.dates <- lapply(us.states, function(s) cbind(s, date.strings))
states.dates <- data.frame(do.call(rbind, states.dates), stringsAsFactors = FALSE)
head(states.dates)

# merge the datasets and fill the gaps with NA
# replace all NA as zeros
# create a list of dates for every state
# change states to upper date
all.sightings <- merge(states.dates, 
                       sightings.counts, 
                       by.x=c("s", "date.strings"),
                       by.y=c("USState", "YearMonth"),
                       all=TRUE)
names(all.sightings) <- c("State", "YearMonth", "Sightings")
all.sightings$Sightings[is.na(all.sightings$Sightings)] <- 0
all.sightings$YearMonth <- as.Date(rep(date.range, length(us.states)))
all.sightings$State <- as.factor(toupper(all.sightings$State))
head(all.sightings)

#######################################################
#
# Part Three - Analyzing the data
#
#######################################################