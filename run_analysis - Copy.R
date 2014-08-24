#load libraries
require("data.table", lib.loc="~/R/win-library/3.1")

#set appropriate working directory
setwd("C:/rprojects/getcleandata/UCI HAR Dataset")

#load common data sets
##features
features <- read.table("./features.txt")
colnames(features) <- c("value","featurename")
features$featurename <- gsub("\\(\\)","",features$featurename)
##activities
activitylabel <- read.table("./activity_labels.txt")
colnames(activitylabel) <- c("value","activityname")

#read files for test and train
##test
test <- read.table("./test/x_test.txt")
test.labels <- read.table("./test/y_test.txt")
test.subjects <- read.table("./test/subject_test.txt")
##train
train <- read.table("./train/x_train.txt")
train.labels <- read.table("./train/y_train.txt")
train.subjects <- read.table("./train/subject_train.txt")


#cleaning up column names
colnames(test) <- features$featurename
colnames(test.subjects) <- "subject"
colnames(test.labels) <- "activity"
colnames(train) <- features$featurename
colnames(train.subjects) <- "subject"
colnames(train.labels) <- "activity"

#combining
df.test <- cbind(subject=test.subjects,test)
df.test <- cbind(dataset="test",df.test)
df.test <- cbind(df.test,activity=test.labels)
df.test <- merge(df.test,activitylabel,by.x="activity",by.y="value",all=TRUE)
df.train <- cbind(subject=train.subjects,train)
df.train <- cbind(dataset="train",df.train)
df.train <- cbind(df.train,activity=train.labels)
df.train <- merge(df.train,activitylabel,by.x="activity",by.y="value",all=TRUE)

#subsets
##subset function that Extracts only the measurements on the mean and standard deviation for each measurement. 
meanstd <- function(df) {
  getmean <- grep("[Mm]ean",names(df))
  getstd <- grep("std",names(df))
  df.meanstd <- cbind(subject=df[,names(df)=="subject"],
                      activityname=df[,names(df)=="activityname"],
                      df[,getmean],df[,getstd])
}

##subset test and train
test.formed <- meanstd(df.test)
train.formed <- meanstd(df.train)

#merge test and train, create data.table and order it nicely
df.traintest <- rbind.fill(test.formed,train.formed)
DT <- data.table(df.traintest)
DT <- DT[order(subject,activityname)]

#tidy data set with the average of each variable for each activity and subject
DT.mean <- DT[,lapply(.SD,mean),by=list(subject,activityname)]

