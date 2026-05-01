-- Revenue pattern by month
SELECT 
    strftime('%Y-%m', payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payments
WHERE status = 'success'
GROUP BY month
ORDER BY month;

-- February pattern
SELECT 
    strftime('%Y-%m', payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payments
WHERE status = 'success'
AND strftime('%m', payment_date) = '02'
GROUP BY month
ORDER BY month;