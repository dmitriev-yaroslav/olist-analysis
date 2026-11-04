-- 1. СОЗДАНИЕ ПРЕДСТАВЛЕНИЙ

-- 1.1. Представление заказов

CREATE OR REPLACE VIEW fact_orders AS
SELECT 
    o.order_id,
    o.customer_id,
    c.customer_state,
    c.customer_city,
    o.order_status,
    o.order_purchase_timestamp::date AS purchase_date,
    o.order_delivered_customer_date::date AS delivered_date,
    o.order_estimated_delivery_date::date AS estimated_date,
    (o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date) AS delivery_delay_days,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price AS product_price,
    oi.freight_value,
    p.product_weight_g AS weight_g,
    p.product_length_cm AS length_cm,
    p.product_height_cm AS height_cm,
    p.product_width_cm AS width_cm,
    COALESCE(t.product_category_name_english, 'unknown') AS category
FROM olist_orders_dataset o
INNER JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
INNER JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
LEFT JOIN olist_products_dataset p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered';

-- 1.2. Представление отзывов

CREATE OR REPLACE VIEW fact_reviews AS
SELECT
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_creation_date::date AS review_date,
    COALESCE(LENGTH(r.review_comment_message), 0) AS comment_length
FROM olist_order_reviews_dataset r;