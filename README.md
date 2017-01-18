#Data Cleaning Assignment
##ReadMe

This script creates a tidy data file of means and standard deviations, following the tidy guidelines presented in:
https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
and http://vita.had.co.nz/papers/tidy-data.pdf

The presentation of code is guided by https://google.github.io/styleguide/Rguide.xml

#Process:
0   Prepare raw files

0.1 Create directory for the raw data if it doesn't already exist

0.2 Download the file if it hasn't been downloaded already

0.3 Unzip it if we haven't already

1.  Merges the training and the test sets to create one data set.

1.1 Read in train and test with label and subject files

1.2 Add features as names of dataframes, train and test

1.3 Attach Labels and Subject to train and test, then remove label and subject lists

1.4 Add identifier variable to each table then join

2.  Extracts only the measurements on the mean and standard deviation for each measurement.

2.1 Make column names vaild

2.2 Extract the means and standard deviations for each measurement

3.  Uses descriptive activity names to name the activities in the data set

3.1 Read in label names

3.2 Convert current values to characters

3.3 Create factor that uses values and lables from value names, so activity names are descriptive

3.4 Demonstrate effectiveness

4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.)