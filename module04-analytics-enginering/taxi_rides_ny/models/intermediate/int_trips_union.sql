with  green_trips as (
    select
        *
    from {{ ref('stg_greendata') }}
),

yellow_trips as (
    select
        *
    from {{ ref('stg_yellowdata') }}
),

trips_union as (
    select * from green_trips
    union all
    select * from yellow_trips
)

select * from trips_union