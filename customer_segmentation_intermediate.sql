Use customersegmentationdb;
#Perform Customer Segmentation & Analysis
#Calculate Total Spending & Number of Transactions Per Customer
SELECT c.customer_id, c.first_name, c.last_name, c.email, c.country, 
       COUNT(t.transaction_id) AS total_transactions,
       SUM(t.amount) AS total_spent
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.country
ORDER BY total_spent DESC;

# Classify Customers into Spending Tiers Using CASE Statement
SELECT customer_id, first_name, last_name, total_spent,
       CASE 
           WHEN total_spent >= 1000 THEN 'VIP Customer'
           WHEN total_spent >= 500 THEN 'High Spender'
           WHEN total_spent >= 200 THEN 'Moderate Spender'
           ELSE 'Low Spender'
       END AS spending_category
FROM (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(t.amount) AS total_spent
    FROM customers c
    LEFT JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) AS customer_spending;

#Identify Customers Who Have Not Made Any Transactions
SELECT c.customer_id, c.first_name, c.last_name, c.email, c.country
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL;

#Calculate the Recency of Last Transaction for Each Customer
SELECT c.customer_id, c.first_name, c.last_name, MAX(t.transaction_date) AS last_transaction_date,
       DATEDIFF(CURDATE(), MAX(t.transaction_date)) AS days_since_last_purchase
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY days_since_last_purchase DESC;

# Rank Customers by Spending Using Window Functions
SELECT customer_id, first_name, last_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(t.amount) AS total_spent
    FROM customers c
    LEFT JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) AS customer_spending;





