#Iris Moolla
#26.11.2021
#data wrangling for exercise 4 IODS-course 
#data source: http://hdr.undp.org/en/content/human-development-index-hdi

#setting the working directory
setwd("~/Git/IODS-project")

#reading the datasets into R
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# look at the structure and dimensions of hd dataset
str(hd)
dim(hd)
# print out summaries of the variables in the hd dataset
summary(hd)

# look at the structure and dimensions of gii dataset
str(gii)
dim(gii)
# print out summaries of the variables in the gii dataset
summary(gii)

#renaming the variables with (shorter) descriptive names
#column names of hd data
colnames(hd)

# changing names of the columns
colnames(hd)[1] <- "hdirank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "hdi"
colnames(hd)[4] <- "lifex"
colnames(hd)[5] <- "expedu"
colnames(hd)[6] <- "mnedu"
colnames(hd)[7] <- "gni"
colnames(hd)[8] <- "gni-hdi"

#checking new variable names for hd data
colnames(hd)

#column names of hd data
colnames(gii)

# changing names of the columns
colnames(gii)[1] <- "giirank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "gii"
colnames(gii)[4] <- "matmor"
colnames(gii)[5] <- "adlbr"
colnames(gii)[6] <- "reppar"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labF"
colnames(gii)[10] <- "labM"

#checking new variable names for gii data
colnames(gii)

# access the dplyr library
library(dplyr)
#create a new variable: the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M)

gii <- mutate(gii, ratio_2edu = (edu2F / edu2M))

#create a new variable: the ratio of labour force participation of females and males in each country (i.e. labF / labM)

gii <- mutate(gii, ratio_lab = (labF / labM))

glimpse(gii)

#Join together the two datasets using the variable Country as the identifier keeping only the countries in both data sets. 

human <- inner_join(hd, gii, by = "country")

#The new joined data is called "human" and the data has 195 observations and 19 variables

dim(human)

# saving the joined dataset
write.table(human, file = "C:/Users/irisp/Documents/Git/IODS-project/data/human.csv")
