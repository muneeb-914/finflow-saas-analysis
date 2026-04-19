-- FINFLOW SAAS - CHURN ANALYSIS

-- ============================================



-- Q1: Total customers and subscriptions overview

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_subscriptions FROM subscriptions;

SELECT COUNT(*) AS total_cancellations FROM cancellations;



-- Q2: Cancellations per year

SELECT 

    strftime('%Y', cancellation_date) AS year, 

    COUNT(*) AS churned

FROM cancellations

GROUP BY year

ORDER BY year;



-- Q3: Customers acquired per year

SELECT 

    strftime('%Y', signup_date) AS year, 

    COUNT(*) AS total_customers

FROM customers

GROUP BY year

ORDER BY year;



-- Q4: Churn rate by year (manual calculation from Q2 and Q3)

-- 2022: 31 / 238 = 0.13 (13%)

-- 2023: 84 / 237 = 0.35 (35%)

-- 2024: 54 / 125 = 0.43 (43%)

-- FINDING: Churn rate is nearly tripling over time



-- Q5: Churn rate by plan

SELECT 

    s.plan,

    COUNT(DISTINCT s.customer_id) AS total_customers,

    COUNT(DISTINCT cn.customer_id) AS churned_customers,

    ROUND(COUNT(DISTINCT cn.customer_id) * 100.0 / COUNT(DISTINCT s.customer_id), 1) AS churn_rate_pct

FROM subscriptions s

LEFT JOIN cancellations cn ON cn.customer_id = s.customer_id

GROUP BY s.plan

ORDER BY churn_rate_pct DESC;

-- FINDING: All plans churn almost equally, plan type is NOT the problem



-- Q6: Churn rate by sales rep

SELECT 

    c.sales_rep,

    COUNT(DISTINCT s.customer_id) AS total_customers,

    COUNT(DISTINCT cn.customer_id) AS churned_customers,

    ROUND(COUNT(DISTINCT cn.customer_id) * 100.0 / COUNT(DISTINCT s.customer_id), 1) AS churn_rate_pct

FROM customers c

JOIN subscriptions s ON s.customer_id = c.customer_id

LEFT JOIN cancellations cn ON cn.customer_id = c.customer_id

GROUP BY c.sales_rep

ORDER BY churn_rate_pct DESC;

-- FINDING: Omar N. has 43% churn vs company average 28%



-- Q7: Omar's customer distribution by industry (validating if bad leads)

SELECT 

    c.sales_rep,

    c.industry,

    COUNT(DISTINCT c.customer_id) AS total_customers

FROM customers c

WHERE c.sales_rep = 'Omar N.'

GROUP BY c.industry

ORDER BY total_customers DESC;

-- FINDING: Evenly distributed across all 6 industries, bad leads ruled out



-- Q8: Cancellation reasons - Omar vs Sarah

SELECT 

    c.sales_rep,

    cn.reason,

    COUNT(*) AS count

FROM cancellations cn

JOIN customers c ON c.customer_id = cn.customer_id

WHERE c.sales_rep IN ('Omar N.', 'Sarah K.')

GROUP BY c.sales_rep, cn.reason

ORDER BY c.sales_rep, count DESC;

-- FINDING: Omar's customers actively leave (competitor, poor support)

-- Sarah's customers leave passively (business closed, not using it)</sql><current_tab id="0"/></tab_sql></sqlb_project>
