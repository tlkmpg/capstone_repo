select *
from {{ ref('fct_orders') }}
where total_price < 0
   or total_net_price < 0
   or total_gross_price < 0