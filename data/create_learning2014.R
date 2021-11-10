#Iris Moolla
#10.11.2021
#data wrangling for exercise 2 IODS-course 
#data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt 

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#explore the structure and dimensions of the data. Write short code comments describing the output of these explorations.

str(learning2014)
dim(learning2014)

#Data frame, learning2014,  has 183 rows (observations) and 60 columns (variables). Most variables are integers and one is a character.


library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06", "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

# choose the columns to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
lrndata <- select(learning2014, one_of(keep_columns))

# see the structure of the new dataset
str(lrndata)

colnames(lrndata)

# changing names of the columns
colnames(lrndata)[2] <- "age"
colnames(lrndata)[3] <- "attitude"
colnames(lrndata)[7] <- "points"

# print out the new column names of the data
colnames(lrndata)

# select rows where points is greater than zero 
lrndata <- filter(lrndata, points > 0)

#new dataset contains 166 observations and 7 variables
str(lrndata)

#setting the working directory
setwd("~/Git/IODS-project/data")

#saving the new dataset
write.table(lrndata, file = "lrndata.csv")

#reading the saved data             
read.table("lrndata.csv")
str(lrndata)
head(lrndata)

