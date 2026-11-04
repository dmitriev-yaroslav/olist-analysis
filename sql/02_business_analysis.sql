-- 2. АНАЛИЗ ОТЗЫВОВ И ДОСТАВКИ

-- 2.1. Общая статистика по оценкам

SELECT 
    review_score,
    COUNT(*) AS cnt_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percent_score
FROM fact_reviews
GROUP BY review_score
ORDER BY review_score ASC;

-- 2.2. Влияние опозданий на рейтинг

SELECT
    CASE
        WHEN delivery_delay_days <= 0 THEN 'Вовремя'
        WHEN delivery_delay_days = 1 THEN 'Опоздал на 1 день'
        WHEN delivery_delay_days = 2 THEN 'Опоздал на 2 дня'
        WHEN delivery_delay_days = 3 THEN 'Опоздал на 3 дня'
        ELSE 'Опоздал на 4+ дней'
    END AS delivery_status,
    ROUND(AVG(review_score), 2) AS average_rating,
    COUNT(*) AS cnt_orders
FROM fact_orders o
INNER JOIN fact_reviews r ON o.order_id = r.order_id
GROUP BY delivery_status
ORDER BY delivery_status;

-- 2.3. Худшие категории (без учета опозданий)

SELECT 
    fo.category, 
    ROUND(AVG(review_score), 2) AS average_score, 
    COUNT(*) AS cnt_reviews
FROM fact_orders fo 
INNER JOIN fact_reviews fr ON fo.order_id = fr.order_id 
WHERE fo.delivery_delay_days <= 0
GROUP BY fo.category
HAVING COUNT(*) >= 1000
ORDER BY average_score ASC
LIMIT 10;