# Module 1 Homework: Docker & SQL

## Question 3. Counting short trips

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a trip_distance of less than or equal to 1 mile?

```sql
select 
 count(*)
from public.green_tripdata_2025_11 
where cast(lpep_pickup_datetime as date) >= '2025-11-01' 
and  cast(lpep_pickup_datetime as date) <  '2025-12-01'
and trip_distance <= 1;
```

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles (to exclude data errors).

```sql
select
	cast(lpep_pickup_datetime as date) as "lpep_pickup_date",
	trip_distance
from public.green_tripdata_2025_11
where trip_distance < 100
order by trip_distance desc
limit 1;
```

## Question 5. Biggest pickup zone

Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

```sql
select
 z."Zone",
 sum(g.total_amount) as total_amount
from public.green_tripdata_2025_11 g
left join public.zones z
on g."PULocationID" = z."LocationID"
where cast(g.lpep_pickup_datetime as date) = '2025-11-18'
group by z."Zone"
order by total_amount desc
limit 1;
```

## Question 6. Largest tip

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

```sql
select
	zdo."Zone",
	g.tip_amount
from public.green_tripdata_2025_11 g
join public.zones zpu
on g."PULocationID" = zpu."LocationID"
join public.zones zdo
on g."DOLocationID" = zdo."LocationID"
where zpu."Zone"='East Harlem North'
and cast(lpep_pickup_datetime as date) >= '2025-11-01' 
and  cast(lpep_pickup_datetime as date) <  '2025-12-01'
order by g.tip_amount desc 
limit 1;
```