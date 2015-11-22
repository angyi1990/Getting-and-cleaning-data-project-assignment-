library(dplyr)

y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")

features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

X_train <- read.table("train/X_train.txt")
X_test <- read.table("test/X_test.txt" )



colnames(activity_labels)<- c("V1","Activity")

#merging the y_train with the activity label
subject<- rename(subject_train, subject=V1)
train<- cbind(y_train,subject)
train1<- merge(train,activity_labels, by=("V1"))

#giving names from features to the X_train data frame
colnames(X_train)<- features[,2]

#Combining y_train, activity labels, X_train
train2<- cbind(train1,X_train)
#eliminating the first column from train2 to avoid error "duplicate column name"
train3<- train2[,-1]

#selecting only the columns that contains means and std
train4<- select(train3,contains("subject"), contains("Activity"), contains("mean"), contains("std"))


#Analysis of the 30% of the Volunteer select for generating the test data

colnames(activity_labels)<- c("V1","Activity")

#merging the y_test with the activity label
subjecta<- rename(subject_test, subject=V1)
test<- cbind(y_test,subjecta)
test1<- merge(test,activity_labels, by=("V1"))


#giving names from features to the X_test data frame
colnames(X_test)<- features[,2]

#Combining y_test, activity labels, X_test
test2<- cbind(test1,X_test)

#eliminating the first column from train2 to avoid error "duplicate column name"
test3<- test2[,-1]

#selecting only the columns that contains means and std
test4<- select(test3,contains("subject"), contains("Activity"), contains("mean"), contains("std"))



# Combining Train data with Test data
run_analysis1<- rbind(train4,test4)

#Summarizing the data



run_analysis<- (run_analysis1%>%
                        group_by(subject,Activity) %>%
                        summarise_each(funs( mean)))

print(run_analysis)

write.table(run_analysis,"./tidy_dataset.txt",row.name=FALSE)
