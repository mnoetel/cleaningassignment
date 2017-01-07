rm(list=ls())
library(dplyr)
library(stringr)
# create directory for the raw data if it doesn't already exist
if(!dir.exists("./data")) dir.create("./data")

# download the file if it hasn't been downloaded already
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.to <- "./data/data.zip"
if(!file.exists(download.to)) download.file(file.url,download.to)

# unzip it if we haven't already
if(!dir.exists("./UCI HAR Dataset")) unzip(download.to)

# 1. Merges the training and the test sets to create one data set.
# 1.1 Read in train and test with label and subject files
train <- read.delim("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
train.labels <- read.delim("./UCI HAR Dataset/train/Y_train.txt", sep = "", header = FALSE)
train.subject <- read.delim("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
test <- read.delim("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
activitys <- read.delim("./UCI HAR Dataset/test/Y_test.txt", sep = "", header = FALSE)
subject <- read.delim("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

# 1.2 Add features as names of dataframes, train and test
features <- read.delim("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
names(train) <- features[, 2]
names(test) <- features[, 2]
rm(features)

# 1.3 Attach Labels and Subject to train and test, then remove label and subject lists
train <- cbind(train,train.labels)
train <- cbind(train,train.subject)
names(train)[length(train)-1] <- "activity"
names(train)[length(train)] <- "subject"
rm(train.labels)
rm(train.subject)

test <- cbind(test,activitys)
test <- cbind(test,subject)
names(test)[length(test)-1] <- "activity"
names(test)[length(test)] <- "subject"
rm(activitys)
rm(subject)

# 1.4 Add identifier variable to each table then join
train <- cbind(train,rep("train"))
names(train)[length(train)] <- "origin"
test <- cbind(test,rep("test"))
names(test)[length(test)] <- "origin"
joined <- rbind(train,test)
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 2.1 Make column names vaild
valid_column_names <- make.names(names=names(joined), unique=TRUE, allow_ = TRUE)
names(joined) <- valid_column_names
# 2.2 Extract the means and standard deviations for each measurement
means.and.standard.deviations <- select(joined, subject, activity, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
# 3.1 Read in label names
label.names <- read.delim("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
label.names[, 2] <- str_to_title(label.names[, 2])
# 3.2 Convert current values to characters
means.and.standard.deviations$activity <- as.character(means.and.standard.deviations$activity)
# 3.3 Create factor that uses values and lables from value names, so activity names are descriptive
means.and.standard.deviations$activity <- factor(means.and.standard.deviations$activity, levels = label.names[, 1], labels = label.names[, 2])
# 3.4 Demonstrate effectiveness
head(means.and.standard.deviations$activity)
# 4. Appropriately labels the data set with descriptive variable names.
textnames <- names(means.and.standard.deviations)
textnames <- gsub("^t", "time", textnames)
textnames <- gsub("\\.t", ".time", textnames)
textnames <- gsub("^f", "fast.fourier.transform", textnames)
textnames <- gsub("Mag", ".magnitude", textnames)
textnames <- gsub("BodyAcc", ".body.acceleration", textnames)
textnames <- gsub("GravityAcc", ".gravity.acceleration", textnames)
textnames <- gsub("BodyGyr(o)?", ".bodily.rotation", textnames)
textnames <- gsub("Body", ".body", textnames)
textnames <- gsub(".std", ".standard.deviation", textnames)
textnames <- gsub("Mean", ".mean", textnames)
textnames <- gsub("fre", ".frequency", textnames)
textnames <- gsub("Jerk", ".jerk", textnames)
textnames <- gsub("Freq", ".frequency", textnames)
textnames <- gsub("\\.\\.", ".", textnames)
textnames <- gsub("\\.\\.", ".", textnames)
textnames <- gsub("(\\.)$", "", textnames)
names(means.and.standard.deviations) <- textnames
str(means.and.standard.deviations)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.)
tidyset <- group_by(means.and.standard.deviations, subject, activity) %>% summarise_each(funs(mean))
write.table(tidyset, "tidyMeansAndSDs.txt")