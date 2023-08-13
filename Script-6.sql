-- QUal o produto mais vendidos por mes
	SELECT
	    strftime('%m', Mes) AS Mes,
	    MAX(CASE WHEN Produto = 430 THEN TotalApolices END) AS Produto_430_Apolices,
	    MAX(CASE WHEN Produto = 431 THEN TotalApolices END) AS Produto_431_Apolices,
	    MAX(CASE WHEN Produto = 436 THEN TotalApolices END) AS Produto_436_Apolices    
	FROM (
	    SELECT
	        Produto,
	        strftime('%m', Data) AS Mes,
	        COUNT(NroApolice) AS TotalApolices,
	        SUM(QtdSinistros) AS TotalQuantidade
	    FROM seguro
	    GROUP BY Produto, Mes
	) AS subquery
	GROUP BY Mes
	ORDER BY Mes Desc;


------------------------***************
UPDATE seguro
SET Mes = STRFTIME('%Y-%m', Data);

-- Calcular a quantidade total de apólices vendidas para cada região em cada mês
SELECT Regiao, Mes, COUNT(NroApolice) AS QuantidadeApolices
FROM seguro
GROUP BY Regiao, Mes;

-- Encontrar a região que vendeu mais apólices em cada mês
SELECT Mes, Regiao, QuantidadeApolices
FROM (
    SELECT Regiao, Mes, COUNT(NroApolice) AS QuantidadeApolices,
           RANK() OVER (PARTITION BY Mes ORDER BY COUNT(NroApolice) DESC) AS Rnk
    FROM seguro
    GROUP BY Regiao, Mes
) AS RnkTable
WHERE Rnk = 1;

---------------------------********************
-- Calcular a quantidade total de apólices vendidas para cada região em cada mês e transpor os resultados
SELECT Mes,
       MAX(CASE WHEN Regiao = 'Bancos' THEN QuantidadeApolices END) AS Bancos,
       MAX(CASE WHEN Regiao = 'Banrisul' THEN QuantidadeApolices END) AS Banrisul,
       MAX(CASE WHEN Regiao = 'Sicoob' THEN QuantidadeApolices END) AS Sicoob
FROM (
    SELECT Regiao, Mes, COUNT(NroApolice) AS QuantidadeApolices
    FROM seguro
    GROUP BY Regiao, Mes
) AS DadosApolicesPorRegiaoMes
GROUP BY Mes;

