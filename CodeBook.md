CODEBOOK 
========

## Background 

For this project I worked with the Human Activity Recognition Using Smartphones Dataset from the UCI Machine Learning Repository. 

The data is generated from the experiments carried out with a group of 30 volunteers each performeing six activities (`WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`) wearing a smartphone (Samsung Galaxy S II) on the waist. A complete description is available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained. The raw dataset can be downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The README.txt and features_info.txt files in this dataset provide detailed explananations of the 


The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See `features_info.txt` for more details. 

## What is in the Raw Data?

Note: All Intertia related data contained in `Inertial Signals` subfolders are irrelevant for this project and not referenced

The original data repository includes the following -

- `README.txt` - overview of dataset
- `activity_labels.txt` - numeric activity identifiers mapped to their descriptive labels
- `features.txt` - list of all features names for 561 variables
- `features_info.txt` - describes the variables and how they are created

- **`test folder`** - contains *test* data (2947 observations) in the following 3 text files
files
    - `subject_test.txt` - mapping of each observation to the subject (number 1 to 30) 
    - `X_test.txt` - actual observations for 561 variables from the test subjects
    - `y_test.txt` - observation to numeric activity label mapping

- **`train folder`** - contains *training* data (7252 observations) in the following 3 text files
    - `subject_train.txt` - mapping of each observation to the subject (number 1 to 30) 
    - `X_train.txt` - actual observations for 561 variables from the training subjects
    - `y_train.txt` - observation to numeric activity labelmapping


## Processing and Data Transfromations
All the processing and transformations applied on the data are accomplished by executing the `run_analysis.R` script. The functionality can be broken down into the following steps -

**1. Environment and Data Setup**
Ensure that the required packages data.table and plyr are installed and loaded in R. The script automatically downloads the source data if it is not already available and extracts it. `UCI HAR Dataset` folder is created and containes the source data.

**2. Load Metadata and Data**
Training and Test data for Features, Subject and Actvitiy are loaded into variables from the respective folders. The activity and Feature names from activity_labels.txt and features.txt which are our primary meta data are loaded too. (inline comments in `run_analysis.R` clearly show these steps)

**3. Merge training and test data**
The training and test data for subject, activity and features are merged separately by row first. This creates three data sets each with 10299 observations. While the subject and activity have 1 variable, the features merged set would have 561 columns. Variable names are assigned and all three data sets are combined via column binding to create a dataframe with 10299 observations and 563 columns.
        
**4. Subset `mean` and `std` data**
Data set created in #3 is now subset utilizing `grep` command to select only mean and Standard Deviation data
The tidy data set contains 180 observations with the following 81 variables. This creates a subset with 10299 observations and 81 variables.

**5.  Apply descriptive activity labels**
Using the mapping provided in the "activity_labels.txt" metadata, the numeric activity identifiers (1 to 6) are replaced with their corresponding textual labels.

**6. Format Variable names**
All variable names will be formatted to make them more descriptive and precise using the following transformation during this step.

- remove parenthesis
- create syntactically valid names utilizing `make.names`
- "^t" (variable names starting with t) -> "Time"" for time Domain measurement
- "^f" (variable names starting with f) -> "Frequency"" for Frequency Domain measurement
- "Acc" -> "Accelerometer"
- "angle" -> "Angle"
- "BodyBody" -> "Body"
- "meanFreq"-> "MeanFrequency"
- "gravity" -> "Gravity"
- "Gyro" -> "Gyroscope"
- "Mag" -> "Magnitude"
- "tBody" -> "TimeBody"
- ".mean" -> ".Mean"
- ".std"" -> ".StandardDeviation"


**7. Creates new tidy data set containing averages**
The `ddply` command is used to summarize the data created in #6 by calculating the mean each variable grouped by activity and subject based on the data set in step 6. This results in each subject having 6 rows of data corresponding to the 6 activties. wih 30 subjects, the final tidy dataset will have 180 observations with 81 variables.

**8. Output new tidy data set**
`write.table` is used to generate the output file `tidy_data.txt` cotnaing our result data in the repo root directory. The data dictionary for the 81 variables are listed in the next section

## Data Dictionary

| Variable | Class | Domain | Description |
| -------- | ----- | ------ | ----------- |
| `subject` | Categorical | Integer | Identifier (1 through 30) assigned to individual performing the recorded activity. |
| `activity` | Categorical | Character (Factor) | Type of physical activity performed by subject. Possible values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING |
| * All other variables listed below | Quantitative | Real Number | The other 79 variables in the output are the averages of their corresponding Time and Frequency domain variables (grouped by subject and activity) from the original study. These are all normalized and have values between -1 and 1 and do not have any units.| 

__Note__: All variables listed below suffixed with [XYZ] indicate that there are 3 such variables occurring in order listed for the X, Y and Z axis. For example TimeBodyAccelerometer.Mean.[XYZ] would indicate that there are three output variables 
+ TimeBodyAccelerometer.Mean.X
+ TimeBodyAccelerometer.Mean.Y
+ TimeBodyAccelerometer.Mean.Z

`TimeBodyAccelerometer.Mean.[XYZ]`

- *Description*: the mean of the time domain signal indicating the body linear acceleration in the [XYZ] axis
	
`TimeBodyAccelerometer.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the time domain signal indicating the body linear acceleration in the [XYZ] axis
	
`TimeGravityAccelerometer.Mean.[XYZ]`

- *Description*: the mean of the time domain signal indicating the gravity linear acceleration in the [XYZ] axis
	
`TimeGravityAccelerometer.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the time domain signal indicating the gravity linear acceleration in the [XYZ] axis
	
`timeBodyAccelerometerJerk.Mean.[XYZ]`

- *Description*: the mean of the time domain jerk signal indicating the body linear acceleration in the [XYZ] axis
	
`timeBodyAccelerometerJerk.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the time domain jerk signal indicating the body linear acceleration in the [XYZ] axis
	
`timeBodyGyroscope.Mean.[XYZ]`

- *Description*: the mean of the time domain signal indicating the body angular velocity in the [XYZ] axis
	
`timeBodyGyroscope.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the time domain signal indicating the body angular velocity in the [XYZ] axis
	
`timeBodyGyroscopeJerk.Mean.[XYZ]`

- *Description*: the mean of the time domain jerk signal indicating the body angular velocity in the [XYZ] axis
	
`timeBodyGyroscopeJerk.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the time domain jerk signal indicating the body angular velocity in the [XYZ] axis
	
`timeBodyAccelerometerMagnitude.Mean`

- *Description*: the mean of the time domain signal indicating the body linear acceleration magnitude
	
`timeBodyAccelerometerMagnitude.StandardDeviation`

- *Description*: the standard deviation of the time domain signal indicating the body linear acceleration magnitude
	
`timeGravityAccelerometerMagnitude.Mean`

- *Description*: the mean of the time domain signal indicating the gravity linear acceleration magnitude
	
`timeGravityAccelerometerMagnitude.StandardDeviation`

- *Description*: the standard deviation of the time domain signal indicating the gravity linear acceleration magnitude
	
`timeBodyAccelerometerJerkMagnitude.Mean`

- *Description*: the mean of the time domain jerk signal indicating the body linear acceleration magnitude
	
`timeBodyAccelerometerJerkMagnitude.StandardDeviation`

- *Description*: the standard deviation of the time domain jerk signal indicating the body linear acceleration magnitude
	
`timeBodyGyroscopeMagnitude.Mean`

- *Description*: the mean of the time domain signal indicating the body angular velocity magnitude
	
`timeBodyGyroscopeMagnitude.StandardDeviation`

- *Description*: the standard deviation of the time domain signal indicating the body angular velocity magnitude
	
`timeBodyGyroscopeJerkMagnitude.Mean`

- *Description*: the mean of the time domain jerk signal indicating the body angular velocity magnitude
	
`timeBodyGyroscopeJerkMagnitude.StandardDeviation`

- *Description*: the standard deviation of the time domain jerk signal indicating the body angular velocity magnitude
	
`FrequencyBodyAccelerometer.Mean.[XYZ]`

- *Description*: the mean of the frequency domain signal indicating the body linear acceleration in the [XYZ] axis
	
`FrequencyBodyAccelerometer.StandardDeviation[XYZ]`

- *Description*: the standard deviation of the frequency domain signal indicating the body linear acceleration in the [XYZ] axis
	
`FrequencyBodyAccelerometer.MeanFrequency.[XYZ]`

- *Description*: the mean frequency of the frequency domain signal indicating the body linear acceleration in the [XYZ] axis

`FrequencyBodyAccelerometerJerk.Mean.[XYZ]`

- *Description*: the mean of the frequency domain jerk signal indicating the body linear acceleration in the [XYZ] axis
	
`FrequencyBodyAccelerometerJerk.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the frequency domain jerk signal indicating the body linear acceleration in the [XYZ] axis
	
`FrequencyBodyAccelerometerJerk.MeanFrequency.[XYZ]`

- *Description*: the mean frequency of the frequency domain jerk signal indicating the body linear acceleration in the [XYZ] axis
	
`FrequencyBodyGyroscope.Mean.[XYZ]`

- *Description*: the mean of the frequency domain signal indicating the body angular velocity in the [XYZ] axis
	
`FrequencyBodyGyroscope.StandardDeviation.[XYZ]`

- *Description*: the standard deviation of the frequency domain signal indicating the body angular velocity in the [XYZ] axis
	
`FrequencyBodyGyroscope.MeanFrequency.[XYZ]`

- *Description*: the mean frequency of the frequency domain signal indicating the body angular velocity in the [XYZ] axis
	
`FrequencyBodyAccelerometerMagnitude.Mean`

- *Description*: the mean of frequency time domain signal indicating the body linear acceleration magnitude
	
`FrequencyBodyAccelerometerMagnitude.StandardDeviation`

- *Description*: the standard deviation of frequency time domain signal indicating the body linear acceleration magnitude
	
`FrequencyBodyAccelerometerMagnitude.MeanFrequency`

- *Description*: the mean freqyency of frequency time domain signal indicating the body linear acceleration magnitude
	
`FrequencyBodyAccelerometerJerkMagnitude.Mean`

- *Description*: the mean of the frequency domain jerk signal indicating the body linear acceleration magnitude
	
`FrequencyBodyAccelerometerJerkMagnitude.StandardDeviation`

- *Description*: the standard deviation of the frequency domain jerk signal indicating the body linear acceleration magnitude
	
`FrequencyBodyAccelerometerJerkMagnitude.MeanFrequency`

- *Description*: the mean freqyency of the frequency domain jerk signal indicating the body linear acceleration magnitude
	
`FrequencyBodyGyroscopeMagnitude.Mean`

- *Description*: the mean of frequency time domain signal indicating the body angular velocity magnitude
	
`FrequencyBodyGyroscopeMagnitude.StandardDeviation`

- *Description*: the standard deviation of frequency time domain signal indicating the body angular velocity magnitude
	
`FrequencyBodyGyroscopeMagnitude.MeanFrequency`

- *Description*: the mean freqyency of frequency time domain signal indicating the body angular velocity magnitude
	
`FrequencyBodyGyroscopeJerkMagnitude.Mean`

- *Description*: the mean of the frequency domain jerk signal indicating the body angular velocity magnitude
	
`FrequencyBodyGyroscopeJerkMagnitude.StandardDeviation`

- *Description*: the standard deviation of the frequency domain jerk signal indicating the body angular velocity magnitude
	
`FrequencyBodyGyroscopeJerkMagnitude.MeanFrequency`

- *Description*: the mean freqyency of the frequency domain jerk signal indicating the body angular velocity magnitude

