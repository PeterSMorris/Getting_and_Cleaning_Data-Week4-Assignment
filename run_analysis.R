# load required libraries
library(dplyr) 

# set working directory to data location
setwd("UCI HAR Dataset")

# read train data sets
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

# read test data sets 
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

# read features description table
features <- read.table("./features.txt") 

# read activity labels table
activity_labels <- read.table("./activity_labels.txt") 

# merge training and test data sets
x_combined   <- rbind(x_train, x_test)
y_combined   <- rbind(y_train, y_test) 
sub_combined <- rbind(sub_train, sub_test)

# keep only measurements for mean and standard deviation 
selected_features <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_combined <- x_combined[,selected_features[,1]]

# name columns
colnames(x_combined)   <- selected_features[,2]
colnames(y_combined)   <- "activity"
colnames(sub_combined) <- "subject"

# merge final dataset
combined <- cbind(sub_combined, y_combined, x_combined)

# turn activities & subjects into factors 
combined$activity <- factor(combined$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
combined$subject  <- as.factor(combined$subject) 

# create a summary independent tidy dataset from final dataset 
# with the average of each variable for each activity and each subject. 
total_mean <- combined %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

# export summary dataset
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
