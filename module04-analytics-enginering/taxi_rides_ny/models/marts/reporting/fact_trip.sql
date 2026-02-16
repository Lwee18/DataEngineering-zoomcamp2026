
with trips_union as (
    select * from {{ ref('int_trips_union') }}
)   

select * from trips_union