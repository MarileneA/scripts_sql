-- COALESCE
SELECT 
	o.order_id,
	o.customer_id,
	o.order_status,
	or2.review_comment_title,
	COALESCE (or2.review_comment_title, 'vazio') as full_text,
	o.order_status || "-" || COALESCE(or2.review_comment_title, 'vazio') as new_title
FROM orders o  INNER JOIN order_reviews or2 ON (or2.order_id = o.order_id)


--LOWER() UPPER()
 SELECT 
	o.order_id,
	o.customer_id,
	o.order_status,
	or2.review_comment_title,
	COALESCE (or2.review_comment_title, 'vazio') as full_text,
	LOWER( o.order_status || "-" || COALESCE(or2.review_comment_title, 'vazio')) as new_title
FROM orders o  INNER JOIN order_reviews or2 ON (or2.order_id = o.order_id)


--SUBSTRING() Tira pedaço do texto
SELECT 
	o.order_id,
	o.customer_id,
	o.order_status,
	or2.review_comment_title,
	LOWER(COALESCE (or2.review_comment_title, 'vazio')) as full_text,
	SUBSTRING(or2.review_comment_title, 5,3) as new_title
FROM orders o  INNER JOIN order_reviews or2 ON (or2.order_id = o.order_id)


--REPLACE 
SELECT 
	o.order_id,
	o.customer_id,
	o.order_status,
	or2.review_comment_title,
	LOWER(o.order_status || "-" || COALESCE(or2.review_comment_title, 'vazio')) as full_text,
	REPLACE (or2.review_comment_title, 'recomendo', 'super recomendo') as new_title
FROM orders o  LEFT JOIN order_reviews or2 ON (or2.order_id = o.order_id)


--ROUND() arredonda


-- WITH 
--Conte quantas parcelas tem cada pedido

WITH parcelas AS(
	SELECT 
		op.order_id,
		SUM(op.payment_installments) AS parcelas
	FROM order_payments op 
	GROUP BY op.order_id
)

SELECT *
FROM parcelas




SELECT *
FROM parcelas