Getting and Cleaning Data - Course Project


This is the course project for the "Getting and Cleaning Data" course. 

The R script, "run_analysis.R", does the following:

+ Downloads the dataset into the working directory
+ Load the "activity" and "feature" data
+ Loads both the "training" and "test" datasets, keeping only the mean and standard deviation information
+ Loads the "activity" and "subject" data for each dataset, and merges those columns with the dataset
+ Merges the two datasets
+ Converts the "activity" and "subject" columns into factors
+ Creates a "tidy dataset" that consists of the average (mean) value of each variable for each subject and activity pair.
+ The end result is shown in the file "part5_tidy_data.txt.