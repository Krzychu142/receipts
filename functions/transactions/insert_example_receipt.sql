
BEGIN;

SELECT insert_full_data_from_single_receipt(
	'lidl',
	'Witosa 4 30-612 Kraków',
	'', 
	'pln',
	'Polski złoty',
	43.72,
	'2024-09-12',
	FALSE, 
	'',
	ARRAY[
		ROW('makaron udon', 'gram', NULL, NULL, 'spożywcze', 3.29, 0.00, 200, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('makaron udon', 'gram', NULL, NULL, 'spożywcze', 3.29, 0.00, 200, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('ser twardy dojrzewający', 'gram', NULL, NULL, 'spożywcze', 8.49, 0.00, 150, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('frankfurterki z szynki', 'gram', NULL, NULL, 'spożywcze', 10.40, 0.00, 350, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('pomidory w puszce', 'gram', NULL, NULL, 'spożywcze', 2.99, 0.00, 400, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('pomidory suszone', 'gram', NULL, NULL, 'spożywcze', 6.99, 0.00, 280, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('kabanosy premium tarczyński wołowe', 'gram', NULL, NULL, 'spożywcze', 6.79, 0.00, 105, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product,
		ROW('jabłka czerwone', 'kilogram', 'gram', 1000.0, 'spożywcze', 1.48, 0.00, 0.53, '', FALSE, FALSE, '', FALSE, NULL)::purchased_product
	]::purchased_product[]
);

COMMIT;

ROLLBACK;