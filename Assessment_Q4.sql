-- Assessment_Q4.sql
-- Question 4: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, 
-- calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest

WITH transaction_stats AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.amount * 0.001) / COUNT(*) AS avg_profit_per_transaction
    FROM savings_savingsaccount s
    WHERE s.transaction_date IS NOT NULL
    GROUP BY s.owner_id
),

tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
)

SELECT 
    te.customer_id,
    te.name,
    te.tenure_months,
    ts.total_transactions,
    ROUND(
        (ts.total_transactions / NULLIF(te.tenure_months, 0)) * 12 * ts.avg_profit_per_transaction,
        2
    ) AS estimated_clv
FROM tenure te
JOIN transaction_stats ts ON ts.owner_id = te.customer_id
ORDER BY estimated_clv DESC;
