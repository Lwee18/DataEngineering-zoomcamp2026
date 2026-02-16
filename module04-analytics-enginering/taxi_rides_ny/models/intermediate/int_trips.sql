with cleaned_and_enriched as(
    select
        {{ dbt_utils.generate_surrogate_key(['pickup_datetime','dropoff_datetime','vendor_id','taxi_type']) }} as trip_id,
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
        coalesce(payment_type, 0) as payment_type,
        {{ get_payment_type('payment_type') }} as payment_type_description
    from {{ ref('int_trips_union') }}
)

select * from cleaned_and_enriched
qualify row_number() over(
    partition by pickup_datetime, dropoff_datetime, vendor_id, taxi_type
    order by dropoff_datetime
) = 1
