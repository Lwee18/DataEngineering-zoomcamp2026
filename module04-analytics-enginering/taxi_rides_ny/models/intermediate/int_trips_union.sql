-- with  green_trips as (
--     select
--         *
--     from {{ ref('stg_greendata') }}
-- ),

-- yellow_trips as (
--     select
--         *
--     from {{ ref('stg_yellowdata') }}
-- ),

-- trips_union as (
--     select * from green_trips
--     union all
--     select * from yellow_trips
-- )

-- select * from trips_union

-- {{ config(materialized='view') }}

with green_data as(
    select 
        trip_id,
        taxi_type,
        vendor_id,
        rate_code_id,
        pickup_location_id,
        dropoff_location_id,
        pickup_datetime,
        dropoff_datetime,
        store_and_fwd_flag,
        passenger_count,
        trip_distance,
        trip_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee, 
        improvement_surcharge,
        total_amount,
        {{ get_payment_type('payment_type') }} as payment_type
    from {{ ref('stg_greendata') }}
),
yellow_data as(
    select 
        trip_id,
        taxi_type,
        vendor_id,
        rate_code_id,
        pickup_location_id,
        dropoff_location_id,
        pickup_datetime,
        dropoff_datetime,
        store_and_fwd_flag,
        passenger_count,
        trip_distance,
        trip_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee, 
        improvement_surcharge,
        total_amount,
        {{ get_payment_type('payment_type') }} as payment_type
        
    from {{ ref('stg_yellowdata') }}
),
trip_unioned as (
    select * from green_data
    union all
    select * from yellow_data
)

select * from trip_unioned
