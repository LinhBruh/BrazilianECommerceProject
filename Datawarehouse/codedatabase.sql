Create table fact_order_items(
    order_key int Primary key,
    product_key int,
    customer_key int,
    seller_key int,
    date_key int
    order_id varchar(100),
    price decimal(10,2),
    freight_value (10,2),
    payment_value D(10,2),
    review_score decimal(3,2),
)

Create table dim_product(
    product_key int Primary key,
    product_id varchar(100),
    categories varchar(50)
)

Create table dim_customer(
    customer_key int Primary key,
    customer_id varchar(100),
    city varchar(50),
    state varchar(10)
)

Create table dim_seller(
    seller_key int Primary key,
    seller_id varchar(50),
    city varchar(30)
)

Create table dim_date(
    date_key int Primary key,
    day int,
    month int,
    quarter int,
    year int,
    full_date date,
    month_name varchar(20),
    day_name varchar(20),
    week int,
    day_of_week int,
    is_weekend boolean
)