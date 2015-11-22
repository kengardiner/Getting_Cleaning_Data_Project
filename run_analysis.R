# You should create one R script called run_analysis.R that does the following. 
#   Merges the training and the test sets to create one data set.
#   Extracts only the measurements on the mean and standard deviation for each measurement. 
#   Uses descriptive activity names to name the activities in the data set
#   Appropriately labels the data set with descriptive variable names. 
#   From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract  means and standard deviations 
extract_features <- grepl("mean|std", features)

# Load X & Y Data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# means and standard deviations for each measurement.
X_test = X_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_Data_Out   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_Data_Out, file = "./tidy_Data_Out.txt", row.names = FALSE)