"This Script Assumes Data Has Been Downloaded To A Local File"

#Loading Libraries
library(data.table)
library(dplyr)
library(quantmod)

"PART 1: Merge training and test sets"
#loading the data sets
trainset <- read.table("./Data/test/X_test.txt")
testset <- read.table("./Data/train/X_train.txt")

#Merge the data sets using rBind
merged <- rbind(trainset, testset)

#Give column names
columns <- read.table("./Data/features.txt")
colnames(merged) <- t(columns[,2])

"PART 2: Get mean and std-dev for each measurement"
#using regular expressions we look for the column names
# that have 'std' or 'mean' in their titles
# then populate a new table with only those columns

means <- grep("mean()", colnames(merged), fixed = TRUE)
std_devs <- grep("std()", colnames(merged), fixed = TRUE)
measures <- merged[, c(means, std_devs)]

"Part 3 Getting Activity Labels"
#Reading in labels
act_labels <-  read.table("./data/activity_labels.txt")

#Combing Test/Trains for the results
test_y <- read.table("./data/test/y_test.txt")
train_y <-read.table("./data/train/y_train.txt")
merged_y <- rbind(test_y, train_y)

#Putting all the info together
results <- cbind(merged_y, measures)
colnames(results)[1] <- "Activity"

"Part 5, labeling the activities"
act_labels$V2 <-  as.character(act_labels$V2)
for(i in 1:length(results[,1])){
  results[i,1] <- act_labels[results[i,1],1]
}

"Part 6, create a tidy data set with averages"
# Read in the subjects info
sub_test <- read.table("./data/test/subject_test.txt")
sub_train <- read.table("./data/train/subject_train.txt")

#Combines the Subject Info
sub_total <- rbind(sub_test, sub_train)data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAJCAYAAAD6reaeAAAAN0lEQVR42mNggIJJ02f+Z0AGE6fN/A8ShEvAOAg86z/DfyyAASvA1D4Toh1ZAK4dIjEL0zxkAQAPeFlrV0HzRgAAAABJRU5ErkJggg==
all_data <- cbind(sub_total, results)
colnames(all_data)[1] <- "Subject"

#Gets Aggregate Data
tidy_dataset <- aggregate(all_data, by = list(all_data$Subject, all_data$Activity), mean)
write.table(tidy_dataset, file="tidy_data.txt")