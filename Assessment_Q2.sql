-- Assessment_Q2.sql
-- Question 2: Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)

WITH monthly_transactions AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS ym,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY owner_id, ym
),

avg_transactions_per_customer AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

categorized_customers AS (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_transactions_per_customer
)

SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
