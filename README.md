## Project Description
The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

You will be required to submit:

1. a tidy data set as described below
2. a link to a Github repository with the run_analysis.R script for performing the analysis, and
3. a code book that describes the variables, the data, and any transformations or
   work that you performed to clean up the data called CodeBook.md. You should also
   include a README.md in the repo with your scripts. This file explains how all
   of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing.
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced
algorithms to attract new users. The data linked to from the course website represent
data collected from the accelerometers from the Samsung Galaxy S smartphone.
A full description is available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained.


The raw data for the project is avaialble [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The R script `run_analysis.R` created will do the following.

* Retrieves the raw data set from source if it doesn't already exist
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## What is in this Repository?

* `README.md`: this file
* `CodeBook.md`: information about raw and tidy data set, transformations and variables
* `run_analysis.R`: R script to transform raw data set in a tidy one

## How do I create the tiday data set?

1. Clone this repository: `git clone git@github.com:css281/GettingAndCleaningData.git`
2. Open a R console and set the working directory to the repository root (use setwd())
3. Execute run_analisys.R script: `source('run_analysis.R')`. Note: the `plyr` and `data.table` packages are required 
4. A file containing the tidy data `tidy_data.txt` will be created in the repository root folder

