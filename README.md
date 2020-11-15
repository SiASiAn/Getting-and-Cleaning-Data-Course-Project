# Getting-and-Cleaning-Data-Course-Project

This is my contribution to the course project of the "Getting and Cleaning Data" Coursera course.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

The data can be retrieved at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This repository contains three files:
1) Code book. The Code book briefly describes the modifications that were done to the data and the variables involved.
2) run_analysis.R. This file is my R code and can be used to reproduce the analysis. It goes through to following 5 steps:
      - Merges the training and the test sets to create one data set.
      - Extracts only the measurements on the mean and standard deviation for each measurement.
      - Uses descriptive activity names to name the activities in the data set
      - Appropriately labels the data set with descriptive variable names.
      - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
3) tidy_data.txt. This is the final product of my analysis.
