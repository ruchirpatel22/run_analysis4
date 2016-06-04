#download file and unzip file from source
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(url,temp)
setwd("/Users/ruchirpatel/.R")
unzip(temp)

# load tables into Rstudio
activities <- read.table("~/.R/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
features <- read.table("~/.R/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
X_test <- read.table("~/.R/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
X_train <- read.table("~/.R/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/.R/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
y_test <- read.table("~/.R/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")

#load descriptive names for activities and features
features <- features[,2]
activities <- activities[,2]

#set column names for the test and train files
colnames(X_test) <- features
colnames(X_train) <- features

# bind y & x files
X_test1 <- cbind(y_test, X_test)
X_train1 <- cbind(y_train, X_train)

#combine test and train files
comb <- rbind(X_test1,X_train1)

#select variables representing the mean/std deviation variables
features1 <- grep("[Mm]ean(\\()|std\\()", features)
features1 <- features1 + 1
features1 <- c(1,features1)
comb1 <- comb[,features1]
colnames(comb1)[1] <- "Activity"

#add descriptive labels for activities
comb1$Activity <- ordered(comb1$Activity, levels = c(1,2,3,4,5,6), labels = activities)

#melt data and obtain variable means for each activity
library(reshape2)
mcomb1 <- melt(comb1, id.vars="Activity")
meancobm1 <- dcast(mcomb1, Activity ~variable, mean)

write.table(meancobm1, "./step5.txt", row.name=FALSE)





