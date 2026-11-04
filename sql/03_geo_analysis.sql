-- 3. ГЕОГРАФИЧЕСКИЙ АНАЛИЗ (выручка и рейтинг)

-- 3.1. Выручка и рейтинг по штатам

SELECT 
    fo.customer_state, 
    COUNT(DISTINCT fo.order_id) AS total_orders,
    ROUND(SUM(fo.product_price)::numeric, 2) AS total_product_revenue,
    ROUND(SUM(fo.freight_value)::numeric, 2) AS total_freight_revenue,
    ROUND(SUM(fo.product_price + fo.freight_value)::numeric, 2) AS total_revenue,
    ROUND(AVG(fr.review_score), 2) AS average_score
FROM fact_orders fo 
LEFT JOIN fact_reviews fr ON fo.order_id = fr.order_id 
GROUP BY fo.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 3.2. Проблемный штат для мебели (Инсайт: В штате PA рейтинг мебели падает до 2.88)

SELECT 
    fo.category,
    fo.customer_state,
    ROUND(AVG(review_score), 2) AS average_score,
    COUNT(*) AS cnt_orders
FROM fact_orders fo
INNER JOIN fact_reviews fr ON fo.order_id = fr.order_id
WHERE fo.delivery_delay_days <= 0 AND category = 'office_furniture'
GROUP BY category, customer_state
HAVING COUNT(*) >= 20
ORDER BY average_score ASC
LIMIT 10;