####### Getting and Cleaning Data
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
####### Course Project - Samsung Activity Monitoring Data
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


###################### THIS R SCRIPT is SUPPOSED TO: 
####### Use/ data from the Samsung Galaxy S Smartphone Accelerometers
####################################################
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 

#############################################
####### Let's go on a 'r' journey, to create this tidy data set
#############################################

## PLEASE ## PLEASE ## PLEASE ## PLEASE ## PLEASE ## PLEASE ## PLEASE ## PLEASE ##
## Assure you have the working directory set appropriately

####################################

## Assure any needed packages are installed and running
## plyr package required 
install.packages("plyr")
library("plyr")

## stringr package makes string replacement easier
install.packages("stringr")
library(stringr)

## the x_train and x_test files contain ONLY the measurements taken -
## these 2 files don't tell you who (which subject) the measurements are for
## these 2 files don't tell you which activities the measurements are for

## read in the x test and x train files
x_testDF <- read.table("x_test.txt")
x_trainDF <- read.table("x_train.txt")

## read in the subject test and subject train files - 
sj_testDF <- read.table("subject_test.txt")
sj_trainDF <- read.table("subject_train.txt")

## read in the activity test and activity train files - 
y_testDF <- read.table("y_test.txt")
y_trainDF <- read.table("y_train.txt")

## create a list of all the columns in the test and train files - this data comes from features.txt
featuresDF <- read.table("features.txt")

## my $0.02 - being a data management professional - the design for the data capture here is pitiful
## because the number of rows in the x_test/train and the subject_test/train are the same.......
## we're left to guess each row in the x_ file corresponds to the same row in the s_file
## guessing is bad - but as I said the design for capturing and storing this data is just pitiful

## column bind or add one column on the x_ files, indicating the subject the measurement is for
x_testDF <- cbind(subjectID = sj_testDF$V1, x_testDF)
x_trainDF <- cbind(subjectID = sj_trainDF$V1, x_trainDF)

## column bind or add one column on the x_ files, indicating the activity the measurement is for
x_testDF <- cbind(activityID = y_testDF$V1, x_testDF)
x_trainDF <- cbind(activityID = y_trainDF$V1, x_trainDF)




## combine the measurements from the test and train data sets together
## this is REQUIREMENT 1. in the project
## remember this data has in the subject ID and the activity ID for the observation or measurements
combinedDF <- merge(x_testDF, x_trainDF, all=TRUE)


## some testing code commented out here which helped to validate the merge
## nrow(x_testDF); nrow(x_trainDF); nrow(combinedDF);
## length(x_testDF); length(x_trainDF); length(combinedDF);
## colnames(x_testDF)[22]; colnames(x_trainDF)[22]; colnames(combinedDF)[22];
## colnames(x_testDF)[148]; colnames(x_trainDF)[148]; colnames(combinedDF)[148];
## colnames(x_testDF)[562]; colnames(x_trainDF)[562]; colnames(combinedDF)[562];

## at this point - we really don't need the original subject and activity files in memory
## we have a single DF of combined data for all measures, witha subject ID and activity ID
rm(y_testDF); rm(y_trainDF); rm(sj_testDF); rm(sj_trainDF); rm(x_testDF); rm(x_trainDF);

## analysis shows there are 561 rows of data in features.txt 
## each row in features.txt represents column heading for the columns in x_test/train
## that is nrow(featuresDF) is 561 and length(x_testDF) or length(x_trainDF) is 561
## note that two additional columns were added one for the subject ID and activity ID

## this is to meet REQUIREMENT 4. in the project
## convert the column heading data in features.txt to a character vector to replace the V1, V2, etc
## note that we read in the features.txt file up front

## set the first two columns in the vector to subjectID and activityID
newColHeadings <- c("activityID","subjectID")
newColHeadings <- c(newColHeadings,  as.character(featuresDF$V2))

## change these column headings to replace hypens with udnerscores
## ONE AGAIN - r is totally inconsistent, some functions can read any strings ddply has issues when column names have hyphens in them
newColHeadings <- str_replace_all(newColHeadings, "-", "_")
newColHeadings <- str_replace_all(newColHeadings, "\\()", "")


## now change the column names in the combined file to more meaningful names
## NOTE: we do NOT need all of these columns, but we're changing all the column names/headings
colnames(combinedDF) <- newColHeadings

## now create a subset of VALID or NEEDED columns - we only want measurements that are mean() or standard()
## this is to meet REQUIREMENT 2. in the project
## the next three lines creates a vector of VALID or NEEDED column names, starting with subjectID and activityID
## the remaining valid column names are created by greping or filtering on names from features.txt with "mean" or "std"
validColumnList <- c("activityID","subjectID")
validColumnList <- c(validColumnList, as.character(featuresDF[grep("*\\-mean()\\b", featuresDF$V2),"V2"]))
validColumnList <- c(validColumnList, as.character(featuresDF[grep("*\\-std()\\b", featuresDF$V2), "V2"]))

## change these valid column headings to replace hypens with udnerscores
## ONE AGAIN - r is totally inconsistent, some functions can read any strings ddply has issues when column names have parentheses in them
validColumnList <- str_replace_all(validColumnList, "-", "_")
validColumnList <- str_replace_all(validColumnList, "\\()", "")


## taking the combined DF with the x_train/test data combined along with tidy column names and the subject ID and activity ID columns 
## create a new DF from this - with ONLY the valid columns needed that is the mean() and std() columns not all columns
combinedDF <- combinedDF[ ,validColumnList]

## now we need to add the activity names or labels - there's a bit of preparation work to get the labels into a DF
## this is to meet REQUIREMENT 3. in the project

## first we need to read them out of the activity.txt file
fileCon <- file("activity_labels.txt", open="r")
activityLabels <- readLines(fileCon)
close(fileCon)                  ## please - don't forget to close your connections

## split out the
activityLabelList <- strsplit(activityLabels, " ")

## create the data frame to store the activity ID and name
activityDF <- data.frame(activityID = integer(length(activityLabelList)), activityName = character(length(activityLabelList)))

## take the first element of each item in the list, and assign it to the activity ID
activityDF$activityID <- as.numeric(sapply(activityLabelList, "[", 1))

## take the second element of each item in the list, and assign it to the activity Name
activityDF$activityName <- sapply(activityLabelList, "[", 2)

## now merge the combined data frame with the activity data frame on the activity ID to add meaningful labels for each activity
## this is to meet REQUIREMENT 3. in the project
combinedDF <- merge(activityDF, combinedDF, by.x = "activityID", by.y="activityID", all =TRUE)

## now we further condense the data by taking the mean of ALL the measurements by activity and subject
## we can apply the mean function by the variables using ddply in the 
tidyData <- ddply(combinedDF, .(activityID, subjectID), colwise(mean, is.numeric))


## the ddply function REMOVES any columns that aren't part of the aggregate or summary functions
## I remerged the activityDF with the tidyData set to add back in the activityName column
tidyData  <- merge(activityDF, tidyData , by.x = "activityID", by.y="activityID", all =TRUE)


## now write out the tidy data frame
write.table(tidyData, "tidyDataVmusic.txt", sep=",", row.names=FALSE, quote=FALSE, col.names=TRUE)
