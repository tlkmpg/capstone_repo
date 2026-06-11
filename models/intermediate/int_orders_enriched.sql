with orders as (

    select * 
    from {{ ref('stg_tpch__orders') }}

),

customers as (

    select * 
    from {{ ref('stg_tpch__customers') }}

),

nations as (

    select * 
    from {{ ref('stg_tpch__nations') }}

),

joined as (

    select
        -- Order fields
        o.order_id,
        o.customer_id,
        o.order_status,
        o.total_price,
        o.order_date,
        o.order_priority,
        o.clerk,
        o.ship_priority,
        o.comment as order_comment,

        -- Derived date fields
        extract(year from o.order_date)    as order_year,
        extract(month from o.order_date)   as order_month,
        extract(quarter from o.order_date) as order_quarter,

        -- Customer fields
        c.customer_name,
        c.address,
        c.phone,
        c.account_balance,
        c.market_segment,
        c.comment as customer_comment,

        -- Nation fields
        n.nation_id,
        n.nation_name,
        n.region_id,
        n.comment as nation_comment

    from orders o
    left join customers c 
        on o.customer_id = c.customer_id
    left join nations n 
        on c.nation_id = n.nation_id

)

select * from joined