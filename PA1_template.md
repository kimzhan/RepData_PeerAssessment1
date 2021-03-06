# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
getwd()
unzip(zipfile = "/Users/xindongli/Documents/RepData_PeerAssessment1/activity.zip")
data <- read.csv("activity.csv")
library(ggplot2)
total<- tapply(data$steps, data$date, FUN = sum, na.rm = TRUE)
qplot(total, binwidth = 1000, xlab = "total steps per day")

[Rplot01.png](https://github.com/kimzhan/RepData_PeerAssessment1/blob/master/Rplot01.png)

##  is mean total number of steps taken per day?

mean(total, na.rm = TRUE)
median(total, na.rm = TRUE)

## What is the average daily activity pattern?

avg <- aggregate(x = list(steps = data$steps), by = list(interval = data$interval), 
                  FUN = mean, na.rm = TRUE)
ggplot(data = avg, aes(x = interval, y = steps)) + geom_line() + xlab("5-minute interval") + 
     ylab("average steps")
avg[which.max(avg$steps), ]

[Rplot02.png](https://github.com/kimzhan/RepData_PeerAssessment1/blob/master/Rplot02.png)

## Imputing missing values

mvalue<- is.na(data$steps)
table(mvalue)
fvalue<- function(steps, interval) {
     filled <- NA
     if (!is.na(steps)) 
         filled <- c(steps) else filled <- (avg[avg$interval == interval, "steps"])
     return(filled)
 }
filled.data <- data
filled.data$steps <- mapply(fvalue, filled.data$steps, filled.data$interval)
total<- tapply(filled.data$steps, filled.data$date, FUN = sum)
qplot(total, binwidth = 1000, xlab = "total steps per day")

mean(total)
median(total)

[Rplot03.png](https://github.com/kimzhan/RepData_PeerAssessment1/blob/master/Rplot03.png)

## Are there differences in activity patterns between weekdays and weekends?
weekday.or.weekend <- function(date) {
     day <- weekdays(date)
     if (day %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")) 
         return("weekday") else if (day %in% c("Saturday", "Sunday")) 
         return("weekend") else stop("invalid date")
 }
filled.data$date <- as.Date(filled.data$date)
filled.data$day <- sapply(filled.data$date, FUN = weekday.or.weekend)
averages <- aggregate(steps ~ interval + day, data = filled.data, mean)
ggplot(averages, aes(interval, steps)) + geom_line() + facet_grid(day ~ .) + 
     xlab("5-minute interval") + ylab("Number of steps")

[Rplot.png](https://github.com/kimzhan/RepData_PeerAssessment1/blob/master/Rplot.png)