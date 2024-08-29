CREATE OR REPLACE VIEW total_money_spent_per_category_view AS
SELECT 
    SUM(p.price) AS "Total money spent",
    c.name AS "Category name"
FROM purchases p
INNER JOIN products pr ON pr.product_id = p.product_id
INNER JOIN categories c ON c.category_id = pr.category_id
GROUP BY c.name
ORDER BY "Total money spent" DESC;