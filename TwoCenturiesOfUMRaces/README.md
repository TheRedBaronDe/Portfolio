# Two Centuries of Ultra Marathon Races
**Project Overview**

The goal was to improve readability, consistency, and query efficiency, enabling reliable exploratory and analytical work.

**Dataset**

Source: Kaggle (https://www.kaggle.com/datasets/aiaiaidavid/the-big-dataset-of-ultra-marathon-running/code)

Description: The data in this file is a large collection (7,461,195 rows) of ultra-marathon race records registered between 1798 and 2022 (a period of well over two centuries) being therefore a formidable long term sample. All data was obtained from public websites.

Format: CSV

Scope: Sports

**This analysis aim to answer**

Did marathon runners get faster throughout these two centuries?

Which countries have the fastest runners?

What are the performance differences based on gender?

How has the number of ultra-marathon races evolved over time?

**Tools**

Cleaning: pgAdmin 4, Python (Pandas) using Sublime Text

Visualization: Sublime Text, Tableau

Language: SQL, Python

Environment: Local database for data preparation and transformation

# Cleaning

The cleaning was rather difficult due to inconsistent characters inside the original CSV file, making it impossible to import into pgAdmin 4 at first. So I cleaned it using Pandas by skiping rows that could not be parsed and removing double and singular quotation marks inside strings/text.

```python

import pandas as pd # import pandas to manipulate data and clean it so it can be imported into pgAdmin 4

file_path = r"C:\\Users\\User\\Documents\\PostgreSQL\\TWO_CENTURIES_OF_UM_RACES.csv"

df = pd.read_csv(
    file_path,
    engine="python", # forces Pandas to read the CSV file as a Python based parser
    sep=",", # separates each column with a comma
    quotechar='"', # tells Pandas that double quotes means strings/text, meaning that any commas inside double quotes should be treated as text as well
    escapechar='\\', # defines how to deal with escaped characters
    on_bad_lines='skip', # extremely important, tells Pandas to skip any row that cannot be parsed
    encoding='utf-8' # defines an enconding that supports international characters and prevents breaking/corruption
)

for col in df.select_dtypes(include='object').columns: # selects TEXT columns
    df[col] = (
        df[col]
        .astype(str) # converts to string
        .str.replace('"', '', regex=False) # removes double quotes inside the strings
        .str.replace("'", '', regex=False) # removes singular quotes inside the strings
    )

df.to_csv(
    r"C:\\Users\\User\\Documents\\PostgreSQL\\TWO_CENTURIES_OF_UM_RACES_CLEAN.csv", # saves the cleaned dataset so it can be imported into pgAdmin 4
    index=False # prevents Pandas from writing extra columns
    encoding='utf-8' # applies an international character encoding
)

print(len(df)) # prints the number of loaded rows, allowing you to verify lost rows and compare its size to the expectedd value of the full dataset
```
# Analysis 

The entire dataset has 7,461,195 rows

260 rows are duplicated, making up for 0.00348469649% of the full dataset

athlete_club is missing 2.8 million entries

year_of_birth is missing 588k entries

age_category is missing 584k entries

This makes up for 53.23% of the entire dataset

# Charts

```python

df['athlete_year_of_birth'] = pd.to_numeric(df['athlete_year_of_birth'], errors='coerce') 
df['athlete_average_speed'] = pd.to_numeric(df['athlete_average_speed'], errors='coerce')
# these lines convert columns that contains numbers into exclusively numerical values
# "errors='coerce'" converts all invalid values into special missing values instead of returning an "error" message

sample_df = df.sample(300_000, random_state=42)
# this line creates a random sample that uses 300.000 rows from the entire dataset
# setting an integer in "random_state=" makes sure the results always remain consistent
# this line is extremely important as we're dealing with a very large dataset (over 7M rows) and using the entire
# dataset could lead to memory and performance issues, as well as crashes

plt.tight_layout()
# this line automatically adjusts parameters to avoid overlapping
```
