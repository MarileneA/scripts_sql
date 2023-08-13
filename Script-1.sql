--Shopee
--Gerar uma tabela de dados com 20 linhas e contendo as seguintes
--colunas: 1) Id do pedido, 2) status do pedido, 3) id do produto, 4)
--categoria do produto, 5) avaliação do pedido, 6) valor do pagamento, 7)
--tipo do pagamento, 8) cidade do vendedor, 9) latitude e longitude da
--cidade do vendedor.
SELECT 
	o.order_id,
	o.order_status,
	oi.product_id,
	p.product_category_name,
	or2.review_comment_title,
	oi.price,
	op.payment_type,
	s.seller_city
FROM orders o LEFT JOIN order_items oi ON (oi.order_id = o.order_id)
			  LEFT JOIN products p ON (p.product_id = oi.product_id)
			  LEFT JOIN order_reviews or2 ON (or2.order_id = oi.order_id)
			  LEFT JOIN order_payments op ON (op.order_id = oi.order_id)
			  LEFT JOIN sellers s         ON (s.seller_id = oi.seller_id)
			  LEFT JOIN geolocation g     ON (g.geolocation_zip_code_prefix = s.seller_zip_code_prefix)
LIMIT 10
			  


--. Eu gostaria de saber, por categoria, a quantidade de produtos, o tamanho médio do
--produto, o tamanho médio da categoria alimentos e o tamanho médio geral.

SELECT 
	p.product_category_name,
	COUNT(DISTINCT p.product_id)	as produto,
	AVG(DISTINCT product_length_cm)        as avg_length,
	( SELECT AVG( DISTINCT p2.product_length_cm ) FROM products p2 WHERE p2.product_category_name ='alimentos' ) AS avg_length_alim,
	( SELECT AVG( DISTINCT p2.product_length_cm ) FROM products p2 WHERE p2.product_category_name ='alimentos' ) AS avg_length_all
FROM products p
GROUP BY p.product_category_name 


