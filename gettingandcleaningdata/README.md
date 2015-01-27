# Getting and Cleaning Data Project Course

## Description of the run_analysis.R script

**ewöl red**
============

The project uses the data set available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Description of each step:

Step 0. downloads the input data set and extracts it in "UCI HAR Dataset" folder.

```
d1 =download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "UCI HAR Dataset.zip",method = "wget")
unzip("UCI HAR Dataset.zip")
```

Reads the Activity Labels and measured Features
```
activity_labels = read.table("UCI HAR Dataset//activity_labels.txt")
features = read.table("UCI HAR Dataset//features.txt")
```

where

- 'activity_labels' links the class labels with their activity name.
- 'features' list of all features.


Reads train and test datasets

```
subject_train = read.table("UCI HAR Dataset//train//subject_train.txt")
x_train = read.table("UCI HAR Dataset//train//X_train.txt")
y_train = read.table("UCI HAR Dataset//train//y_train.txt")

subject_test = read.table("UCI HAR Dataset//test//subject_test.txt")
x_test = read.table("UCI HAR Dataset//test//X_test.txt")
y_test = read.table("UCI HAR Dataset//test//y_test.txt")
```

where

- in 'subject_train' and 'subject_test' each row identifies the subject who performed the activity for each window sample
- 'x_train' and 'x_test' are training and test sets, respectively.
- 'y_train' and 'y_test' are training and test labels, respectively.

Step 1. Merges the training and the test sets

```
x_total=rbind(x_train,x_test)
y_total=rbind(y_train,y_test)
subject_total=rbind(subject_train,subject_test)
```
where

- in 'subject_total' each row identifies the subject who performed the activity for each window sample
- 'x_total' is merged set.
- 'y_total' are merged set labels, respectively.


Step 2. extracts only the measurements on the mean and standard deviation for each measurement

```
features_character=as.character(features$V2)
vect_std_dev = grepl("mean()",features_character) | grepl("std()",features_character)
x_total_ext = x_total[,vect_std_dev]
col_names  = features_character[vect_std_dev]
```

where

- 'features_character' is a vector of feature characters
- 'vect_std_dev' is a logical vector denoting which columns represent mean and standard deviation measures 
- 'x_total_ext' new dataset obtained by extracting the the desired columns from the merged set 'x_total'
- 'col_names' is a vector of column names

Step 3. uses descriptive activity names to name the activities in the data set

```
subject_names=rep("a",length(subject_total$V1))
for (i in 1:30){
  subject_names[subject_total$V1==i]=as.character(i)
}
x_total_ext = cbind(subject_names,x_total_ext)
col_names = c("Subject",col_names)


activity_names=rep("a",length(y_total$V1))
for (i in 1:nrow(activity_labels)){
  activity_names[y_total$V1==i]=as.character(activity_labels$V2[i])
}
x_total_ext = cbind(activity_names,x_total_ext)
col_names = c("Activity",col_names)
```

where

- 'subject_names' is a column of subject names prebinded to the 'x_total_ext'
- 'activity_names' is a column of activity names prebinded to the 'x_total_ext' 
- 'col_names' are updated with Activity and Subject column names

Step 4. appropriately labels the data set with descriptive variable names

```
names(x_total_ext) <- col_names
```

Step 5. from x_total_ext, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```
final_data = data.frame()
for (i in 1:nrow(activity_labels)){
  for (j in 1:30){
    xx = x_total_ext[y_total==i & subject_total==j,]
    xx = xx[,3:length(xx)]
    mean_xx = c(activity_labels$V2[i],j,sapply(xx,FUN=mean))
    final_data = rbind(final_data,mean_xx)
    final_data[(i-1)*30+j,1]<-as.character(activity_labels$V2[i])
  }
}
names(final_data) <- col_names
```
where nested loops iterate first over all subjects performing particular activity, and then over activities in order to average the measured features for each (activity, subject) pair. The averaged values are written in 'final_data' set where each row denotes averaged feature values for each (activity, subject) pair. 


Step 6. writes final_data into the table

```
write.table(final_data,file="final_data.txt",row.names = FALSE)
```

where 'final_data' is written to 'final_data.txt' file.