#set working direction
library(dplyr)
getwd()
setwd("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset")


#1  "Merges the training and the test sets to create one data set."
#read the "features" file
features <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/features.txt")

#read the "activity_label" file
activity_labels <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/activity_labels.txt")

#read "test" files
X_test <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/test/subject_test.txt")

#read "train" files
X_train <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("/Users/mengjiao/Desktop/coursera/course3/project/UCI HAR Dataset/train/subject_train.txt")

#merge the test and the train data
merge_dataset <- rbind(X_test, X_train)
merge_labels <- rbind(Y_test, Y_train)
merge_subject <- rbind(subject_test, subject_train)

#check the head of table"merge_dataset","merge_labels", and"merge_subject"
#give appropriate column names to each character in the merged dataset
head(features)
ncol(features)
colnames(merge_dataset) = features[,2]

head(merge_labels)
colnames(merge_labels) = c("activity#")

head(merge_subject)
colnames(merge_subject) = c("subject")

#merge into a complete dataset
data_merge <- cbind(merge_subject, merge_labels, merge_dataset)



#2 "Extracts only the measurements on the mean and standard deviation for each measurement."
# collect all column names
cNames <- colnames(data_merge)
# collect columns with name characters "subject", "activity#", mean", and "std"
# appropriately labels the data set with descriptive variable names (only for features and subject)(step#4)
subject_activity_mean_std <- (grepl("mean..", cNames)|grepl("std..", cNames)|grepl("subject",cNames)|grepl("activity#",cNames))
data_merge2 <- data_merge[, subject_activity_mean_std == TRUE]



#3 "Uses descriptive activity names to name the activities in the data set" (for activity)
colnames(activity_labels) <-c("activity#", "activity")
data_merge3 <- merge(data_merge2, activity_labels, by = "activity#", all.x = TRUE)



#5 "From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.“
tidy_data <- aggregate(data_merge3, by = list(activity = data_merge3$activity, subject = data_merge3$subject), mean)
#create a new dataset
write.table(tidy_data, file = "tidy_dataset.txt", sep = " ", row.names = FALSE)

