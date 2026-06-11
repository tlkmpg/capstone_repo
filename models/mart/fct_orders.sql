{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with orders as (

    select * 
    from {{ ref('int_orders_enriched') }}

),

lineitems as (

    select * 
    from {{ ref('stg_tpch__lineitems') }}

),

aggregated_lineitems as (

    select
        order_id,

        sum(quantity)        as total_quantity,
        sum(extended_price)  as total_extended_price,
        sum(net_price)       as total_net_price,
        sum(gross_price)     as total_gross_price,
        avg(discount)        as avg_discount,
        avg(tax)             as avg_tax

    from lineitems
    group by order_id

),

final as (

    select
        -- Surrogate key
        {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} as order_sk,

        -- Grain key
        o.order_id,

        -- Dimensions
        o.customer_id,
        o.customer_name,
        o.nation_name,
        o.order_status,
        o.order_priority,
        o.order_date,
        o.order_year,
        o.order_month,
        o.order_quarter,

        -- Business metrics
        o.total_price,
        li.total_quantity,
        li.total_extended_price,
        li.total_net_price,
        li.total_gross_price,
        li.avg_discount,
        li.avg_tax

    from orders o
    left join aggregated_lineitems li
        on o.order_id = li.order_id

)

select * from final

{% if is_incremental() %}
where order_date >= (select max(order_date) from {{ this }})
{% endif %}
