/*1. Qual o número de clientes únicos por cidade */
SELECT customer_city,
COUNT( c.customer_id) as qty_customer
FROM customer c 
Group By customer_city 

/*2. Quantos clients únicos tem na table?*/
Select COUNT(c.customer_id)
from customer c 


/*2. Quantos clients únicos tem na table?*/
select COUNT(DISTINCT o.order_id) 
from orders o  

/**/
Select
COUNT(DISTINCT o.order_id) 
From orders o INNER JOIN order_items oi ON (oi.order_id = o.order_id)
LIMIT 20


/*1. Gerar uma tabela de dados com 10 linhas, contendo o id
do pedido, o id do cliente, o status do pedido, o id do produto
e o preço do produto.*/

SELECT 
o.order_id,
o.customer_id,
o.order_status,
oi.product_id,
oi.price 
FROM orders o  inner join order_items oi on (o.order_id = oi.order_id)
LIMIT 10


/*2. Gerar uma tabela de dados com 20 linhas, contendo o id
do pedido, o estado do cliente, a cidade do cliente, o status
do pedido, o id do produto e o preço do produto, somente
para clientes do estado de São Paulo.*/

SELECT 
o.order_id,
c.customer_state,
c.customer_city,
oi.product_id,
oi.price
FROM orders o  INNER JOIN order_items oi  ON (oi.order_id = o.order_id  )
			   INNER JOIN customer c      ON (c.customer_id = o.customer_id)	
where c.customer_state= 'SP'
LIMIT 20;

SELECT *
count(c.ISNULL)
from customer c 



/*Subqueries*/
SELECT
	AVG(oi.price) AS avg_price
FROM order_items oi 
WHERE oi.product_id IN (SELECT p.product_id
					   From products p
					   WHERE p.product_category_name IN ('perfumaria', 'artes'))

/* Adicionar uma nova coluna usando subqueries na clausula select*/
SELECT 
	oi.product_id,
	(SELECT p.product_category_name
	FROM products p 
	WHERE p.product_id = oi.product_id) as Category_name
FROM order_items oi 
LIMIT 10

/* Usando join*/
SELECT
oi.product_id,
p.product_category_name as category
FROM order_items oi left join products p ON (p.product_id= oi.product_id)
LIMIT 10

/*Adicionando coluna analisar como está a venda média em relação ao preco geral*/
SELECT 
p.product_category_name,
(SELECT AVG(oi.price) FROM order_items oi) as avg_price_all,
(SELECT AVG(oi2.price) FROM order_items oi2 WHERE oi2.product_id = p.product_id) as avg_prod_cat_name
FROM products p  
LIMIT 10

/**Subqueries dentro do WHERE**/
/** Selecionar a média apenas dos produtos que foram entregues**/

SELECT 
	oi.product_id,
	AVG(oi.price) as avg_price
FROM order_items oi  
WHERE oi.order_id IN (SELECT 
					      o.order_id
					   FROM orders o
      			      WHERE o.order_status = 'delivered')
      			      
      			      
/* Subqueries na clausula FROM 
-- Calcular a média das avaliações, preço médio, preço total, min e máx, clientes unicos
-- Por dia*/
      			      
SELECT 
  DATE(or2.review_creation_date) as date_,
  AVG( review_score) as avg_review
FROM order_reviews or2 
Group BY or2.review_creation_date

SELECT 
Date(oi.shipping_limit_date) AS date_,
AVG(oi.price) as avg_price,
SUM(oi.price) as total_price,
MAx(oi.price) as max_price,
MIN(oi.price) as min_price
FROM order_items oi 
group by DATE(oi.shipping_limit_date)


SELECT 
	DATE(o.order_purchase_timestamp) as date_,
	COUNT(DISTINCT customer_id) as unique_customer
FROM orders o 
group by DATE(o.order_purchase_timestamp)  


SELECT
t1.date_,
t1.avg_review,
t2.avg_price,
t2.total_price,
t2.max_price,
t2.min_price,
t3.unique_customer
FROM (SELECT 
		  DATE(or2.review_creation_date) as date_,
		  AVG( review_score) as avg_review
	  FROM order_reviews or2 
	  Group BY daTE(or2.review_creation_date)) as t1 
												 inner join (SELECT 
																	Date(oi.shipping_limit_date) as date_,
																	AVG(oi.price) as avg_price,
																	SUM(oi.price) as total_price,
																	MAx(oi.price) as max_price,
																	MIN(oi.price) as min_price
																FROM order_items oi 
																group by DATE(oi.shipping_limit_date)) as t2 on (t1.date_ = t2.date_)
          										 inner join (SELECT 
																	DATE(o.order_purchase_timestamp) as date_ ,
																	COUNT(DISTINCT customer_id) as unique_customer
															 FROM orders o 
															 group by DATE(o.order_purchase_timestamp)) as t3 on (t3.date_ = t2.date_)
WHERE t1.date_ BETWEEN  '2016-10-02' and '2016-10-09';