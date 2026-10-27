NYC Shootings and Murders
================

## Introduction

Do more shootings occur in certain boroughs of New York City than in
others? Is there a relationship between the frequency of shootings and a
victim’s sex or age? Do factors like geography or a victim’s demographic
information make it more likely for a shooting to be flagged as a
murder? I sought to explore and hopefully answer some these questions
using visualizations and logarithmic regression.

## Data

The data used for this project comes from New York City’s archived
historical shooting data.
<https://data.cityofnewyork.us/Public-Safety/ARCHIVED_NYPD-Shooting-Incident-Data-Historic-/833y-fsy8/about_data>.
The dataset covers shootings from 2006 to 2024 and includes information
about the the location, time, and date of shootings as well as
demographic information about the victims and perpetrators. Certain
shootings are flagged as murders.

## Visualizations

<img src="nyc-shooting-data_files/figure-gfm/borough graph-1.png" style="display: block; margin: auto;" />

<div style="margin-left: auto; margin-right: auto; width: fit-content;">

| Borough           | Population (as of 2020 U.S. Census) |
|-------------------|-------------------------------------|
| **Bronx**         | 1,472,654                           |
| **Brooklyn**      | 2,736,074                           |
| **Manhattan**     | 1,694,251                           |
| **Queens**        | 2,405,464                           |
| **Staten Island** | 495,747                             |

<small>Source: nyc.gov</small>

</div>

The graph above shows the count data for the number of shootings that
occurred in the five boroughs of New York City as well the proportion of
the shootings that were classified as murders. For proper context, this
information should be considered alongside demographic data from the
boroughs such as their populations. For example, Staten Island may have
had the least number of shootings during the included period, but the
borough also has the smallest population in the NYC area. Nevertheless,
it appears that some boroughs have different numbers of shootings than
their population numbers alone would predict. Shootings were more
frequent in the Bronx than in Manhattan, for example. There could be
many reasons for this, including socioeconomic factors that may drive
crime rates up. Historically, certain populations and areas have also
been subjected to over-policing, which may artificially drive up crime
statistics as well.

<img src="nyc-shooting-data_files/figure-gfm/sex graph-1.png" style="display: block; margin: auto;" />

<img src="nyc-shooting-data_files/figure-gfm/age graph-1.png" style="display: block; margin: auto;" />

There seemed to be a strong relationship between the the number of
shootings and a victims’ age and sex. In particular, men were more
frequently victims of shootings than women were, and individuals 18-44
years of age were more frequently victims of shootings than were
individuals in other age categories.

## Modeling

Based on my initial visualizations, it seemed like the frequency of
shootings correlated with both different geographic locations and victim
demographics. From there, I became interested in seeing if any of those
factors were correlated with whether a particular shooting was flagged
in the system as a murder. To investigate this, I used binomial logistic
regression (since murders were categorized as a binary: true/false).

I started by fitting a model with the shooting’s location, the victim’s
age, and the victim’s sex as predictive variables. However, none of the
predictors were statistically significant at the alpha = 0.05 level
except those pertaining to the victim’s age. Therefore, I also opted to
fit a smaller model, using only the victim’s age as a predictor. I
compared the two models by using a likelihood ratio test as well as by
comparing their AIC values. I also evaluated the smaller model with the
residual deviance goodness-of-fit test. All of those statistical
measures suggested that the model based on age alone fit sufficiently
well, and I used it for the analysis that follows.

## Conclusions

First, a word about how murders are classified in this data set:
according to the city of New York’s website, the statistical murder flag
signifies a “shooting \[resulting\] in the victim’s death which would be
counted as a murder.” This, to me, implies that the murder flag is not
being used in cases of accidental death or suicide. It is less clear,
however, if the murder flag applies to killings that result in
manslaughter and lesser charges or if they, too, are excluded.

Notwithstanding any ambiguity in interpreting the meaning of the
statistical murder flag, the logistical regression model revealed an
interesting trend: despite the fact that the majority of shooting
victims are young adults, the odds of a shooting getting flagged as a
murder increase with a victim’s age. The trend was particularly stark
among middle-aged and elderly shooting victims, who were more than twice
as likely to be murdered than were victims under 18 years old.

<div style="margin-left: auto; margin-right: auto; width: fit-content;">

| Odds of Being a Murder Victim (relative to \< 18-year-olds) |          |
|-------------------------------------------------------------|----------|
| **Age**                                                     | **Odds** |
| 18-24                                                       | 1.30     |
| 25-44                                                       | 1.84     |
| 45-64                                                       | 2.22     |
| 65+                                                         | 2.88     |

</div>

This relationship may make a certain amount of sense, as comorbidities
that may affect the lethality of a shooting likely increase as an
individual ages. Nevertheless, there may also be other factors at play.
For instance, Staten Island has one of the oldest populations of the
boroughs as well as the highest percentage of shootings that were
flagged as murders. This correlation may be due to the age of Staten
Island’s population, but it’s possible that causation may run in the
opposite direction (or that there may be another, unknown factor that is
driving the relationship instead). Given the scope of this project, it’s
impossible to say for sure, but it might be an interesting avenue for
future study.

<div style="margin-left: auto; margin-right: auto; width: fit-content;">

| Median Age vs. Murder Rate |  |  |
|----|----|----|
| **Borough** | **Median Age** | **Percent of Shootings Flagged as Murders** |
| Bronx | 36.00 | 19.56% |
| Brooklyn | 36.50 | 19.49% |
| Manhattan | 38.90 | 18.08% |
| Queens | 40.70 | 19.68% |
| Staten Island | 40.60 | 20.68% |

<small>Source: datacommons.org</small>

</div>

## Caveats and Potential Sources of Bias

There were many unknown values for victims’ age, race, and sex in the
dataset. This likely indicates that police officers responding to
shootings were not able to talk to all of the victims directly and that
certain details may have come from witnesses or the police officers
themselves. One would hope that, if an officer wasn’t sure about a
victim’s demographic details, they would have been entered as “unknown,”
but there remains the possibility that some inference was used and that
some of the demographic details of victims may not have been accurate.

Additionally, certain reporting categories may have made data collection
difficult. For example, the sex of victims and perpetrators are recorded
as binary measures (male/female) in the dataset. However, the Gender
Recognition Act that was signed into New York state law in 2021 allows
individuals to select nonbinary gender markers on their official
government forms. Therefore, the dataset may be obscuring the presence
of nonbinary victims and/or perpetrators.

Finally, certain small sample sizes made analysis difficult as well. For
example, the number shootings whose victims were white/non-Hispanic,
Asian/Pacific Islander, and American Indian/Alaska Native were quite
small. There also weren’t many shootings in Staten Island or of victims
who were older than 65 years old. This may have led to undercoverage
bias and creates some doubt about what sort of conclusions can be drawn
regarding these populations.
