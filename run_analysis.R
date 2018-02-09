
library(plyr)
library(data.table)
subjectTrain <-  read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE)
xTrain <- read.table("./UCI HAR Dataset/train/x_train.txt", header = FALSE)
yTrain<- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)



subjectTest<-  read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE)
xTest <- read.table("./UCI HAR Dataset/test/x_test.txt", header = FALSE)
yTest<- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)


# Organizing and combining raw data sets into single one
xDataSet<- rbind(xTrain, xTest)
yDataSet<- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)

dim(subjectDataSet)
dim(xDataSet)
dim(yDataSet)


# Extract only the measurements { mean & standard deviation for each measurement}
xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("./UCI HAR Dataset/features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("./UCI HAR Dataset/features.txt")[grep("-(mean|std)\\(\\)", read.table("./UCI HAR Dataset/features.txt")[, 2]), 2] 
View(xDataSet_mean_std)
dim(xDataSet_mean_std)

# Use descriptive activity names to name the activities in the data set.
yDataSet[, 1] <- read.table("./UCI HAR Dataset/activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"
View(yDataSet)

#Appropriately label the data set with descriptive activity names.
names(subjectDataSet) <- "Subject"
summary(subjectDataSet)

# Organizing and combining all data sets into single one.

singleDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)

# Defining descriptive names for all variables.
names(singleDataSet) <- make.names(names(singleDataSet))
names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))

View(singleDataSet)


#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
names(singleDataSet)

Data2<-aggregate(. ~Subject + Activity, singleDataSet, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)












