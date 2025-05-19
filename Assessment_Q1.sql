-- Assessment_Q1.sql
-- Question 1: Find customers with at least one funded savings plan and one funded investment plan

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    ROUND((COALESCE(s.total_savings, 0) + COALESCE(i.total_investments, 0)) / 100, 2) AS total_deposits_naira
FROM users_customuser u

-- Funded Savings Plans
JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,
        SUM(confirmed_amount) AS total_savings
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
) s ON s.owner_id = u.id

-- Funded Investment Plans
JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0
    GROUP BY owner_id
) i ON i.owner_id = u.id

ORDER BY total_deposits_naira DESC
LIMIT 5;
