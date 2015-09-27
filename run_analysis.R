####################################################################################################
## Coursera Data Science Specialization: Getting and Cleaning Data Course Project
## run_analysis.R script performas the following
##     * Retrieves the raw data set from source if it doesn't already exist
##     * Merges the training and the test sets to create one data set.
##     * Extracts only the measurements on the mean and standard deviation for each measurement. 
##     * Uses descriptive activity names to name the activities in the data set
##     * Appropriately labels the data set with descriptive activity names. 
##     * Creates a tidy data set with the average of each variable for each activity and each subject. 
####################################################################################################

## Load required libraries
library(data.table)
library(plyr)

## check if data directory exists, if not download file and unzip
if (!file.exists("./UCI HAR Dataset")) {
        print('Downloading zipped raw data file...')
        download.file(
                "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "./getdata-projectfiles-UCI HAR Dataset.zip"
        )
        print('Extracting data...')
        unzip("getdata-projectfiles-UCI HAR Dataset.zip")
}

## Set the directory containing the data. Assumption is that all code will be run from the parent directory 
## containing this data directory which is created when raw data is downloaded and extracted
data_dir = "UCI HAR Dataset"

## Read Meta Data -  Activity Labels and Feature Names
features_names <- read.table(file.path(data_dir, "features.txt"),header = FALSE, check.names = FALSE)
activityLabels <- read.table(file.path(data_dir, "activity_labels.txt"),header = FALSE)

## Read Test Data
activity_test <- read.table(file.path(data_dir, "test", "y_test.txt"), header = FALSE)
subject_test  <- read.table(file.path(data_dir, "test", "subject_test.txt"), header = FALSE)
features_test <- read.table(file.path(data_dir, "test", "X_test.txt"), colClasses = rep("numeric", 561), header = FALSE, check.names = FALSE)

## Read Training Data
activity_train <- read.table(file.path(data_dir, "train", "y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(data_dir, "train", "subject_train.txt"),header = FALSE)
features_train <- read.table(file.path(data_dir, "train", "X_train.txt"), colClasses = rep("numeric", 561), header = FALSE, check.names = FALSE)

## Merge the training and Test data by rows
subject_merged  <- rbind(subject_train, subject_test)
activity_merged <- rbind(activity_train, activity_test)
features_merged <- rbind(features_train, features_test)

## Assign names to variables
names(subject_merged)  <- c("subject")
names(activity_merged) <- c("activity")
names(features_merged) <- features_names$V2

## Create a data frame of the combined data
Data <- cbind(subject_merged, activity_merged, features_merged)

## Subset Name of Features using measurements on mean and standard deviation
## Note: The following commented code would ignore the feature names containing meanFreq()
##       So it was deliberaly replaced with a regex pattern that was used to include them
##filter_features_names<-features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]
filter_features_names <- features_names$V2[grep("mean|std", features_names$V2)]
my_subset <- c("subject", "activity", as.character(filter_features_names))

## Subset the required data using above
Data <- subset(Data, select = my_subset)


## replace numeric activity column with corresponding text labels from the activity label dataframe
Data$activity <- activityLabels[match(Data$activity, activityLabels[[1]]), 2]

## Clean-up names and format to show descriptive variable names
## Remove parenthesis
names(Data) <- gsub('\\(|\\)',"",names(Data), perl = TRUE)
## Make syntactically valid names
names(Data) <- make.names(names(Data))

## Label the Data Set with descriptive variable names
names(Data) <- gsub("^t", "Time", names(Data))
names(Data) <- gsub("^f", "Frequency", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("angle", "Angle", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("meanFreq", "MeanFrequency", names(Data), ignore.case = TRUE)
names(Data) <- gsub("gravity", "Gravity", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("tBody", "TimeBody", names(Data))
names(Data) <- gsub("\\.mean",".Mean", names(Data), ignore.case = TRUE)
names(Data) <- gsub('\\.std',".StandardDeviation", names(Data), ignore.case = TRUE)

## Create an independent tidy data set with the average of each variable for each activity+subject
TidyData = ddply(Data, c("subject","activity"), numcolwise(mean))

## Write output to text file without row names
write.table(TidyData, file = "tidy_data.txt", row.names = FALSE)