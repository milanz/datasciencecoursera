##run_analysis.R


##Step 0. Reads the data
activity_labels = read.table("UCI HAR Dataset//activity_labels.txt")
features = read.table("UCI HAR Dataset//features.txt")


##train dataset
subject_train = read.table("UCI HAR Dataset//train//subject_train.txt")
x_train = read.table("UCI HAR Dataset//train//X_train.txt")
y_train = read.table("UCI HAR Dataset//train//y_train.txt")

# body_acc_x_train = read.table("UCI HAR Dataset//train/Inertial Signals/body_acc_x_train.txt")
# body_acc_y_train = read.table("UCI HAR Dataset//train/Inertial Signals/body_acc_y_train.txt")
# body_acc_z_train = read.table("UCI HAR Dataset//train/Inertial Signals/body_acc_z_train.txt")
# 
# total_acc_x_train = read.table("UCI HAR Dataset//train/Inertial Signals/total_acc_x_train.txt")
# total_acc_y_train = read.table("UCI HAR Dataset//train/Inertial Signals/total_acc_y_train.txt")
# total_acc_z_train = read.table("UCI HAR Dataset//train/Inertial Signals/total_acc_z_train.txt")
# 
# body_gyro_x_train = read.table("UCI HAR Dataset//train/Inertial Signals/body_gyro_x_train.txt")
# body_gyro_y_train = read.table("UCI HAR Dataset//train/Inertial Signals/body_gyro_y_train.txt")
# body_gyro_z_train = read.table("UCI HAR Dataset//train/Inertial Signals/body_gyro_z_train.txt")

##test dataset
subject_test = read.table("UCI HAR Dataset//test//subject_test.txt")
x_test = read.table("UCI HAR Dataset//test//X_test.txt")
y_test = read.table("UCI HAR Dataset//test//y_test.txt")

# body_acc_x_test = read.table("UCI HAR Dataset//test/Inertial Signals/body_acc_x_test.txt")
# body_acc_y_test = read.table("UCI HAR Dataset//test/Inertial Signals/body_acc_y_test.txt")
# body_acc_z_test = read.table("UCI HAR Dataset//test/Inertial Signals/body_acc_z_test.txt")
# 
# total_acc_x_test = read.table("UCI HAR Dataset//test/Inertial Signals/total_acc_x_test.txt")
# total_acc_y_test = read.table("UCI HAR Dataset//test/Inertial Signals/total_acc_y_test.txt")
# total_acc_z_test = read.table("UCI HAR Dataset//test/Inertial Signals/total_acc_z_test.txt")
# 
# body_gyro_x_test = read.table("UCI HAR Dataset//test/Inertial Signals/body_gyro_x_test.txt")
# body_gyro_y_test = read.table("UCI HAR Dataset//test/Inertial Signals/body_gyro_y_test.txt")
# body_gyro_z_test = read.table("UCI HAR Dataset//test/Inertial Signals/body_gyro_z_test.txt")

## Step 1. Merges the training and the test sets
x_total=rbind(x_train,x_test)
y_total=rbind(y_train,y_test)
subject_total=rbind(subject_train,subject_test)

## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement
features_character=as.character(features$V2)
vect_std_dev = grepl("mean()",features_character) | grepl("std()",features_character)
x_total_ext = x_total[,vect_std_dev]
col_names  = features_character[vect_std_dev]

##Step 3. Uses descriptive activity names to name the activities in the data set
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


##Step 4. Appropriately labels the data set with descriptive variable names.

names(x_total_ext) <- col_names

##Step 5. From x_total_ext, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
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

##Step 6. Writing final_data into the table
write.table(final_data,file="final_data.txt",row.names = FALSE)



