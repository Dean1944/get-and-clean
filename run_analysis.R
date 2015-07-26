
 

##########################
# GET AND CLEAN PROJECT
#########################

##################
#Set up the system
##################

setwd("C:/Users/Owner/Desktop/COURSERAwd/get_and_clean_project_ver3_revised/get-and-clean")
getwd()
library(tidyr)
library(dplyr)

#####################################################################
# Download the Smartphone Data and create a location for unziped file
#####################################################################

url1 <- paste0("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
har_data_zip = "har_data_set.zip"
download.file(url1, har_data_zip)

###################
#Unzip the files
##################


unzip(har_data_zip)


###############################################
#Read the data into Activity and Feature Labels.
###############################################
uci_har_dataset = "./UCI HAR Dataset/"


activity_labels  <- read.table(paste0(uci_har_dataset,"activity_labels.txt"),
                               col.names=c("activity_id","activity_nm"),
                               colClasses=c("integer","character"))
feature_labels <- read.table(paste0(uci_har_dataset,"features.txt"),
                             col.names=c("feature_id","feature_nm"),
                             colClasses=c("integer","character"))
for(set in c("test", "train")){for(dim in c("X","y","subject")){har_data_zip <- paste0(uci_har_dataset,set,"/",dim,"_",set,".txt")
df <- paste0(dim,"_",set)
cat("Reading ",har_data_zip,"...\n")
assign(df, read.table(har_data_zip))}}

#########################################################
# STEP 1 - Merge the training and test sets to create one data set.
#########################################################   


merged_train_and_test <- rbind(X_train, X_test)
merged_train_and_test$activity_id <- unlist(rbind(y_train, y_test))
merged_train_and_test$subject_id <-  unlist(rbind(subject_train, subject_test))

#####################################################################
#Assign activity names  (STEP 3)
#####################################################################

merged_train_and_test$activity_nm <- factor(activity_labels$activity_nm[merged_train_and_test$activity_id], 
                                            levels = activity_labels$activity_nm)
merged_train_and_test$activity_id <- NULL

#####################################################################
#Assign variable names (STEP 4)
#############################################################

feature_names <- gsub("\\(|\\)", "", feature_labels$feature_nm)
feature_names<- gsub("([[:punct:]]|\\s)+", "_", feature_names)
names(merged_train_and_test)[grepl("^V\\d+$",names(merged_train_and_test))] <- feature_names

#######################################################
#Get the Mean and Std. Deviation (STEP 2)
###################################################

merged_train_and_test <- merged_train_and_test[,grepl("^activity_nm$|^subject_id$|^.+_(mean|std)$", names(merged_train_and_test),
                                                      ignore.case=TRUE)]



#######################################################
#Gather Tidy Data  (STEP 4 continued)
#####################################################


merged_train_and_test$obs_id <- 1:nrow(merged_train_and_test)

merged_train_and_test %>%  gather(key=metric, value=amount, -activity_nm,-subject_id, -obs_id) %>% 
  separate(col=metric, into=c("feature_nm","stat")) %>%
  mutate(stat = paste0(stat,"_amt"), feature_nm = as.factor(feature_nm)) %>%
  arrange(activity_nm, subject_id, feature_nm, stat, obs_id) %>%
  spread(stat, amount) -> tidy_table

#############################################################
#Create the averages for the tidy data (STEP 5)
##########################################################

tidy_table %>% group_by(feature_nm, activity_nm, subject_id)%>%
summarise(avg__of__means=mean(mean_amt),avg__of__std_dev = mean(std_amt))-> tidy_table_summary
write.table(tidy_table_summary, file="part5_tidy_data.txt",row.names=FALSE)




#Part 5 output summary
head(tidy_table_summary)

#part 1 output summary
head(merged_train_and_test, 5)
tail(merged_train_and_test, 5)



