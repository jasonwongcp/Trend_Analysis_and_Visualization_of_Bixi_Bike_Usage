## Question 1.1 - The total number of trips for the year of 2016
SELECT count(*) FROM trips
where year(start_date) =2016 and year(end_date)=2016; 

## Question 1.2 - The total number of trips for the year of 2017
SELECT count(*) FROM trips
where year(start_date) =2017 and year(end_date)=2017;

## Question 1.3 - The total number of trips for the year of 2016 broken down by month.
SELECT month(start_date), count(*) as ' Total number of trips by month in 2016' FROM trips
where year(start_date) =2016 and year(end_date)=2016
group by month (start_date);

## Question 1.4 - The total number of trips for the year of 2017 broken down by month.
SELECT month(start_date), count(*) as ' Total number of trips by month in 2017' FROM trips
where year(start_date) =2017 and year(end_date)=2017
group by month (start_date);

## Question 1.5 - The average number of trips a day for each year-month combination in the dataset.
SELECT year (start_date) as 'Year', month(start_date) as 'Month',  count(id)/30 as ' Average number of trips per day' FROM trips
group by year (start_date), month (start_date);

## Question 1.6 - Create table 
Drop table if exists working_table1;
CREATE TABLE working_table1 SELECT year (start_date) as 'Year', month(start_date) as 'Month',  count(id)/30 as ' Average number of trips per day' FROM trips
group by year (start_date), month (start_date);

## Question 2.1 - The total number of trips in the year 2017 broken down by membership status (member/non-member).
SELECT if(is_member= 1, 'Member', 'Non-member') as 'Membership' , count(*) as 'Number of trips in 2017' FROM trips
where year(start_date) = 2017
group by is_member;

## Question 2.2 - The percentage of total trips by members for the year 2017 broken down by month.
SELECT month (start_date) as 'Month',  COUNT(CASE WHEN is_member=1 THEN 1 END)/count(*)*100 as '% of trips by members in 2017' FROM trips
where year(start_date) = 2017 
group by month (start_date)
order by month (start_date);

## Question 4.1 - Names of the 5 most popular starting stations? Determine the answer without using a subquery.
SELECT stations.name, count(trips.id) as 'Number of starting trips'
FROM stations
join trips on trips.start_station_code = stations.code
group by stations.name
order by count(trips.id) desc
limit 5;

## Question 4.2 - Names of the 5 most popular starting stations? using subquery.
SELECT stations.name, count(trips.id) as 'Number of starting trips'
FROM stations
join trips on trips.start_station_code = stations.code
group by stations.name
order by count(trips.id) desc
limit 5;

## Question 5.1a - Number of starts  distributed for the station Mackay / de Maisonneuve throughout the day
SELECT CASE
       WHEN HOUR(trips.start_date) BETWEEN 7 AND 11 THEN "morning"
       WHEN HOUR(trips.start_date) BETWEEN 12 AND 16 THEN "afternoon"
       WHEN HOUR(trips.start_date) BETWEEN 17 AND 21 THEN "evening"
       ELSE "night"
END AS "time_of_day", 
count(trips.id) as' Number of starting trips'
from trips
join stations on trips.start_station_code = stations.code
where stations.name= 'Mackay / de Maisonneuve'
group by time_of_day
order by count(trips.id) desc;

## Question 5.1b - Number of ends distributed for the station Mackay / de Maisonneuve throughout the day
SELECT CASE
       WHEN HOUR(trips.end_date) BETWEEN 7 AND 11 THEN "morning"
       WHEN HOUR(trips.end_date) BETWEEN 12 AND 16 THEN "afternoon"
       WHEN HOUR(trips.end_date) BETWEEN 17 AND 21 THEN "evening"
       ELSE "night"
END AS "time_of_day", 
count(trips.id) as' Number of ending trips'
from trips
join stations on trips.end_station_code = stations.code
where stations.name= 'Mackay / de Maisonneuve'
group by time_of_day
order by count(trips.id) desc;

## Question 6.1 - Counts the number of starting trips per station.
SELECT stations.name, count(trips.id) as 'Number of starting trips'
FROM stations
join trips on trips.start_station_code = stations.code
group by stations.name
order by stations.name;

## Question 6.2 - Second, write a query that counts, for each station, the number of round trips.
SELECT stations.name, count(trips.id) as 'Number of round trips'
FROM stations
join trips on trips.start_station_code = stations.code
where trips.start_station_code = trips.end_station_code
group by stations.name
order by stations.name;

##Question 6.3 - Combine the above queries and calculate the fraction of round trips to the total number of starting trips for each station.
SELECT stations.name, COUNT(CASE WHEN trips.start_station_code = trips.end_station_code THEN 1 END)/count(*) as 'Fraction of round trips to total no. of starting trips for each station'
FROM stations
join trips on trips.start_station_code = stations.code
group by stations.name
order by stations.name;

##Question 6.4 - Filter down to stations with at least 500 trips originating from them and having at least 10% of their trips as round trips.
SELECT stations.name, COUNT(CASE WHEN trips.start_station_code = trips.end_station_code THEN 1 END)/count(*) as 'Stations with at least 500 trips and at least 10% round trips'
FROM stations
join trips on trips.start_station_code = stations.code
group by stations.name
having COUNT(CASE WHEN trips.start_station_code = trips.end_station_code THEN 1 END)/count(*) >=0.1 and count(trips.start_station_code) >= 500
order by stations.name;
