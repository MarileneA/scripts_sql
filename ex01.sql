SELECT 
	customer_city, 
	customer_state 
FROM customer c 

/*1. Qual o número de clientes únicos do estado de Minas Gerais?*/
Select
	count(DISTINCT (c.customer_state)) as MG
from
	customer c 
	
WHERE 
	customer_state = 'MG'
	
	
/*2. Qual a quantidade de cidades únicas dos vendedores do
estado de Santa Catarina?*/
	
SELECT 
	count(DISTINCT(geolocation_city)) as seller_SC
FROM
	geolocation g 
WHERE 
geolocation_state = 'SC'


/*Qual a quantidade de cidades únicas de todos os vendedores
da base?*/
SELECT
COUNT(DISTINCT(geolocation_city) )	
FROM 
	geolocation g 
	
/*4. Qual o número total de pedidos únicos acima de R$ 3.500*/

select
	COUNT( DISTINCT (oi.price))
FROM 
	order_items oi
WHERE 
	price >3500
	
/*5. Qual o valor médio do preço de todos os pedidos?*/
	
SELECT 
	AVG (oi.price)  as avg_price
FROM 
	order_items oi 

/*6. Qual o maior valor de preço entre todos os pedidos?*/
select
	MAX(oi.price) as max_value
FROM 
	order_items oi 
	
/*7. Qual o menor valor de preço entre todos os pedidos?*/
select
	MIN(oi.price)
FROM 
	order_items oi 
	
/*8. Qual a quantidade de produtos distintos vendidos abaixo do
preço de R$ 100.00?*/
SELECT
	COUNT(DISTINCT(oi.product_id) )
from
	order_items oi 
WHERE 
	oi.price < 100
	
/*9. Qual a quantidade de vendedores distintos que receberam
algum pedido antes do dia 23 de setembro de 2016?*/
	
SELECT 
	COUNT( DISTINCT(oi.seller_id))
FROM 
	order_items oi 
WHERE 
	shipping_limit_date < '2016-09-23 00:00:00'
	
/*10. Quais os tipos de pagamentos existentes?*/
SELECT 
	DISTINCT(payment_type)
FROM
	order_payments op
	
/*11. Qual o maior número de parcelas realizado?*/
select
	MAX(op.payment_installments) as parcelas
FROM 
	order_payments op 

/*12. Qual o menor número de parcelas realizado?*/
select
	MIN(op.payment_installments) as qtde_min_parcelas
FROM 
	order_payments op 
	
/*13. Qual a média do valor pago no cartão de crédito?*/
select
	AVG(op.payment_value) 
FROM 
	order_payments op 
WHERE 
	op.payment_type = 'credit_card'
	
/*14. Quantos tipos de status para um pedido existem?*/
SELECT 
	COUNT( DISTINCT (order_status))
FROM 
	orders 
	
/*15. Quais os tipos de status para um pedido?*/
	
select
	DISTINCT(o.order_status)
from
	orders o 
	
/*16. Quantos clientes distintos fizeram um pedido?*/
	
select
	count(DISTINCT(c.customer_id) )
FROM 
	customer c 
	
/*17. Quantos produtos estão cadastrados na empresa?*/
	
select
	COUNT(DISTINCT(product_id) )
FROM 
	products

/*18. Qual a quantidade máxima de fotos de um produto?*/
select
	MAX(DISTINCT (p.product_photos_qty) )
FROM 
	products p 

/* 19. Qual o maior valor do peso entre todos os produtos?*/
select
	MAX(DISTINCT (p.product_weight_g) )
FROM 
	products p 

/*20. Qual a altura média dos produtos?*/
select
AVG(DISTINCT (p.product_height_cm) )
FROM 
products p 


/*4. 1. Qual o número de clientes únicos de todos os estados?*/
Select
	c.customer_id,
	COUNT(DISTINCT c.customer_id) as clientes
FROM  customer c 
	group by c.customer_state 
	
/*4.2. Qual o número de cidades únicas de todos os estados?*/
SELECT 
	customer_state  ,
	count(DISTINCT customer_city) as numero_cidade
FROM customer c  
	group by c.customer_state  

/*4.3 . Qual o número de clientes únicos por estado e por cidade?*/
	
SELECT 
	c.customer_state,
	c.customer_city ,
	COUNT(DISTINCT c.customer_id) as clientes
FROM 	customer c 
group by c.customer_state, customer_city

/*4. Qual o número de clientes únicos por cidade e por estado?*/
SELECT 
	c.customer_city , 
	customer_state ,
	count( DISTINCT customer_id)
FROM customer c 
group by c.customer_city , customer_state 

/*4.5. Qual o número total de pedidos únicos acima de R$ 3.500 por cada vendedor?*/

SELECT 
	seller_id,
	COUNT(DISTINCT oi.order_id)
FROM order_items oi 

where price > 3500
group by seller_id


/*6. Qual o número total de pedidos únicos, a data mínima e máxima de envio, o valor máximo, mínimo e médio do frete
dos pedidos acima de R$ 1.100 por cada vendedor?*/
SELECT 
	oi.seller_id,
	COUNT(DISTINCT order_id  )      as pedido,
	MAX(shipping_limit_date)        as data_max,
	MIN(shipping_limit_date)        as data_min,
	AVG(freight_value)              as frete_medio,
	MAX(oi.freight_value)           as frete_max,
	MIN(oi.freight_value)           as frete_min
FROM
	order_items oi 
	
WHERE oi.price >1100
GROUP BY seller_id


/*4.7. Qual o valor médio, máximo e mínimo do preço de todos os pedidos de cada produto?*/

SELECT
	oi.product_id ,
	AVG(oi.price) as preco_medio,
	MAX(oi.price) as preco_max,
	MIN(oi.price) as preco_min
FROM 
order_items oi
group by oi.product_id  

/*8. Qual a quantidade de vendedores distintos que receberam algum pedido antes do dia 23 de setembro de 2016 e qual foi o preço médio desses pedidos?*/

SELECT 
	oi.shipping_limit_date ,
	COUNT(DISTINCT seller_id),
	AVG(price)
FROM order_items oi 
WHERE oi.shipping_limit_date < '23/09/2016 00:00:00'
GROUP BY oi.shipping_limit_date 

/*4.9. Qual a quantidade de pedidos por tipo de pagamentos?*/
SELECT 
	op.payment_type,
	COUNT(op.order_id) 
FROM 
	order_payments op 
group by 
	op.payment_type 

/*4.10. Qual a quantidade de pedidos, a média do valor do pagamento e o número máximo de parcelas por tipo de pagamentos?*/
	
SELECT 
op.payment_type,
COUNT(op.order_id), 
AVG(op.payment_value),
MAX(op.payment_installments)
FROM 
order_payments op
group by op.payment_type 

/*4.11. Qual a valor mínimo, máximo, médio e as soma total paga por cada tipo de pagamento e número de parcelas disponíveis?*/

SELECT 
	op.payment_type,
	op.payment_installments,
	count(op.order_id),
	AVG(op.payment_value),
	MAX(op.payment_value),
	MIN(op.payment_value),
	SUM(op.payment_value), 
	MAX(op.payment_installments)
FROM 
	order_payments op
group by op.payment_installments, op.payment_installments 

/*4.13. Qual a média de pedidos por cliente?*/
SELECT 
o.customer_id,
AVG(o.order_id)
FROM orders o  
group by o.customer_id 

/*4.14. Qual a quantidade de pedidos realizados por cada status do pedido, a partir do dia 23 de Setembro de 2016?*/

SELECT 
	o.order_status ,
	COUNT(o.order_id) as pedido
FROM orders o
WHERE o.order_approved_at  > '2016/09/23 00:00:00' 

GROUP BY o.order_status

/*4.15  Qual a quantidade de pedidos realizados por dia, a partir do dia 23 de Setembro de 2016?*/
SELECT 
o.order_id,
DATE(o.order_approved_at) as data,
COUNT(o.order_id) 
FROM orders o 
WHERE o.order_approved_at  > '2016/09/23 00:00:00' 
GROUP BY o.order_approved_at 

/*4.16. Quantos produtos estão cadastrados na empresa por categoria?*/

SELECT 
p.product_category_name,
COUNT(DISTINCT p.product_id)  as Quantidade
FROM products p 
group by p.product_category_name 


/*5.1. Qual o número de clientes únicos do estado de São Paulo?*/
SELECT 
c.customer_id,
COUNT(DISTINCT c.customer_id)  as clientes
FROM 
customer c 
WHERE c.customer_state = 'SP'

/*5. 2. Qual o número total de pedidos únicos feitos no dia 08 de Outubro de 2016?*/

SELECT 
	oi.order_id,
	COUNT(DISTINCT oi.order_id) 
FROM 
	order_items oi 
WHERE 
	DATE( oi.shipping_limit_date) = '2016-10-08'
	
	
/*5.3. Qual o número total de pedidos únicos feitos a partir do dia 08 de Outubro de 2016 ?*/
SELECT 
oi.order_id,
COUNT(DISTINCT oi.order_id) 
FROM order_items oi 
WHERE DATE(oi.shipping_limit_date) > '2016-10-08'

/*5.4. Qual o número total de pedidos únicos feitos a partir do dia 08 de Outubro de 2016 incluso.*/
SELECT 
COUNT(DISTINCT oi.order_id) 
FROM 
	order_items oi 
WHERE 
	DATE(oi.shipping_limit_date) >= '2016-10-08' 


/*5. Qual o número total de pedidos únicos, a data mínima e máxima de envio, o valor máximo, mínimo e médio do frete 
 * dos pedidos abaixo de R$ 1.100 por cada vendedor?*/

SELECT 
oi.seller_id,
oi.price ,
COUNT(DISTINCT oi.order_id),
max(oi.shipping_limit_date) as data_max,
min(oi.shipping_limit_date) as data_min,
max(oi.freight_value) as frete_max,
MIN(oi.freight_value) as frete_min
FROM 
order_items oi 
WHERE oi.price < 1100 
GROUP BY oi.seller_id 


/*6. Qual o número total de pedidos únicos, a data mínima e máxima de envio, o valor máximo, mínimo e médio do frete
 * dos pedidos abaixo de R$ 1.100 incluso por cada vendedor?*/

SELECT 
COUNT(DISTINCT order_id) as pedidos_unicos,
avg(oi.freight_value)
FROM 
order_items oi 
WHERE
price <=1100


/*6.1. Qual o número de clientes únicos nos estado de Minas Gerais ou Rio de Janeiro?*/
SELECT
customer_state,
COUNT( DISTINCT c.customer_id ) AS cliente_unico
FROM customer c
WHERE c.customer_state = 'MG' OR c.customer_state = 'RJ'
GROUP BY customer_state 


/*2. Qual a quantidade de cidades únicas dos vendedores no estado de São Paulo ou Rio de Janeiro 
 * com a latitude maior que -24.54 e longitude menor que -45.63?*/

SELECT 
g.geolocation_state,
COUNT( DISTINCT g.geolocation_city ) AS cidades
FROM geolocation g
WHERE g.geolocation_state = 'SP' OR g.geolocation_state = 'RJ'
AND ( g.geolocation_lat > -24.54 AND g.geolocation_lng < -45.63 )
GROUP BY g.geolocation_state


	
/*3. Qual o número total de pedidos únicos, o número total de produtos 
 * e o preço médio dos pedidos com o preço de frete maior que R$ 20 e a data limite
 * de envio entre os dias 1 e 31 de Outubro de 2016?*/
SELECT 
COUNT(DISTINCT oi.order_id) as pedidos_unicos,
COUNT(DISTINCT oi.product_id)  as produtos_unicos,
AVG(oi.price ) as preco_medio
FROM 
order_items oi 
WHERE 
oi.freight_value > 20
and oi.shipping_limit_date >= '2016-10-01'
and oi.shipping_limit_date <= '2016-10-31'


/*4. Mostre a quantidade total dos pedidos e o valor total do pagamento, 
 * para pagamentos entre 1 e 5 prestações
 *  ou um valor de pagamento acima de R$5000.*/
SELECT 
payment_type,
payment_installments,
COUNT(op.order_id) as qtde_pedidos,
count(op.payment_value) as preco_total
FROM 
order_payments op 
WHERE 
op.payment_installments BETWEEN  '1' and '5'
or op.payment_value > 5000
GROUP BY op.payment_type, op.payment_installments 


/*5. Qual a quantidade de pedidos com o status em processamento 
 * ou cancelada acontecem com a data estimada de entrega maior que 01 de Janeirode 2017 
 * ou menor que 23 de Novembro de 2016?*/
SELECT
o.order_status,
COUNT(o.order_id) as pedido
FROM 
orders o 
WHERE 
(o.order_status ='processing' or  o.order_status ='canceled')
and (o.order_estimated_delivery_date < '2016-11-23' or o.order_estimated_delivery_date > '2017-01-01')	
group BY o.order_status 

/*6. Quantos produtos estão cadastrados nas categorias: perfumaria, brinquedos, esporte lazer, cama mesa e banho e
 *  móveis de escritório que possuem mais de 5 fotos, um peso maior que 5 g, um altura maior que 10 cm,
 * uma largura maior que 20 cm?*/

SELECT 
	p.product_category_name,
	COUNT(DISTINCT  p.product_id) as produto
FROM 
products p 
WHERE 
(		p.product_category_name = 'perfumaria'
	or  p.product_category_name = 'brinquedos'
	or  p.product_category_name = 'esporte_lazer'
	or  p.product_category_name ='cama_mesa_banho'
	or  p.product_category_name ='moveis_escritorio')
and p.product_photos_qty > 5
and p.product_weight_g  > 10
and p.product_width_cm > 20
GROUP BY p.product_category_name 




/*1. Quantos clientes únicos tiveram seu pedidos com status de “processing”, shipped” e “delivered”, 
 * feitos entre os dias 01 e 31 de Outubro de 2016. 
 * Mostrar o resultado somente se o número total de clientes for acima de 5.*/

SELECT 
o.order_status,
COUNT(DISTINCT o.customer_id) as cliente
FROM 
orders o 
WHERE o.order_purchase_timestamp BETWEEN '2016-10-01'and '2016-10-31'
and o.order_status  in ('processing', 'shipped', 'delivered')
GROUP BY o.order_status 
HAVING COUNT( DISTINCT o.customer_id) > 5

/*2. Mostre a quantidade total dos pedidos e o valor total do pagamento, 
 * parapagamentos entre 1 e 5 prestações 
 * ou um valor de pagamento acima de R$ 5000.*/

SELECT
payment_type,
payment_installments,
COUNT( op.order_id ) AS pedidos,
SUM( op.payment_value ) AS valor_total_pagamento
FROM order_payments op
WHERE op.payment_installments BETWEEN  ( 1 and 5 )
and op.payment_value >5000
GROUP BY payment_type, payment_installments


/*3. Quantos produtos estão cadastrados nas categorias: perfumaria,brinquedos, esporte lazer e cama mesa, 
 *  que possuem entre 5 e 10 fotos, um peso que não está entre 1 e 5 g, um altura maior que 10 cm, 
 * uma largura maior que 20 cm. Mostra somente as linhas com mais de 10 produtos únicos.*/

SELECT
product_category_name ,
COUNT( DISTINCT product_id ) AS produtos_unicos
FROM products p
WHERE product_category_name IN ( 'perfumaria', 'brinquedos', 'esporte_lazer', 'cama_mesa_banho')
AND product_photos_qty BETWEEN 5 AND 10
AND product_weight_g NOT BETWEEN 1 AND 5
AND product_height_cm > 10
AND product_width_cm > 20
GROUP BY product_category_name
HAVING COUNT( DISTINCT product_id ) > 10

 /*Refazer a consulta SQL abaixo, usando os operadores de intervalo.*/
SELECT
order_status ,
COUNT( order_id ) AS pedidos
FROM orders o
WHERE ( order_status = 'processing' OR order_status = 'canceled' )
AND ( o.order_estimated_delivery_date > '2017-01-01' OR o.order_estimated_delivery_date < '2016-11-23' )
GROUP BY order_status


/**/
SELECT 
o.order_status,
COUNT(o.order_id) as pedido 
FROM orders o 
WHERE o.order_status IN ('processing', 'canceled')
and ( o.order_estimated_delivery_date > '2017-01-01' OR o.order_estimated_delivery_date < '2016-11-23' )
GROUP BY order_status 

/*5. Qual a quantidade de cidades únicas dos vendedores no estado de São Paulo ou Rio de Janeiro 
 * com a latitude maior que -24.54 e longitude menor que -45.63?*/

SELECT
g.geolocation_state,
COUNT( DISTINCT g.geolocation_city ) AS cidades
FROM geolocation g
WHERE g.geolocation_state IN ( 'SP', 'RJ' )
AND ( g.geolocation_lat > -24.54 AND g.geolocation_lng < -45.63 )
GROUP BY g.geolocation_state


/*6. Quantos produtos estão cadastrados em qualquer categorias que comece com a letra “a” 
 * e termine com a letra “o” e que possuem mais de 5 fotos? Mostrar as linhas com mais de 10 produtos.*/
SELECT
product_category_name ,
COUNT( DISTINCT product_id ) AS produto
FROM products p
WHERE product_category_name LIKE 'a%o'
AND product_photos_qty > 5
GROUP BY product_category_name
HAVING COUNT( DISTINCT product_id ) > 10



/*7. Qual o número de clientes únicos, agrupados por estado e por cidades que
comecem com a letra “m”, tem a letra “o” e terminem com a letra “a”? Mostrar
os resultados somente para o número de clientes únicos maior que 10.*/

SELECT 
customer_state,
customer_city,
COUNT(DISTINCT c.customer_id) as clientes_unicos
FROM customer c 
WHERE c.customer_city LIKE 'm%o%a'
GROUP by c.customer_state, c.customer_city 
HAVING COUNT(DISTINCT c.customer_id) >10

/**/
SELECT 
	AVG(oi.price) as avg_price
FROM order_items oi 
WHERE oi.product_id  IN (SELECT p.product_id 
                         FROM products p
                         WHERE p.product_category_name IN ('perfumaria', 'artes'))




SELECT 
oi.product_id,
(SELECT p.product_category_name  FROM products p WHERE p.product_id = oi.product_id) as category_name
FROM order_items oi 


SELECT 
	p.product_category_name,
	(SELECT AVG( OI.price)  FROM order_items oi ) as avg_price_all,
	(select AVG(oi2.price)  from order_items oi2 WHERE oi2.product_id = p.product_id) as avg_price
FROM products p 
limiT 20

select AVG(oi.price) as avg_price
FROM order_items oi 
WHERE oi.order_id IN (SELECT o.order_id 
					  FROM orders o 
					  WHERE o.order_status = 'delivered')
					  
					  
SELECT 
        DATE(or2.review_creation_date) ,
		avg(review_score ) as avg_review
FROM order_reviews or2 
GROUP BY DATE(or2.review_creation_date )
LIMIT 20

SELECT date(oi.shipping_limit_date ) as date_,
		avg(oi.price) as price,
		sum(oi.price) as total_price,
		max(oi.price) as max_price,
		min(oi.price) as min_price
FROM order_items oi 
GROUP BY DATE(oi.shipping_limit_date)














