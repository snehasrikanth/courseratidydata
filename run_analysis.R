# Week 4 Getting and Cleaning Data Course Project
#
#Downloading the file 
if( !file.exists("CProject")){dir.create("CProject")}

temp <- tempfile("Pdata",tmpdir="CProject",fileext="zip")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)

library("data.table")
library("dplyr")

# - Geting and CLeannig Test Set

#1) substracting the data.
Te_subjects<- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
Te_set <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
Te_labels <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
Features <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))

#Nameing
Te_subjects <- rename(Te_subjects, Subject = V1)
Te_labels <- rename(Te_labels, Activity = V1)

#2)Assigning the Features as col names
Features$V1 <- NULL
#dim(Features) 
# Obs	Variables
# 561	1

#dim(Te_set)
# Obs	Variables
# 2947	561

Features <- transpose(Features)
Features <- as.character(Features)

#Renaming the TEST Set with Features as column names (tsfn)
tsfn <- setnames(Te_set,colnames(Te_set),Features)

#3)Merging subjecy column & labels column & test set

#Merging the  test Set			
Test_set <- cbind(Te_subjects,Te_labels)
Test_set <- cbind(Test_set,tsfn)

#head(Test_set,2)
# Subject Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
#1       2        5         0.2571778       -0.02328523       -0.01465376
#2       2        5         0.2860267       -0.01316336       -0.11908252


# - Geting and CLeannig Trainning Set 

#1) substracting the data.
Tra_subjects<- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))
Tra_set <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
Tra_labels <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))

#Nameing
Tra_subjects <- rename(Tra_subjects, Subject = V1)
Tra_labels <- rename(Tra_labels, Activity = V1)

#2)Assigning the variable names
# Use same Features from  above. (test set)

#Renaming the TRAINIG Set with features as column names (trsfn)
trsfn <- setnames(Tra_set,colnames(Tra_set),Features)

#3)Merging subjecy column & labels column & trainning set

#Merging the  trainning Set			
Train_set <- cbind(Tra_subjects,Tra_labels)
Train_set <- cbind(Train_set,trsfn)

#head(Train_set,2)
#  Subject Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
#1       1        5         0.2885845       -0.02029417        -0.1329051
#2       1        5         0.2784188       -0.01641057        -0.1235202


# Q1) Merging the two`s data sets, training 70% and test 30%.

#dim (Test_set)		dim (Train_set)		total number of rows
# 2947  563		    	7352  563			   10299

# All colmun names are the same so its just simply binding the colums of two 	data sets

DS <- rbind(Test_set,Train_set)		

#dim (DS)
#10299   563


# Q2) Extracting only the measurements on the mean and Std for each measurements.

# Since the "features" are already organice as character vectors, we just need to subset the desired data.

Mean_Std_data<- DS[, grep("-([Mm]ean|[Ss]td)\\(\\)", Features)]

#dim(Mean_Std_dara)
#10299    66


# Q3)Implementing descriptive activity Labels in the data set.

Activity_labels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))

Mean_Std_data$Activity <-  Activity_labels[Mean_Std_data$Activity, 2]
unlink(temp)



# Q4)Labeling the Data with descriptive variable names.

names(Mean_Std_data) <- gsub("Acc","Accelerometer",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("Gyro","Gyroscope",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("BodyBody","Body",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("Mag","Magnitude",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("^t","Time",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("tBody","TimeBody",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("-mean()","Mean",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("angle","Angle",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("gravity","Gravity",names(Mean_Std_data))
names(Mean_Std_data) <- gsub("-std()","Std", ignore.case=T,names(Mean_Std_data))
names(Mean_Std_data) <- gsub("^f|-freq()","Frequency",ignore.case=T,names(Mean_Std_data))


# Q5) Independent Data Set with avg. for each variable, each activity and each subject.

Independent_DS <- Mean_Std_data %>% group_by(Subject, Activity) %>% summarise_all(funs(mean)) %>% arrange(Subject)

#Final Check
#dim(Independent_DS)c
# 180  66

#str(Independent_DS)
#tibble [180 × 66] (S3: grouped_df/tbl_df/tbl/data.frame)
#$ Subject                                           : int [1:180] 1 1 1 1 1 1 2 2 2 2 ...
#$ Activity                                          : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
#$ TimeBodyAccelerometerMean()-X                     : num [1:180] 0.222 0.261 0.279 0.277 0.289 ...

write.table (Independent_DS, "CProject/FinalData.txt",row.name = F , quote = F)


