# Module 2 Homework – NYC Taxi Data (Kestra)

This repository contains my solutions for **Module 2 Homework** of the Data Engineering Zoomcamp.

## Dataset

Source:  
https://github.com/DataTalksClub/nyc-tlc-data


## Homework Questions & Answers

### Question 3  
**How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?**

**SQL Query:**
```sql
SELECT
  COUNT(*)
FROM yellow_tripdata
WHERE filename LIKE 'yellow_tripdata_2020%';
```

### Question 4
**How many rows are there for the Green Taxi data for all CSV files in the year 2020?**

**SQL QUERY**
```sql
select 
 count(*)
from green_tripdata
where filename like 'green_tripdata_2020%';
```

### Question 5
**How many rows are there for the Yellow Taxi data for the March 2021 CSV file?**

**SQL QUERY**
```sql
select 
 count(*)
from yellow_tripdata
where filename = 'yellow_tripdata_2021-03.csv';
```
