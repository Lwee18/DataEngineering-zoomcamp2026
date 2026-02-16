with fhvdata as (
    select
         dispatching_base_num,
         pickup_datetime,
         dropOff_datetime as dropoff_datetime,
         PULocationID as pickup_location_id,
         DOLocationID as dropoff_location_id,
         SR_Flag as sr_flag,
         Affiliated_base_number as affiliated_base_number
    from {{ source('raw_data', 'fhv_tripdata') }}
    where dispatching_base_num is not null
)
select * from fhvdata