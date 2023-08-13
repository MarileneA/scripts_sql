SELECT 
	oi.price,
	CASE 
		WHEN oi.price > 100.0 THEN 'barato'
		ELSE 'caro'
	END as status
FROM order_items oi 
LIMIT 10

--IIF
SELECT
	oi.price,
	IIF(oi.price <100.0, 'barato','caro') as status
FROM order_items oi 
LIMIT 10

-- Case WHen Aninhado

SELECT
	oi.price,
	CASE
		WHEN oi.price < 20  THEN 'super_barato'
		WHEN oi.price < 100 THEN 'barato'
		WHEN oi.price > 150  AND oi.price < 180 THEN 'normal'
		ELSE 'caro' 
	END AS status
FROM order_items oi 
LIMIT 10