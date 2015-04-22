# Set working directory
olddir <- getwd()
data_path <- "/home/rafa/documentos/learning/Coursera/Data_Science_Specialty/3.-Getting_and_Cleaning_Data/project1/UCI_HAR_Dataset"
setwd(data_path)

# Load Files
testS<- read.table("./test/subject_test.txt")
testX<- read.table("./test/X_test.txt")
testY<- read.table("./test/y_test.txt")
trainS<- read.table("./train/subject_train.txt")
trainX<- read.table("./train/X_train.txt")
trainY<- read.table("./train/y_train.txt")

# Variable names
var_names <- read.table("features.txt")

# Filter std and mean
pattern <- c("std", "mean")
cols<-grep(paste(pattern, collapse="|"), var_names$V2)

testX <- testX[,cols]
trainX <- trainX[,cols]
names(testX)<-var_names$V2[cols]
names(trainX)<-var_names$V2[cols]

# Join test data
names(testY)[1]<- "Y"
testX$subject <- testS$V1
testY$subject <- testS$V1
test <- merge(testY, testX, by="subject")
rm(list=c("testX", "testY", "testS"))
gc()

# Join train data
names(trainY)[1]<- "Y"
trainX$subject <- trainS$V1
trainY$subject <- trainS$V1
train <- merge(trainY, trainX, by="subject")
rm(list=c("trainX", "trainY", "trainS"))
gc()

# Merge train and test data
total<- rbind(test, train)

# Replace activity id by activity label
activity_labels <- read.table("activity_labels.txt")
total$Y<-activity_labels$V2[total$Y]
names(total)[2]<- "activity"

# Generate final tidy dataset
final <- aggregate(total, by=list(total$subject, total$activity), FUN=mean)
final$activity <- NULL
final$subject <- NULL
names(final)[1]<- "Subject"
names(final)[2]<- "Activity"
write.table(final, "tidy_data.txt", sep="\t", row.names=FALSE)

# Free memory
rm(list=ls())
gc()
