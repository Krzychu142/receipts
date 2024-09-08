CREATE OR REPLACE VIEW total_money_spent_view AS
SELECT SUM(total) AS "Total money spent"
FROM receipts;