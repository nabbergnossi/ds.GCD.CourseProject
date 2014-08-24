Getting and Cleaning Data Course Project
====================

#Context
This readme.md explains the R script run_analysis.R used to complete the Getting and Cleaning Data Course Project


#run_analysis.R details
In this section you'll find a description of each of the parts of the run_analysis.R script.

**Please note that each of the following headings can be found in a comment line of the same name in run_analysis.R**


##load libraries
In addition to the base package, run_analysis.R loads the "data.table" library. I use require to check for and load the package. A warning will result if the package is not loaded.

##set appropriate working directory
this script uses the working directory "C:/rprojects/getcleandata/UCI HAR Dataset." You will need to set your working director appropriately.

run_analysis.R uses relative paths. This works fine if your working director is the UCI HAR Dataset. If you don't have the dataset please download using this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##load common data sets
Common data sets are those that apply to both test and train. Specifically, we load the list of features (features.txt) and acitivties (activity_labels.txt). 

Transformations applied to the common data set are described in details in CodeBook.md.

##read files for test and train
3 separate files for the train and test data set are read into data frames by the script.
###test
**x_test.txt** read into data frame **test**
**y_test.txt** read into data frame **test.labels**
**subject_test.txt** read into data frame **test.subjects**

###train
**x_train.txt** read into data frame **train**
**y_train.txt** read into data frame **train.labels**
**subject_train.txt** read into data frame **train.subjects**

##cleaning up column names
One of the primary objectives of run_analysis.R is to use clean column names. in this section feature names replace reference IDs in the labels data frame. Meaningful column names "subject" and "activity" replace generic column names created when the data was loaded.   

##combining
In this section of the script I use cbind to bind subject, activity, and "dataset" to the main data set. Please see CodeBook.md for details on these variables. Next a merge is used to bring in a meaningful activity name that replaces the value.

##subsets
In this section I create a function for deriving the mean and std measures from the set of variables in the original test and train data. I think apply that function on the combined data sets for train(df.train) and test(df.test).

##merge test and train, create data.table and order it nicely
In this section of the script I combine the test and train data sets using rbind.fill. Once combined, a data.table is created from the merge set. I do this so we can take advantage of data.table features like .SD when creating the separate data set for mean by subject and activity.

**the tidy data set is a data.table named DT**

#tidy data set with the average of each variable for each activity and subject
In this section I use lapply on the subset data of the DT object to create a separate data set (**DT.mean**) that summarizes each subject and activity with the average for each variable. 

