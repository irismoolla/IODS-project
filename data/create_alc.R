url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets"

# web address for math class data
url_math <- paste(url, "student-mat.csv", sep = "/")

# print out the address
url_math

# read the math class questionaire data into memory
math <- read.table(url_math, sep = ";" , header=TRUE)

# web address for portuguese class data
url_por <- paste(url, "student-por.csv", sep ="/")

# print out the address
url_por

# read the portuguese class questionaire data into memory
por <- read.table(url_por, sep = ";", header = TRUE)

# look at the column names of both data
colnames(math)
colnames(por)

# access the dplyr library
library(dplyr)

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math",".por"))

# see the new column names
colnames(math_por)

# glimpse at the data

glimpse(math_por)

# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns


# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

# access the 'tidyverse' packages dplyr and ggplot2
library(dplyr); library(ggplot2)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# initialize a plot of alcohol use
g1 <- ggplot(data = alc, aes(x = alc_use, fill = sex))

# define the plot as a bar plot and draw it
g1 + geom_bar()

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# initialize a plot of 'high_use'
g2 <- ggplot(alc, aes(high_use))

# draw a bar plot of high_use by sex
g2 + facet_wrap("sex") + geom_bar()

# access the tidyverse libraries tidyr, dplyr, ggplot2
library(tidyr); library(dplyr); library(ggplot2)

# glimpse at the alc data
glimpse(alc)

# use gather() to gather columns into key-value pairs and then glimpse() at the resulting data
gather(alc) %>% glimpse

# draw a bar plot of each variable
gather(alc) %>% ggplot(aes(value)) + facet_wrap("key", scales = "free") +geom_bar()

# access the tidyverse libraries dplyr and ggplot2
library(dplyr); library(ggplot2)

# produce summary statistics by group
alc %>% group_by(sex, high_use) %>% summarise(count = n(), mean_grade = mean(G3))

library(ggplot2)

# initialize a plot of high_use and G3
g1 <- ggplot(alc, aes(x = high_use, y = G3, col = sex)) 

# define the plot as a boxplot and draw it
g1 + geom_boxplot() + ylab("grade")

# initialise a plot of high_use and absences
g1 <- ggplot(alc, aes(x = high_use, y = absences, col = sex)) 

# define the plot as a boxplot and draw it

g1 + geom_boxplot() + ylab("grade") + ggtitle("Student absences by alcohol consumption and sex")

# find the model with glm()
m <- glm(high_use ~ failures + absences + sex, data = alc, family = "binomial")

# print out a summary of the model
summary(m)

# print out the coefficients of the model
coef(m)

# find the model with glm()
m <- glm(high_use ~ failures + absences + sex, data = alc, family = "binomial")

# compute odds ratios (OR)#Create the object OR: Use coef() on the model object to extract the coefficients of the model and 
#then apply the exp function on the coefficients.'
OR <- coef(m) %>% exp

# compute confidence intervals (CI)
#Use confint() on the model object to compute confidence intervals for the coefficients. 
#Exponentiate the values and assign the results to the object CI. (R does this quite fast, despite the "Waiting.." message)
CI <- confint(m) %>% exp

# print out the odds ratios with their confidence intervals
cbind(OR, CI)

#Combine and print out the odds ratios and their confidence intervals. Which predictor has the widest interval? 
#Does any of the intervals contain 1 and why would that matter?

# fit the model
m <- glm(high_use ~ failures + absences + sex, data = alc, family = "binomial")

# predict() the probability of high_use
probabilities <- predict(m, type = "response")

# add the predicted probabilities to 'alc'
alc <- mutate(alc, probability = probabilities)

# use the probabilities to make a prediction of high_use
alc <- mutate(alc, prediction = alc$probability > 0.5)

# see the last ten original classes, predicted probabilities, and class predictions
select(alc, failures, absences, sex, high_use, probability, prediction) %>% tail(10)

# tabulate the target variable versus the predictions
table(high_use = alc$high_use, prediction = alc$probability > 0.5)

library(dplyr); library(ggplot2)

# initialize a plot of 'high_use' versus 'probability' in 'alc'
g <- ggplot(alc, aes(x = probability, y = high_use, col = prediction))

# define the geom as points and draw the plot
g + geom_point()

# tabulate the target variable versus the predictions
table(high_use = alc$high_use, prediction = alc$prediction) %>% prop.table() %>% addmargins()

# define a loss function (mean prediction error)
loss_func <- function(class, prob) {
  n_wrong <- abs(class - prob) > 0.5
  mean(n_wrong)
}

# call loss_func to compute the average number of wrong predictions in the (training) data
#Execute the call to the loss function with prob = 0, meaning you define the probability of high_use as zero for each individual.
loss_func(class = alc$high_use, prob = 0)
loss_func(class = alc$high_use, prob = 1)
loss_func(class = alc$high_use, prob = alc$probability)

# define a loss function (average prediction error)
loss_func <- function(class, prob) {
  n_wrong <- abs(class - prob) > 0.5
  mean(n_wrong)
}

#Define the loss function loss_func and compute the mean prediction error for the training data: 
#The high_use column in alc is the target and the probability column has the predictions.

# compute the average number of wrong predictions in the (training) data
loss_func(class = alc$high_use, prob = alc$probability)

# K-fold cross-validation
library(boot)
cv <- cv.glm(data = alc, cost = loss_func, glmfit = m, K = nrow(alc))

#Perform leave-one-out cross-validation and print out the mean prediction error for the testing data. 
#(nrow(alc) gives the observation count in alc and using K = nrow(alc) defines the leave-one-out method. 
#The cv.glm function from the 'boot' library computes the error and stores it in delta. 

#Perform 10-fold cross validation. Print out the mean prediction error for the testing data. 
#Is the prediction error higher or lower on the testing data compared to the training data?

cv <- cv.glm(data = alc, cost = loss_func, glmfit = m, K = 10)

# average number of wrong predictions in the cross validation
cv$delta[1]