# CleanDataProgAssign
Repo for the Clean Data Programming Assignment
This README.md file walks thru the steps I used to create the tidy data, it also describes the variables
NOTE: As should be, my run_analysis.r file is commented with the steps used in detail. Please see

#### General Steps in Creating the tidy data set in the tidyDataVmusic.txt ######

1) read in the files x_train and x_test files - contains the measurement or observations
2) read in the y_train and y_test files - contains a key or id to the activity for each observation
3) read int he subject files - contains a key or id for each subject for each observations

NOTE: poor design for these data files - we're left to "assume" based on row count.....
that each id in the y files corresponds to one observation in the x files. Same consideration for the subject files

4) read in the features.txt - this a list of all of the kinds or types of measurements
   each row in the features.txt corresponds to a column in the x_test and x_train files
   for example - one row in the features file is tBodyAcc-std()-Y which represents one kind or type of measurement taken


5) merge or add in the subject ID to the x_test and x_train files so each observation has a subject ID
6) merge or add in the activity ID to the x_test and x_train files so each observation has an activity ID
   NOTE: this is done through the cbind() function
 
7) Combine the x_test and x_train file into a combined file which has all measurements for both training and testing

8) Clean up the column headings for this combined file which at this point have names like V1, V2, etc.
   8a) create a vector of column names starting with subjectID and activityID adding in the names from features.txt
   8b) replace the hyphens and parentheses characters which will cause problems with r functions
   8c) replace the column names in the combined data frame with those from the vector created here

AT THIS POINT: We have a combined file or data frame with both testing and training data and.......
  the combined data frame has the subjetc ID and activity ID, but it has too many measurements
  The requirements are - only take or provide the mean and standard measuremnets

9) Create a subset of column names that are only for the measurement types we want, and use that to subset the combined data frame
  9a) create a vector of column names starting with subjectID and activityID adding in the names from features.txt
  NOTE: this vector only takes column names with the words "mean" or "std" in them - 
  9b) replace the hyphens and parentheses characters which will cause problems with r functions
  9c) replace the column names in the combined data frame with those from the vector created here

10) Create a new data frame that has a subset of the combined data frame, so it only has 68 columns instead of 500

11) Add the activity labels to this data frame
  11a) Open the activity file
  11b) Read in the line(s) of data --- it's just one line of text
  11c) Use string split to split the text into a list, where each item in the list has an activity ID and activity name
  11d) Create a data frame from the list, where one column is the activity ID, and the next column is the activity name


12) Merge or effecively add in the activity name into the subset of the combined data frame

13) Take the mean (or average) of each measurement by activity and subject
	NOTE: There are approximately 67 measurements that we have to take the mean of 
	Using the colwise argument of the ddply function lets you apply the function mean to all the numeric columns
	The resultant data frame is almost our tiday data set

NOTE: Using colwise argument on numerica columns within the ddply function removes any character columns, like our activity names

14) Add back in the activity names - by merging the tidy data frame with the activity data frame created in Step 11

15) Write out the tidy data frame to a text file using write.table


##### VARIABLES in tidyDataVmusic.txt ######
activityID - a unique identifier for an activity done by the subjects while taking the measurements
activityName - a label given to an activity done by the subjects while taking the measurements
subjectID - a unique identifier given to an individual person (the subject) being measured while doing the activity

all remaining columns are measurement columns - a series of measurements taken from the phone/device on the subject doing the activity
    NOTE: The meausrements come from an accelerometer and gyroscope 3-axial raw signals
    The measurements provided are not the raw measurements, but rather derived from the raw measurements through various filters
    Finally - the values provided for each measurement is the mean() or averaged value by activty and subject

