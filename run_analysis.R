#setp1 : download and unzip data
if (!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/projectdata.zip")
unzip(zipfile = "./data/projectdata.zip", exdir = "./data")

#step2: merging train and test data set

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]
colnames(y_train) <- "activity_id"
colnames(y_test) <- "activity_id"
colnames(subject_train) <- "subject_id"
colnames(subject_test) <- "subject_id"
colnames(activity_labels) <- c("activity_id", "activity_type")

train_data <- cbind(y_train, subject_train, x_train)
test_data <- cbind(y_test, subject_test, x_test)
all_data <- rbind(train_data, test_data)

#step3 : select mean and std related data
all_columns <- colnames(all_data)


mean_std_columns <- (grepl("activity_id" , all_columns) | 
                 grepl("subject_id" , all_columns) | 
                 grepl("mean" , all_columns) | 
                 grepl("std.." , all_columns) 
                 )

mean_std_data <- all_data[ , mean_std_columns==TRUE]

#step4 : use descriptive name to name the activities
data_with_activity_names <- merge(mean_std_data, activity_labels, by = "activity_id",
all.x= TRUE)

#in the following line I just reorder columns to have column order as activity_idm activity_type, subject_id, and then the rest of the columns. This just makes data 
#more understandable
data_with_activity_names <- data_with_activity_names[,c(1,82,2:81)]

#step5: create second tidy data set and write it out
second_tidy_data <- aggregate(. ~subject_id + activity_id, data_with_activity_names, mean)

write.table(second_tidy_data, "second_tidy_set.txt")

