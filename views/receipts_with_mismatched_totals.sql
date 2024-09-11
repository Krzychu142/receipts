CREATE OR REPLACE VIEW receipts_with_mismatched_totals AS
SELECT 
    r.receipt_id, 
    s.name AS store_name,
    c.code AS currency_code,
    r.receipt_date,
    r.total AS receipt_total, 
    SUM(p.price - p.discount) AS products_total,
    r.is_online,
    r.receipt_scan
FROM 
    receipts r
JOIN 
    purchases p ON r.receipt_id = p.receipt_id
JOIN 
    stores s ON r.store_id = s.store_id
JOIN 
    currencies c ON r.currency_id = c.currency_id
GROUP BY 
    r.receipt_id, s.name, c.code, r.receipt_date, r.total, r.is_online, r.receipt_scan
HAVING 
    ROUND(SUM(p.price - p.discount), 2) <> r.total;