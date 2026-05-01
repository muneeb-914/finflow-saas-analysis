-- Overall payment failure rate
SELECT 
    status,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments), 1) AS percentage
FROM payments
GROUP BY status;

-- Failure rate by payment method
SELECT 
    payment_method,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS failure_rate_pct
FROM payments
GROUP BY payment_method
ORDER BY failure_rate_pct DESC;


-- Failure rate by country
SELECT 
    c.country,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN p.status = 'failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN p.status = 'failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS failure_rate_pct
FROM payments p
JOIN customers c ON c.customer_id = p.customer_id
GROUP BY c.country
ORDER BY failure_rate_pct DESC;


-- Failure rate by plan
SELECT 
    s.plan,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN p.status = 'failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN p.status = 'failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS failure_rate_pct
FROM payments p
JOIN subscriptions s ON s.subscription_id = p.subscription_id
GROUP BY s.plan
ORDER BY failure_rate_pct DESC;


-- Revenue lost due to failed payments by plan
SELECT 
    s.plan,
    s.mrr,
    SUM(CASE WHEN p.status = 'failed' THEN s.mrr ELSE 0 END) AS revenue_lost,
    COUNT(CASE WHEN p.status = 'failed' THEN 1 END) AS failed_count
FROM payments p
JOIN subscriptions s ON s.subscription_id = p.subscription_id
GROUP BY s.plan
ORDER BY revenue_lost DESC;