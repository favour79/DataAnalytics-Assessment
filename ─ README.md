# DataAnalytics-Assessment

This repository contains SQL solutions for four data analytics scenarios involving customers, savings, and investment plans. Each question has been addressed with a properly structured SQL query, and challenges encountered during the process have been documented.

---

## Question 1: Customers with Funded Plans

### 🎯 Objective
Find customers who have at least one funded savings plan **and** one funded investment plan, and sort them by their total deposits.

### ✅ Approach
- Joined the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables.
- Applied conditions to filter for:
  - Funded savings plans: `confirmed_amount > 0`
  - Funded investment plans: `amount > 0 AND is_a_fund = 1`
- Grouped by user and used `HAVING` to ensure at least one of each.
- Calculated total deposits as the sum of confirmed savings and investment amounts.
- Ordered the results by total deposits in descending order.

### ⚠️ Challenges & Resolution
- **Challenge**: Error Code: 2013 — Lost connection to MySQL server during query.
- This typically happens when a query is too heavy or complex for the server to process in a single go.
  - **Resolved by** 
- To resolve this, we refactored the query into smaller, modular steps using CTEs to break down the logic and reduce the processing load at each stage
- **Challenge**: Ensuring only *funded* investment plans were considered.
  - **Resolved by** filtering within the `JOIN` clause using `is_a_fund = 1`.

---

## Question 2: Transaction Frequency Categorization

### 🎯 Objective
Categorize customers based on their **average number of transactions per month** into:
- High Frequency (≥10/month)
- Medium Frequency (3–9/month)
- Low Frequency (≤2/month)

### ✅ Approach
- Created a CTE (`monthly_transactions`) to count transactions per user per month.
- Averaged transaction count per user in a second CTE.
- Categorized customers using a `CASE` statement in a third CTE.
- Aggregated the results by frequency category and calculated average monthly transactions per group.

### ⚠️ Challenges & Resolution
- **Challenge**: Syntax error due to incorrect aliasing in `DATE_FORMAT`.
  - **Resolved by** explicitly naming the result column as `year_month`.
- **Challenge**: Some accounts had `NULL` transaction dates.
  - **Resolved by** filtering out `NULL` values using `WHERE transaction_date IS NOT NULL`.

---

## Question 3: Account Inactivity Alert

### 🎯 Objective
Identify all active savings or investment accounts that have had **no transactions in the last 1 year (365 days)**.

### ✅ Approach
- Queried both `savings_savingsaccount` and `plans_plan`.
- Calculated days since the last transaction using `DATEDIFF(NOW(), last_transaction_date)`.
- Filtered for rows where `last_transaction_date` is older than 365 days.
- Unified savings and investment results using `UNION ALL`.
- Labeled the type as 'Savings' or 'Investment' accordingly.

### ⚠️ Challenges & Resolution
- **Challenge**: `plan_id` had mixed data types (UUIDs and numeric IDs).
  - **Resolved by** not relying on ID format and focusing instead on `last_transaction_date` and type fields for filtering.
- **Challenge**: Ensuring all required fields were present in both SELECT queries for `UNION ALL`.
  - **Resolved by** aligning column names and order in both parts of the union.

---

## Question 4: Customer Lifetime Value (CLV)

### 🎯 Objective
Estimate the Customer Lifetime Value using this formula:(CLV = (total_transactions / tenure_in_months) * 12 * avg_profit_per_transaction)


- Assumption: `avg_profit_per_transaction = 0.001` (i.e., 0.1%)

### ✅ Approach
- Joined `users_customuser` and `savings_savingsaccount` tables.
- Used `TIMESTAMPDIFF(MONTH, date_joined, NOW())` to calculate account tenure in months.
- Counted total transactions per user.
- Applied the CLV formula as described.
- Ordered results by `estimated_clv` in descending order.

### ⚠️ Challenges & Resolution
- **Challenge**: Incorrect alias in the `SELECT` clause caused an error.
  - **Resolved by** tracing the error and ensuring consistent alias usage across CTEs and final SELECT.
- **Challenge**: Users with 0 tenure (e.g., just joined) could cause division by zero.
  - **Resolved by** adding a `WHERE tenure_months > 0` filter in the final query.

---

✅ All queries are self-contained and stored in their respective `.sql` files.
