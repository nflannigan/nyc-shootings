options(scipen=999)
library(tidyverse)
data <- read_csv("https://data.cityofnewyork.us/api/views/833y-fsy8/rows.csv?accessType=DOWNLOAD")

# Exploratory data analysis
head(data)
summary(data)

# Data cleaning
# Deleting columns with many NA values, filtering NAs from columns of interest
# Re-coding jurisdiction code to make categories more legible
data <- data %>%
  select(-LOC_OF_OCCUR_DESC, -LOC_CLASSFCTN_DESC, -LOCATION_DESC, -PERP_AGE_GROUP,
         -PERP_SEX, -PERP_RACE, -X_COORD_CD, -Y_COORD_CD, -Lon_Lat) %>%
  filter(data$VIC_AGE_GROUP != "UNKNOWN" & data$VIC_AGE_GROUP != "1022" & 
           data$VIC_SEX != "U" & data$VIC_RACE != "UNKNOWN") %>%
  mutate(OCCUR_DATE = mdy(OCCUR_DATE), 
         JURISDICTION_CODE = recode(JURISDICTION_CODE, 
                                    "0" = "Patrol", "1" = "Transit", "2" = "Housing"),
         across(c(BORO, VIC_AGE_GROUP, VIC_SEX, VIC_RACE, JURISDICTION_CODE), as.factor)) 


# Graph of shootings by borough
ggplot(data, aes(x=BORO, fill=STATISTICAL_MURDER_FLAG)) +
  geom_bar() +
  theme_bw() +
  labs(x="", y="Count", fill="Murdered", title="Shootings by Borough")

# Graph of shootings by victim sex
ggplot(data, aes(x=VIC_SEX, fill=STATISTICAL_MURDER_FLAG)) +
  geom_bar() +
  theme_bw() +
  labs(x="", y="Count", fill="Murdered", title="Shootings by Victim Sex")

# Graph of shootings by victim age
ggplot(data, aes(x=VIC_AGE_GROUP, fill=STATISTICAL_MURDER_FLAG)) +
  geom_bar() +
  theme_bw() +
  labs(x="", y="Count", fill="Murdered", title="Shootings by Victim Age")


# Logistic regression model with location, age, and sex as predictors
model <- glm(STATISTICAL_MURDER_FLAG ~ BORO + VIC_AGE_GROUP + VIC_SEX,
             data = model_data, family = "binomial")
summary(model)

# Logistic regression model with only age as a predictor
model_age <- glm(STATISTICAL_MURDER_FLAG ~ VIC_AGE_GROUP,
             data = model_data, family = "binomial")
summary(model_age)

# Statistical tests
# The AIC value of the smaller model is 28895 vs. 28897 for the larger model
# Likelihood ratio test
# High p-value (0.1883) suggests smaller model is sufficient
anova(model, model_age, test = "Chisq")
# Residual deviance goodness of fit test
# High p-value (0.9987472) suggest smaller model fits well enough
pchisq(deviance(model_age), df.residual(model_age), lower.tail = FALSE)

# Calculates odds ratios from smaller model
exp(coef(model_age))

# Function for calculating the percentage of shootings flagged as murders
murder_percentage <- function(borough) {
  total <- data %>% 
    filter(BORO == borough) %>% 
    nrow()
  murders <- data %>% 
    filter(BORO == borough & STATISTICAL_MURDER_FLAG == TRUE) %>% 
    nrow()
  return(murders/total)
}

boroughs <- c("BRONX", "BROOKLYN", "MANHATTAN", "QUEENS", "STATEN ISLAND")
sapply(boroughs, murder_percentage)
