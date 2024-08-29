CREATE OR REPLACE VIEW total_money_spent_per_month_view AS
SELECT 
    SUM(total) AS "Total money spent", 
    DATE_TRUNC('month', receipt_date) AS "Month" 
FROM receipts 
GROUP BY DATE_TRUNC('month', receipt_date);