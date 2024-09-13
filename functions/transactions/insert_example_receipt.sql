
BEGIN;
PERFORM insert_full_data_from_single_receipt(
	'lidl', --shop name
	'Witosa 4 30-612 Kraków', --shop address
	'', --link to shop website
	'pln', --currency 
	'Polski złoty', --currency description
	43.72, --total of receipt
	'2024-09-12', --receipt date
	FALSE, --that was online purchase? 
	'', --link to scan of receipt if exists
	ARRAY[
		ROW('makaron udon', 'gram', NULL, NULL, 'spożywcze', 3.29, 0.00, 200, '', FALSE, FALSE, '', FALSE, NULL),
	]::purchased_product[]
);

COMMIT;

ROLLBACK;
