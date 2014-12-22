library(reshape2)

#Read the list of feature names and activity labels (WALKING, LAYING, etc)
features <- read.table("features.txt", stringsAsFactors=FALSE)
activityLabels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

#We are only interested in features which capture the mean and standard devation of a measurement
#These correspond to features with mean() or std() in their feature names
filterCol<-grepl("mean\\(",features$V2) | grepl("std\\(",features$V2)

#load the training data
#first column of the trainData is the subject column
trainData <- read.table("./train/subject_train.txt")
#Second column is the acitivity column
trainData <- cbind(trainData, read.table("./train/y_train.txt"))
#The reamining columns are measurements which have been filtered to only include mean & std features
trainData <- cbind(trainData, read.table("./train/X_train.txt")[,filterCol])

#Load the test data in similar fashion as the training data
testData <- read.table("./test/subject_test.txt")
testData <- cbind(testData,read.table("./test/y_test.txt"))
testData <- cbind(testData, read.table("./test/X_test.txt")[,filterCol])

#Combine the training and test data
dataSet <- rbind(trainData,testData)

#Label the columns appropriately
colnames(dataSet)[1] <- "subject"
colnames(dataSet)[2] <- "activity"
colnames(dataSet)[3:ncol(dataSet)] <- features[filterCol,2]

#Values in activity cloumn is rewritten as factor of activity names 
dataSet$activity <- factor(dataSet$activity,labels=activityLabels[,2])

#melt the data with respect to the id variables subject and activity
meltedData <- melt(dataSet, id=c("subject","activity"))

#Create a seconnd, independent tidy data set with the average of each variable for each activity and each subject
tidyData <- dcast(meltedData, subject + activity ~ variable, mean) 

#write tidy data to the data file
write.table(tidyData, file="tidyData.txt", row.names=FALSE)

