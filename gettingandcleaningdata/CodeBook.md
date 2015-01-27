# Getting and Cleaning Data Project Course

## Codebook of the cleaned data

**ewöl red**
============

The project uses the data set available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

run_analysis.R script merges the test and training data from the original data set into a final dataset, extracts specific features, average them over acivities and users and appropriatley labels columns based on variable and activity description from the original data. A detailed description run_analysis.R is provided in the README.txt file.

Raw data located in extracted 'UCI HAR Dataset' folder:

- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt' and 'test/subject_test.txt Each row identifies the subject who performed the activity for each window sample.


Processed data is obtained from 'run_analysis.R' and stored in 'final_data.txt' where each row denotes averaged feature values for each (activity, subject) pair.

* First column contains activity names: 'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS','SITTING', 'STANDING', 'LAYING'.

* Second column contains subject names: 1-30.

* The rest of columns contain averaged feature values.

