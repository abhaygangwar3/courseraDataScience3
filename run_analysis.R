#Import package

library(dplyr)

#Read all the relevant data from data sets provided in zipped file.

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

#Combining all the data sets to create a merged one

x_tot <- rbind(x_train, x_test)
y_tot <- rbind(y_train, y_test)
sub_tot <- rbind(sub_train, sub_test)

##This is to get the data with mean and standard deviaton only.

var_features <- grep("mean\\(\\)|std\\(\\)",x = features$V2)
feature_names <- features$V2[var_features]
x_tot_req <- x_tot[,var_features]
int <- cbind(y_tot, sub_tot, x_tot_req)
colnames(int) <- c("Activity", "Subject", feature_names)
final_1 <- tbl_df(int)

#This is to label the factors as per the activity performed.

final_1$Activity <- factor(final_1$Activity, labels = activity_labels[,2])

#This is to create final data set with tidy data containing means of all the values grouped by activity and subject

final_mean <- final_1 %>% group_by(Activity, Subject) %>% summarise_each(funs(mean))
write.csv(final_mean, file = "coursera_dataScience_3_assignment.csv")