#Iris Moolla
#12.12.2021
#data wrangling for exercise 6 IODS-course 
#data source: 
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

#setting the working directory
setwd("~/Git/IODS-project")

#reading the datasets into R
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# Look at the (column) names of BPRS
names(BPRS)
names(RATS)

# Look at the structure of BPRS
str(BPRS)
str(RATS)

# print out summaries of the variables
summary(BPRS)
summary(RATS)

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

#Convert the categorical variables of both data sets to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Convert the BPRS data to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

# Convert RATS data to long form and add Time variable 
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Take a glimpse at the BPRSL data
glimpse(BPRSL)
glimpse(RATSL)

# Look at the (column) names of the long form versions of the data sets
names(BPRSL)
names(RATSL)

# Look at the structure of the long form versions of the data sets
str(BPRSL)
str(RATSL)

# print out summaries of the variables of the long form versions of the data sets
summary(BPRSL)
summary(RATSL)

#Save the wrangled data sets in my data folder 
write.table(BPRSL, file = "C:/Users/irisp/Documents/Git/IODS-project/data/BPRSL.csv")
write.table(RATSL, file = "C:/Users/irisp/Documents/Git/IODS-project/data/RATSL.csv")

