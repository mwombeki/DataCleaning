# Reading the datasets
testdata <- list.files("UCI HAR Dataset/test/Inertial Signals/", full.names = TRUE)
trainingdata <-list.files("UCI HAR Dataset/train/Inertial Signals/", full.names = TRUE)

# extracting the headers
headers  <- read.delim("UCI HAR Dataset/features.txt",header = FALSE, strip.white = TRUE, sep = "", nrows = 128)
ValNames <- headers$V2

# Merging the test datasets
testdatabind <- data.frame()
for (i in 1:length(testdata))
        testdatabind <- rbind(testdatabind, read.delim(testdata[i], sep = "", header = FALSE,col.names = ValNames, check.names = FALSE))

# Merging the traing datasets
trainingdatabind <- data.frame()
for (i in 1:length(trainingdata))
        trainingdatabind <- rbind(trainingdatabind, read.delim(trainingdata[i], sep = "", header = FALSE, col.names = ValNames, check.names = FALSE))

# combining the trainig and test datasets
combineddata <- rbind(testdatabind,trainingdatabind)

# extracting only the Mean and STD datasets
stdmeandata <- combineddata[,grepl("std|mean", colnames(combineddata), ignore.case = TRUE)]

# Load, combine, and rename the participant testing and training data
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subject_combined <- rbind(subject_train, subject_test)
names(subject_combined) <- "SubjectID"


labels_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
labels_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
labels_combined <- rbind(labels_train, labels_test)
names(labels_combined) <- "ActivityID"

activities <- read.table('./UCI HAR Dataset/activity_labels.txt',
                         col.names = c("ActivityID", "ActivityLabel"))

features <- read.table('./UCI HAR Dataset/features.txt',
                       col.names = c("FeatureID", "FeatureLabel"))
# Tidy Data second file
tidy <- data.table(combineddata)
means <- tidy[,lapply(.SD, mean), by=c("SubjectID", "ActivityLabel")]
write.table(means, "tidy_data.txt", row.name = FALSE)
write.table(colMeans(means), file = "tidy_data", row.names = FALSE)