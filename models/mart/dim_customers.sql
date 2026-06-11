{{ config(
    materialized='table'
) }}

with orders as (

    select * 
    from {{ ref('fct_orders') }}

),

customers as (

    select * 
    from {{ ref('stg_tpch__customers') }}

),

customer_ltv as (

    select
        customer_id,
        sum(total_price) as lifetime_value

    from orders
    group by customer_id

),

final as (

    select
        c.customer_id,
        c.customer_name,
        c.address,
        c.phone,
        c.account_balance,
        c.market_segment,
        c.nation_id,

        coalesce(ltv.lifetime_value, 0) as lifetime_value,

        case
            when coalesce(ltv.lifetime_value, 0) >= 500000 then 'Gold'
            when coalesce(ltv.lifetime_value, 0) >= 100000 then 'Silver'
            else 'Bronze'
        end as customer_tier

    from customers c
    left join customer_ltv ltv
        on c.customer_id = ltv.customer_id

)

select * from final
