-- Assessment_Q3.sql
-- Question 3: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) 

-- Savings Accounts Inactivity
SELECT 
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
WHERE s.confirmed_amount > 0
GROUP BY s.id, s.owner_id
HAVING MAX(s.transaction_date) < CURDATE() - INTERVAL 365 DAY

UNION

-- Investment Accounts Inactivity
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    p.last_charge_date AS last_transaction_date,
    DATEDIFF(CURDATE(), p.last_charge_date) AS inactivity_days
FROM plans_plan p
WHERE p.is_a_fund = 1 
  AND p.amount > 0
  AND p.last_charge_date < CURDATE() - INTERVAL 365 DAY;
