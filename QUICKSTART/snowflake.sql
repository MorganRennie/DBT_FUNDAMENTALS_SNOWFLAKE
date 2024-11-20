-- MR Code for Initializing the DBT course, creation of database tables and insertion of data into snowflake.
------------------
-- create warehouse, databases, and schemas for analysis
    create warehouse transforming;
    create database raw;
    -- for raw data
    create database analytics;
    -- for future dbt development
    create schema raw.jaffle_shop;
    create schema raw.stripe;

------------------
-- create the jaffleshop tables (customers and orders)
    create table raw.jaffle_shop.customers
    (   id integer,
        first_name varchar,
        last_name varchar
    );

    create table raw.jaffle_shop.orders
    (   id integer, 
        user_id integer,
        order_date date,
        status varchar,
        _etl_loaded_at timestamp default current_timestamp
    );

------------------
--insert data into the jaffleshop tables from the dbt s3 bucket.
    copy into raw.jaffle_shop.customers (id, first_name, last_name)
    from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
    file_format = (
        type = 'CSV'
        field_delimiter = ','
        skip_header = 1
    );

    copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
    from 's3://dbt-tutorial-public/jaffle_shop_orders.csv' 
    file_format = (
        type = 'CSV'
        field_delimiter = ','
        skip_header = 1 

    );

------------------
    -- create the stripe payment table
    create table raw.stripe.payment
    (   id integer,
        orderid integer,
        paymentmethod varchar,
        status varchar,
        amount integer,
        created date,
        _batched_at timestamp default current_timestamp
        );

------------------
    -- insert data into the stripe payment table from the dbt s3 bucket. 
        copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
    from 's3://dbt-tutorial-public/stripe_payments.csv'
    file_format = (
        type = 'CSV'
        field_delimiter = ','
        skip_header = 1
    );

------------------
    -- test that all tables have the data in them
    select * from raw.jaffle_shop.customers;
    select * from raw.jaffle_shop.orders;
    select * from raw.stripe.payment;