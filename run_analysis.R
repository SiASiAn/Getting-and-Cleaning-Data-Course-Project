#downloading data and getting an overview of what we have
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Data.zip", method = "curl")
unzip("./data/Data.zip", exdir = "./data")
file_list <- list.files("./data/UCI HAR Dataset", recursive = TRUE)
print(file_list)

#I will now read in the datasets we need to have a look at them before merging
#test data
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
str(subject_test)
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
str(test_x)
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
str(test_y)

#training data
subject_training <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
str(subject_training)
training_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
str(training_x)
training_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
str(training_y)

#Looking at the data, we can see that for each dataset in test, there are 2947 rows. Subject has 1 column (the ID of the subject),
# test_y has 1 column (the activity, coded as a number), and test_x has 561 columns (the actual feature data).
#The data for train behaves similarly, just with 7352 rows per dataset.


#Since this data doesn't contain any headers that describe the variables, we need to read in additional files. These will be added 
#to the cleaned data later to make the table more readable
#feature info
features <- read.table("./data/UCI HAR Dataset/features.txt")
str(features)
#we can see that this contains one column with the number code (that also appears in the test_x and training_x as column numbers),
#as well as one column that describes what each feature is

#activity info
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
str(activities)
#again, this file has two columns, one with the number code for each activity (1-6), this also appears in test_y and training_y
#the other column is the description of what each number means

#now that we know how the data looks like we can start merging it together
#for this, we first have to add the test/training_y and subject_test/training as additional columns to the respective test/training_x
#afterwards, we can add the new, complete test dataset as additional row to the complete training dataset

test_complete <- cbind(subject_test, test_y, test_x)
str(test_complete)
training_complete <- cbind(subect_training, training_y, training_x)
str(training_complete)
merged_data <- rbind(training_complete, test_complete)
str(merged_data)


#Now that we have one merged dataset, we need to extract measurements on the mean and standard deviation of each measurement
#To know, which columns deal with mean and standard deviation, we need to look at the features file.
#first, we are going to add the second column of features as a header to our complete dataset
feature_names <- features[,2]
names_columns <- c("Subject ID", "Activity ID", feature_names)
colnames(merged_data) <- names_columns
#now we can subset the columns with mean or std + the subject ID and activity ID column
columns_needed <- merged_data[grepl('mean\\(\\)|std\\(\\)|Subject|Activity', colnames(merged_data))]
str(columns_needed)


#next, we should add descriptive activity names. These are stored in the activities dataset
#to start of, I will rename the columns of the activities dataset, that I can then merge it with the big dataset
colnames(activities) <- c("Activity ID", "Activity Description")
data_descriptive_activity <- merge(activities, columns_needed)
#now we can remove the Activity ID column
data_only_descriptive_activity <- data_descriptive_activity[,-1]


#next, we are going to make the column names more descriptive by replacing some of the abbreviations

names(data_only_descriptive_activity) <- gsub("Acc", "Accelerometer", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("^t", "time", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("^f", "frequency", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("Mag", "Magnitude", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("Gyro", "Gyroscope", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("-mean()", "Mean", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("-std()", "StandardDeviation", names(data_only_descriptive_activity))
names(data_only_descriptive_activity) <- gsub("BodyBody", "Body", names(data_only_descriptive_activity))
str(data_only_descriptive_activity)


#lastly, we average each variable for each activity and each subject and store the data in a second dataset
library(dplyr)
tidy_data <- data_only_descriptive_activity %>%
  group_by(`Subject ID`, `Activity Description`) %>%
  summarise_all(funs(mean))
str(tidy_data)
#export as text file
write.table(tidy_data, "./tidy_data.txt", row.names = FALSE, quote = FALSE)

