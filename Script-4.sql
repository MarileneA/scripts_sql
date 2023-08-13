--Descrição dos dados
-- Imp_veiculo
SELECT
	ROUND( MIN(imp_veiculo),2) as vlr_min_veic,
	ROUND( MAX(imp_veiculo),2) as vlr_max_veic,
	ROUND( AVG(imp_veiculo),2) as media
FROM seguro s 

--Impo_veiculo por regiao
SELECT
	Regiao,
	ROUND( MIN(imp_veiculo),2) as vlr_min_veic,
	ROUND( MAX(imp_veiculo),2) as vlr_max_veic,
	ROUND( AVG(imp_veiculo),2) as media
FROM seguro s
Group BY Regiao


-- Analise Quantidade de QtdSinistros 

SELECT
	MIN(QtdSinistros) as vlr_min_veic,
	MAX(QtdSinistros) as vlr_max_veic,
	ROUND(AVG(QtdSinistros),2) as media
FROM seguro s

-- Analise Quantidade de QtdSinistros por regiao

SELECT
	Regiao,
	MIN(QtdSinistros) as vlr_min_veic,
	MAX(QtdSinistros) as vlr_max_veic,
	ROUND(AVG(QtdSinistros),2) as media
FROM seguro s
group by Regiao 



-- Analise valor da Indenização 

SELECT
	MIN(VlrIndenizacao) as vlr_min_veic,
	MAX(VlrIndenizacao) as vlr_max_veic,
	ROUND(AVG(VlrIndenizacao),2) as media
FROM seguro s
 
-- Analise valor da Indenização por região

SELECT
	Regiao,
	MIN(VlrIndenizacao) as vlr_min_veic,
	MAX(VlrIndenizacao) as vlr_max_veic,
	ROUND(AVG(VlrIndenizacao),2) as media
FROM seguro s
GROUP BY Regiao

-- ANalise da Categoria
SELECT 
	Categoria, 
	COUNT(*) AS TotalOcorrencias
FROM seguro s 
GROUP BY categoria
ORDER BY TotalOcorrencias DESC;

SELECT 
	Categoria, 
	ROUND(COUNT(*),2) AS TotalSinistros, 
	ROUND(SUM(VlrIndenizacao),2) AS TotalIndenizacoes
FROM Seguro s
WHERE VlrIndenizacao > 0
GROUP BY categoria
ORDER BY TotalIndenizacoes DESC;


--Análise da relação entre categoria e indenizações por mês:

SELECT 
	Categoria, 
	strftime('%m', Data) AS Mes, 
	COUNT(*) AS TotalSinistros, 
	ROUND(SUM(VlrIndenizacao),2) AS TotalIndenizacoes
FROM seguro s 
WHERE VlrIndenizacao > 0
GROUP BY categoria, Mes, strftime('%m', Data)
ORDER BY categoria, strftime('%m', Data);


-- REgiao

SELECT 
    Regiao ,
    Categoria, 
    strftime('%Y-%m', Data) AS AnoMes, 
    COUNT(*) AS TotalSinistros, 
    ROUND(SUM(VlrIndenizacao), 2) AS TotalIndenizacoes
FROM seguro s 
WHERE VlrIndenizacao > 0
GROUP BY Regiao, Categoria, strftime('%Y-%m', Data)
ORDER BY Regiao, Categoria, strftime('%Y-%m', Data);


SELECT 
    Categoria, 
    strftime('%Y-%m', Data) AS AnoMes, 
    COUNT(*) AS TotalSinistros, 
    ROUND(SUM(VlrIndenizacao), 2) AS TotalIndenizacoes
FROM seguro s 
WHERE VlrIndenizacao > 0
GROUP BY Categoria, strftime('%Y-%m', Data)
ORDER BY Categoria, strftime('%Y-%m', Data);


--
SELECT 
	Categoria, 
	strftime('%Y-%m', Data) AS AnoMes, 
	COUNT(*) AS TotalOcorrencias
FROM seguro s
WHERE VlrIndenizacao >0
GROUP BY categoria, strftime('%Y-%m', Data)
ORDER BY categoria, strftime('%Y-%m', Data);



SELECT 
	Categoria,
	COUNT( Categoria)
FROM seguro s 
having Categoria 


SELECT 
Regiao,
COUNT(NroApolice) as qtde_apolices_regiao,
ROUND(AVG(VlrPremio),2) as avg_premio_regiao,
Round(AVG(VlrIndenizacao),2) as avg_ind_regiao
FROM seguro
WHERE VlrIndenizacao > 0
GROUP By Regiao 

-- Qual o maior valor de veiculo de preço entre todos os pedidos?
-- O maior valor de matrícula
SELECT
MAX( imp_veiculo  )as vlr_max_veic,
MIN(imp_veiculo) as vlr_min_veic
FROM seguro s 



SELECT 
    Regiao ,
    Categoria,
    SUM(CASE WHEN VlrIndenizacao > 0 THEN 1 ELSE 0 END) AS TotalSinistros,
    COUNT(*) AS TotalApólices,
    ROUND(SUM(VlrIndenizacao) / SUM(VlrPremio) * 100, 2) AS EfetividadeCobertura
FROM seguro
GROUP BY Regiao, Categoria
ORDER BY Regiao, Categoria;