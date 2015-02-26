### Study Design
The tidy data set provided contains the average of all measurements that were standard deviations and means by activity name and subject. 

The data originally came from [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), but for this analysis, the data was downloaded from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The [run_analysis.R](https://github.com/jcgaukel/Tidy-Data-Project/blob/master/run_analysis.R) script can be used to process the raw data files as outlined in the [README.md](https://github.com/jcgaukel/Tidy-Data-Project/blob/master/README.md) file.

### Step by Step
A step by step process the decribes how I created the tidy data set from the starting data is provided in the Reademe.Md file - please look there


### Variables
All measurements are normalized, and therefore are unitless.  For specific on measurements, see documentation included with the data files.

| Variable Name | Variable Number | Description | Variable Type | Values |
| ------------------------------------- | :-------------------------------------: | ------------------------------------- | ------------------------------------- | ------------------------------------- |
| activityID | 1 | A unique identifier for each activity that the subject performed. | integer | 
| activityName | 1 | The name of the activity that the subject performed. | character | WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING |
| subjectID | 2 | The ID of the subject that performed the activity. | numeric |  |
| EXAMPLE: tBodyAcc-mean()-X | 3 |  | numeric |  |
all of the other variables are numeric measurements taken from the device and described in detail in the project info file





