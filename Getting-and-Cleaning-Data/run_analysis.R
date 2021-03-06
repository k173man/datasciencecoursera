require(data.table)
require(dplyr)
# require(bit64)

# setwd("~/tmp/data")

# only checking for the existence of directory/directories is risking; they could be empty  
uhdDir = "UCI HAR Dataset"
testTrainDirs = function (path) all(c("test", "train") %in% list.dirs(path, full.names = F, recursive = F));
# are any of the directories in the wd named "UCI HAR Dataset"
UciHarDsDir = uhdDir %in% list.dirs(getwd(), full.names = F, recursive = F)
# do both the "test" directory & the "train" directory found in the wd
TestTrainDirs = testTrainDirs(getwd())

# check for test & train subdirectories
if (!TestTrainDirs & UciHarDsDir)
    UciHarDsDir = UciHarDsDir & testTrainDirs (file.path(getwd(), uhdDir, fsep = .Platform$file.sep))

if (!UciHarDsDir & !TestTrainDir) {
  # Download UCI HAR Dataset.zip & extract to wd, which creates a directory called UCI HAR Dataset
  url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = "UCI HAR Dataset.zip")
  unzip("UCI HAR Dataset.zip", exdir = getwd())
  UciHarDsDir = TRUE
}

dataPath = NULL

if(UciHarDsDir) {
  dataPath = paste0(uhdDir, "/")
} else if (TestTrainDirs) {
  dataPath = ""
} else {
    stop("Please read the README file @ https://github.com/k173man/R/blob/master/Coursera%20Data%20Science/03%20Getting%20and%20Cleaning%20Data/README.md")
}

# ***** Step #1 *****
# read test data
testPath = paste0(dataPath, "test/")
test = read.table(paste0(testPath, "X_test.txt"), sep = "")
test$SubjectId = read.table(paste0(testPath, "subject_test.txt"), sep = "")$V1
test$Activity = read.table(paste0(testPath, "y_test.txt"), sep = "")$V1

# read training data
trainPath = paste0(dataPath, "train/")
train = read.table(paste0(trainPath, "X_train.txt"), sep = "")
train$SubjectId = read.table(paste0(trainPath, "subject_train.txt"), sep = "")$V1
train$Activity = read.table(paste0(trainPath, "y_train.txt"), sep = "")$V1

# merge test and training data
trainTest = union(test, train)
# clean up
# rm("test", "train")

# ***** Step #2 *****
# read features
features = fread(paste0(dataPath, "features.txt"))
# get subset of features, which contains only the mean and standard deviation vars
meanStdVars = features[V2 %like% "mean" | V2 %like% "std"]
colIndexes = c(562, 563, unlist(meanStdVars$V1))
# get subset of complete data set, which contains Subject, Activity & the mean and standard deviation vars
meanStdData = trainTest[, colIndexes]

# ***** Step #3 *****
# read activity labels
activities = fread(paste0(dataPath, "activity_labels.txt"))
# Clean up activity labels
activities$V2 = gsub("[_]", " ", activities$V2)
activities$V2 = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(activities$V2), perl=TRUE)
# add activity labels to data
meanStdData$Activity = activities$V2[meanStdData$Activity]
# rm(activities)

# ***** Step #4 *****
# clean up the var names
colNames = gsub("[()]", "", c("SubjectId", "Activity", unlist(meanStdVars$V2)))
# apply cleaned up var names
names(meanStdData) = colNames
# rm(features)

# ***** Step #5 *****
# both of methods below produce the same results; the 1st one is a bit easier to read
# use dplyr to create means df
tidyData = meanStdData %>% 
  group_by(SubjectId, Activity) %>% 
  summarise_each(funs(mean))

# data table (with dplyr to sort data)
## .SD is a data.table idiom, which provides a means for referencing the data; it's shorthand for sub-data...
# tidyData <- data.table(meanStdData)[, lapply(.SD, mean), by = c("SubjectId", "Activity")] %>% 
#     arrange(SubjectId, Activity)

write.table(tidyData, "Tidy_Dataset.txt", row.names = F)

