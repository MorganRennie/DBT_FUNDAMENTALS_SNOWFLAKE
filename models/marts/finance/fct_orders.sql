with payment as(
    select
        *
    from {{ ref('stg_stripe__payments') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders')}}
),

payment_orders as (
    select
        order_id,
        sum(amount) as amount
    from payment
    where status='success'
    group by order_id
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(payment_orders.amount,0) as amount
    
    from orders
    left join payment_orders using (order_id)

)

select * from final