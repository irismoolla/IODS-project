#Iris Moolla
#18.11.2021
#data wrangling for exercise 3 IODS-course 
#data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#setting the working directory
setwd("~/Git/IODS-project")

#reading the datasets into R
math <- read.table("C:/Users/irisp/Documents/Git/IODS-project/data/student-mat.csv", sep = ";", header=TRUE)
por <- read.table("C:/Users/irisp/Documents/Git/IODS-project/data/student-por.csv", sep = ";", header=TRUE)
  
#exploring the structure and dimensions of the datasets math and por

str(math)
dim(math)

str(por)
dim(por)

# access the dplyr library
library(dplyr)

# Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns not used as student identifiers
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# print out the columns not used for joining
free_cols

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

join_cols

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
# There are 370 students that belong to both datasets

pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>% 
  #combining the 'duplicated' answers in the joined data
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m"))

#exploring the structure and dimensions of the new data pormath

str(pormath)
dim(pormath)

# glimpse at the new joined data
glimpse(pormath)

# define a new column alc_use by combining weekday and weekend alcohol use
pormath <- mutate(pormath, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
pormath <- mutate(pormath, high_use = alc_use > 2)

# glimpse at the modified data
glimpse(pormath)

#the joined data has 370 observations

#saving the new dataset
write.table(pormath, file = "C:/Users/irisp/Documents/Git/IODS-project/data/pormath.csv")

