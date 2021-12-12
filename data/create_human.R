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
colnames(hd)[8] <- "gni.hdi"

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

#data wrangling for exercise 5 IODS-course 
#4.12.2021

#reading the saved data             
human <- read.table("C:/Users/irisp/Documents/Git/IODS-project/data/human.csv")

#checking the human data
str(human)
head(human)

# The joined human data has 195 observations and 19 variables and originates from the United Nations Development Programme. 
# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi
# The data combines several indicators from most countries in the world and includes the following variables:

#Development of a country

# country = Country name
# hdi = Human Development Index (HDI)
# hdirank = HDI ranking for countries
# gni  = Gross National Income (GNI) per capita
# gni.hdi = GNI per capita rank minus HDI rank

# Health and knowledge

# lifex = Life expectancy at birth
# expedu = Expected years of schooling 
# medu = Mean years of schooling
# matmor = Maternal mortality ratio
# adlbr = Adolescent birth rate

# Empowerment

# gii = Gender Inequality Index (GII)
# giirank = GII ranking for countries
# reppar = Percetange of female representatives in parliament
# edu2F = Proportion of females with at least secondary education
# edu2M = Proportion of males with at least secondary education
# labF = Proportion of females in the labour force
# labM = Proportion of males in the labour force
# ratio_2edu = the ratio of Female and Male populations with secondary education in each country (edu2F / edu2M)
# ratio_lab = the ratio of labour force participation of females and males in each country (labF / labM)

# Mutate the data: transform the Gross National Income (GNI) variable to numeric

# download and access the stringr package
# install.packages("stringr")
library(stringr)

# look at the structure of the GNI column in 'human'

str(human$gni)

# remove the commas from gni variable and print out a numeric version of it
# access the dplyr library
library(dplyr)

human$gni <- str_replace(human$gni, pattern = ",", replace = "") %>%
  as.numeric()

human$gni

#Exclude unneeded variables

# columns to keep
keep <- c("country", "ratio_2edu", "ratio_lab", "lifex", "expedu", "gni", "matmor", "adlbr", "reppar")

# select the 'keep' columns
human <- select(human, one_of(keep))

#Remove all rows with missing values

# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human <- filter(human, complete.cases(human))

#Remove the observations which relate to regions instead of countries

# first checking the last ten observations
tail(human, 10) # last 7 are not countries but regions
# defining last index we want to keep
last <- nrow(human) - 7 
# choose everything until the last 7 observations 
human <- human[c(1:last), ]

#Define the row names of the data by the country names and remove the country name column from the data. 

# add countries as rownames
rownames(human) <- human$country

# remove the Country variable
human <- select(human, -country)

str(human)
#The data has now 155 observations and 8 variables. 

#Save the modified human data in your data folder (overriding the previous human data)
write.table(human, file = "C:/Users/irisp/Documents/Git/IODS-project/data/human.csv")
