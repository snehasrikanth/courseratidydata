Getting and Cleaning Data - Course Project

The porpouse of this README.md file is to explain the analysis files in a clear and udestantable manner.

This is the course project for the Getting and Cleaning Data Coursera course made by Sebastian Posada D. The R script Run_analysis.R, base on the Human Activity Recognition Using Smartphones Dataset, does the following:

Download the dataset from web if it does not already exist in the working directory (CProject).
Read and organice both Data sets ( Test & Training), asigining them column names in order to execute the project 5 steps required.
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. Data Set named: Mean_Std_data
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set ( Independent_DS ) with the average of each variable for each activity and each subject.
The final data set is Named : FinalData.txt
This Repo contais as well:
CodeBook.md : Code Book name the variables, the data and the transformations performed to tyde and organice the final data set.
FinalData.txt : Is the final result Data afer all the above steps as required in the course.
