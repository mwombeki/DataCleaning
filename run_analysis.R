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
#gsub("^t","", colnames(combineddata))

# creating the mean for each activity and subject
write.table(colMeans(stdmeandata), file = "tidydatamean", row.names = FALSE)


