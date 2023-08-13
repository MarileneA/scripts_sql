--calcular o preço médio por categoria
SELECT 
	p.product_category_name,
	AVG(oi.price)  as avg_price
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE p.product_category_name IS NOT NULL 
GROUP BY p.product_category_name 


-- WIndow FUNCTIon 
SELECT 
	p.product_category_name,
	oi.price,
	AVG(oi.price) OVER( PARTITION BY p.product_category_name) as avg_price
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE p.product_category_name IS NOT NOT NULL 


-- Calcular o preço médio por categoria e tipo de pagto
SELECT 
	p.product_category_name,
	op.payment_type,
	oi.price,
	AVG(oi.price) as avg_price
FROM order_items oi INNER JOIN products p        ON(p.product_id = oi.product_id)
					INNER JOIN order_payments op ON (op.order_id = oi.order_id)
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name, op.payment_type 


-- WINDOW FUNCTION 
SELECT
	p.product_category_name,
	oi.price,
	op.payment_type,
	AVG(oi.price) OVER (PARTITION BY p.product_category_name, op.payment_type) as avg_price
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
					INNER JOIN order_payments op ON (op.order_id = oi.order_id)
WHERE p.product_category_name IS NOT NULL

--ROW_NUMBER - Enumera os segmentos
SELECT 
	p.product_category_name,
	oi.price,
	ROW_NUMBER() OVER (PARTITION BY p.product_category_name
					   ORDER BY oi.price DESC) as price_rank
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE 
	p.product_category_name IS NOT NULL

--RANK - ELE soma os numeros que repetem
SELECT 
	p.product_category_name,
	oi.price,
	RANK () OVER (PARTITION BY p.product_category_name
					   ORDER BY oi.price DESC) as price_rank
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE 
	p.product_category_name IS NOT NULL
	
	
--DENSE_RANK 
SELECT 
	p.product_category_name,
	oi.price,
	DENSE_RANK() OVER (PARTITION BY p.product_category_name
					   ORDER BY oi.price DESC) as price_rank
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE 
	p.product_category_name IS NOT NULL

--PERC_RANK 
SELECT 
	p.product_category_name,
	oi.price,
	PERCENT_RANK() OVER (PARTITION BY p.product_category_name
					   ORDER BY oi.price DESC) as price_rank
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE 
	p.product_category_name IS NOT NULL
	
	
--NTILE 
SELECT 
	p.product_category_name,
	oi.price,
	NTILE(4) OVER (PARTITION BY p.product_category_name
					   ORDER BY oi.price DESC) as price_rank
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE 
	p.product_category_name IS NOT NULL
	
	
-- Fução LAG - ATRASA - Útil para calcular datas
SELECT 
	p.product_category_name,
	oi.price,
	oi.shipping_limit_date,
	LAG(oi.shipping_limit_date) OVER (PARTITION BY p.product_category_name
									  ORDER BY oi.shipping_limit_date) as date_shift
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE p.product_category_name IS NOT NULL
	
-- Função LEAD - Útil para calcular datas
SELECT 
	p.product_category_name,
	oi.price,
	oi.shipping_limit_date,
	LEAD (oi.shipping_limit_date) OVER (PARTITION BY p.product_category_name
									  ORDER BY oi.shipping_limit_date) as date_shift
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE p.product_category_name IS NOT NULL

-- Função FIRST VALUE - SEtar funções de valor
SELECT 
	p.product_category_name,
	oi.price,
	oi.shipping_limit_date,
	FIRST_VALUE(oi.shipping_limit_date) OVER (PARTITION BY p.product_category_name
									  ORDER BY oi.shipping_limit_date) as date_shift
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE p.product_category_name IS NOT NULL

-- Função NTH VALUE - SEtar funções de valor
SELECT 
	p.product_category_name,
	oi.price,
	oi.shipping_limit_date,
	NTH_VALUE(oi.shipping_limit_date, 2) OVER (PARTITION BY p.product_category_name
									  ORDER BY oi.shipping_limit_date) as date_shift
FROM order_items oi INNER JOIN products p ON (p.product_id = oi.product_id)
WHERE p.product_category_name IS NOT NULL


-- Controle do Tamanho da Janela
SELECT
	o.order_purchase_timestamp,
	oi.price,
	AVG(oi.price) OVER (ORDER BY o.order_purchase_timestamp ASC
						ROWS BETWEEN 7 PRECEDING AND CURRENT ROW ) AS AVG7_days
FROM orders o INNER JOIN order_items oi  ON (oi.order_id = o.order_id) 

--FOLLOWING 
-- Controle do Tamanho da Janela
SELECT
	o.order_purchase_timestamp,
	oi.price,
	AVG(oi.price) OVER (ORDER BY o.order_purchase_timestamp ASC
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS AVG7_days
FROM orders o INNER JOIN order_items oi  ON (oi.order_id = o.order_id) 
	