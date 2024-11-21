select
    orderid as order_id,
    id as customer_id,
    amount / 100 as amount,
    status,
    created as created_at
from 
{{ source('stripe', 'payment') }}