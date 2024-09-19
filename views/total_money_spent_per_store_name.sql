CREATE OR REPLACE VIEW total_money_spent_per_store_name_view AS
SELECT 
	SUM(r.total) AS "Total money spent in store", 
	s.name AS "Store name"
FROM receipts r INNER JOIN stores s 
ON s.store_id = r.store_id 
GROUP BY s.name
ORDER BY "Total money spent in store" DESC;