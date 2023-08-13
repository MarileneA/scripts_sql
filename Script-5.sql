-- 1. Analise exploratória dos dados


-- Contar registros na tabela
SELECT 
	COUNT(DISTINCT NroApolice) AS TotalRegistros 
FROM seguro;
--Total: 36.886

-- Criação uma função para ter um PanoramaGeral
CREATE PROCEDURE PanoramaGeral AS
BEGIN
    -- Contagem total de registros
    SELECT COUNT(*) AS TotalRegistros FROM seguro;

    -- Média e valores máximo e mínimo das colunas VlrIndenizacao, VlrPremio e IS
    SELECT
        ROUND( AVG(VlrIndenizacao),2) AS MediaIndenizacao,
        ROUND( MAX(VlrIndenizacao),2) AS MaxIndenizacao,
        ROUND( MIN(VlrIndenizacao),2) AS MinIndenizacao,
        ROUND(AVG(VlrPremio),2) AS MediaPremio,
        ROUND( MAX(VlrPremio),2) AS MaxPremio,
        ROUND( MIN(VlrPremio),2) AS MinPremio,
        ROUND( AVG(imp_veiculo),2) AS MediaIS,
        ROUND( MAX(imp_veiculo),2) AS MaxIS,
        ROUND( MIN(imp_veiculo),2) AS MinIS
    FROM seguro;
END;


-- Verificar se tem valores nulos
SELECT 
	COUNT(*) AS TotalLinhasComValoresNulosOuEmBranco
FROM seguro
WHERE 
    Regiao IS NULL OR Regiao = '' OR
    Produto IS NULL OR Produto = '' OR
    NroApolice IS NULL OR NroApolice = '' OR
    NroItem IS NULL OR NroItem = '' OR
    Data IS NULL OR Data = '' OR
    categoria IS NULL OR categoria = '' OR
    imp_veiculo  IS NULL OR
    VlrPremio IS NULL OR
    QtdSinistros IS NULL OR
    VlrIndenizacao IS NULL;
   
   
   
-- Analisando a coluna IS com valor zero
SELECT 
    *,
    CASE WHEN VlrIndenizacao = 0 THEN 1 ELSE 0 END AS IsVlrIndenizacaoZero,
    CASE WHEN VlrPremio = 0 THEN 1 ELSE 0 END AS IsVlrPremioZero,
    CASE WHEN QtdSinistros = 0 THEN 1 ELSE 0 END AS IsQtdSinistrosZero,
    CASE WHEN VlrIndenizacao = 0 AND VlrPremio = 0 AND QtdSinistros = 0 THEN 1 ELSE 0 END AS IsAllZero
FROM seguro
WHERE imp_veiculo  = 0;


--Contando quantas Linhas estão com valor =0
SELECT 
	COUNT(*) AS TotalVeiculosZerados
FROM seguro
WHERE imp_veiculo  = 0;

--  Analisar a coluna "VlrPremio" que possui valores negativos.
SELECT
	COUNT(*) AS ValoresNegativos
FROM seguro
WHERE VlrPremio < 0;

-- Analisar se os valores negativos fazem parte da coluna IS com valores zerados
SELECT
    COUNT(*) AS TotalVlrpremioNegativoeISzerado
FROM seguro
WHERE VlrPremio < 0 AND imp_veiculo  <= 0;

--Categoria 
SELECT 
    Categoria, 
    COUNT(*) AS TotalOcorrencias,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Representatividade
FROM seguro
GROUP BY Categoria
ORDER BY TotalOcorrencias DESC;


---
-- Análise de Sinistros e Indenizações por Categoria
SELECT 
    Categoria,
    COUNT(*) AS TotalSeguros,
    COUNT(CASE WHEN QtdSinistros > 0 THEN 1 END) AS TotalSegurosComSinistros,
    COUNT(CASE WHEN VlrIndenizacao > 0 THEN 1 END) AS TotalSegurosComIndenizacao
FROM seguro
GROUP BY Categoria
ORDER BY TotalSegurosComIndenizacao DESC;

----
-- Análise da coluna Produtos
SELECT 
    Produto,
    ROUND(SUM(VlrPremio),2) as Total_premio_produto, 
    ROUND(SUM(VlrIndenizacao),2) as Total_ind_por_produto,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM seguro), 2) AS RepresProduto,
    COUNT(CASE WHEN Regiao = 'Bancos' THEN 1 END) AS QtdTotal_Bancos,
    COUNT(CASE WHEN Regiao = 'Sicoob' THEN 1 END) AS QtdTotal_Sicoob,
    COUNT(CASE WHEN Regiao = 'Banrisul' THEN 1 END) AS QtdTotal_Banrisul
FROM seguro
GROUP BY Produto
ORDER BY Produto DESC;
-------------
----Total de clientes por Região
SELECT 
    Regiao,
    COUNT(*) AS TotalClientes,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM seguro), 2) AS Representatividade
FROM seguro
GROUP BY Regiao
ORDER BY TotalClientes DESC;


-- Analisar o Premio, total de seguros, o valor total dos prêmios pagos e o valor total das indenizações recebidas para cada produto em cada região.
--SELECT 
--    Regiao,
--    Produto,
--    COUNT(*) AS TotalSeguros,
--    ROUND(SUM(VlrPremio), 2) AS TotalPremios,
--    ROUND(SUM(VlrIndenizacao), 2) AS TotalIndenizacoes
--FROM seguro
--GROUP BY Regiao, Produto
--ORDER BY Regiao, TotalPremios DESC;


-- Análise de Sinistros por Produto e Região:
SELECT 
    Regiao,
    Produto,
    COUNT(CASE WHEN QtdSinistros > 0 THEN 1 END) AS TotalSegurosComSinistros,
    COUNT(CASE WHEN VlrIndenizacao > 0 THEN 1 END) AS TotalSegurosComIndenizacao
FROM seguro
GROUP BY Regiao, Produto
ORDER BY TotalSegurosComSinistros DESC;


-- Análise por mes por região
SELECT 
    Regiao,
    strftime('%m', Data) AS Mes,
    COUNT(*) AS TotalSeguros,
    ROUND(SUM(VlrPremio), 2) AS TotalPremios,
    ROUND(SUM(VlrIndenizacao), 2) AS TotalIndenizacoes
FROM seguro
WHERE VlrIndenizacao > 0 AND VlrPremio > 0
GROUP BY Mes, Regiao, strftime('%m', Data)
ORDER BY Regiao, strftime('%m', Data);




-- Premio
SELECT 
    Regiao,
    Produto,
    COUNT(CASE WHEN VlrPremio > 0 THEN 1 END) AS TotalSegurosComPremio,
    ROUND(SUM(CASE WHEN VlrPremio > 0 THEN VlrPremio END), 2) AS TotalPremios,
    COUNT(CASE WHEN VlrIndenizacao > 0 THEN 1 END) AS TotalSegurosComIndenizacao,
    ROUND(SUM(CASE WHEN VlrIndenizacao > 0 THEN VlrIndenizacao END), 2) AS TotalIndenizacoes
FROM seguro
WHERE VlrPremio > 0 OR VlrIndenizacao > 0
GROUP BY Regiao, Produto
ORDER BY Regiao, Produto;

SELECT *
FROM seguro s
WHERE NroApolice =1103431000389



-- médio do Premio
SELECT 
    ROUND(SUM(VlrPremio) / COUNT(*), 2) AS PremioMedio
FROM seguro
WHERE VlrPremio > 0;

--Valor do Premio por Região

SELECT 
    Regiao,
    COUNT(*) AS QuantidadeItens,
    ROUND(SUM(VlrPremio), 2) AS PremioTotal,
    ROUND(AVG(VlrPremio), 2) AS PremioMedioPorRegiao,
    Round(AVG(VlrIndenizacao),2) AS ValorMaximoIndenizacao
FROM seguro
WHERE VlrPremio > 0
GROUP BY Regiao;

-- Analissando o premio por região e por Mês
SELECT 
    Regiao,
    strftime('%m', Data) AS Mes,
    COUNT(*) AS QuantidadeItens,
    ROUND(SUM(VlrPremio) / COUNT(*), 2) AS PremioMedio
FROM seguro
WHERE Regiao = 'Bancos'
GROUP BY Regiao, Mes
ORDER BY Mes;


-- Análise por região
SELECT 
    Regiao,
    sum(QtdSinistros) as TotalSinistros,
    ROUND(SUM(VlrPremio),2) AS ValorTotalPremios,
    ROUND(SUM(VlrIndenizacao),2) AS ValorTotalInd,
    Round(SUM(imp_veiculo), 2) AS imp_veiculo
FROM seguro
GROUP BY Regiao;

-- Consulta para analisar o valor das apólices da região "Bancos"
SELECT 
    Regiao,
    NroApolice,
    VlrPremio
FROM seguro
WHERE Regiao = 'Bancos'
ORDER BY VlrPremio DESC;

-- Consulta para encontrar o valor máximo de indenização na região "Bancos"
SELECT 
    Regiao,
    MAX(imp_veiculo) As imp_veiculo,  
    Max(VlrPremio) ValorTotalPremio,
    MAX(VlrIndenizacao) AS ValorMaximoIndenizacao
FROM seguro
Group BY Regiao;


-- Custo Médio
SELECT
    ROUND( SUM(VlrIndenizacao) / SUM(QtdSinistros),2) AS CustoMediototal
FROM seguro;


-- calcular o Custo médio por região
SELECT
    Regiao ,
    ROUND( SUM(VlrIndenizacao) / SUM(QtdSinistros),2) AS CustoMedio
FROM seguro
GROUP BY Regiao;

-- FRequencia
-- Consulta para calcular a Frequência por região
SELECT 
    Regiao,
    COUNT(QtdSinistros) AS FrequenciaSinistros,
    COUNT(QtdSinistros) / COUNT(QtdSinistros)  AS Frequencia
FROM seguro
GROUP BY Regiao;


- Consulta para analisar o aumento ou queda no custo médio mês a mês por filial

WITH PremioMedioPorRegiao AS (
    SELECT 
        Regiao,
        strftime('%m', Data) AS Mes,
        COUNT(*) AS QuantidadeItens,
        ROUND(SUM(VlrPremio), 2) AS PremioTotal,
        ROUND(AVG(VlrPremio), 2) AS PremioMedio
    FROM seguro
    WHERE VlrPremio > 0 
    GROUP BY Regiao, strftime('%m', Data)
)
SELECT
    RegiaoAtual.Regiao,
    RegiaoAtual.Mes AS MesAtual,
    RegiaoAtual.PremioMedio AS PremioMedioAtual,
    RegiaoAnterior.Mes AS MesAnterior,
    RegiaoAnterior.PremioMedio AS PremioMedioAnterior,
    CASE
        WHEN RegiaoAtual.PremioMedio > RegiaoAnterior.PremioMedio THEN "Aumento"
        WHEN RegiaoAtual.PremioMedio < RegiaoAnterior.PremioMedio THEN "Queda"
        ELSE '-'
    END AS Tendencia
FROM PremioMedioPorRegiao RegiaoAtual
LEFT JOIN PremioMedioPorRegiao RegiaoAnterior ON RegiaoAtual.Regiao = RegiaoAnterior.Regiao
    AND CAST(RegiaoAtual.Mes AS INTEGER) = CAST(RegiaoAnterior.Mes AS INTEGER) + 1;
    
   
   
 -----------------------------************------------------------------------  
   -- Banrisul
SELECT 
    strftime('%m', Data) AS Mes,
    ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) AS PremioMedio,
    LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) AS PremioMedioAnterior,
    CASE
        WHEN ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) > LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Aumento'
        WHEN ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) < LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM seguro
WHERE VlrPremio > 0 AND Regiao = 'Banrisul'
GROUP BY strftime('%m', Data);

-----------------------------************------------------------------------  
   -- Sicoob
SELECT 
    strftime('%m', Data) AS Mes,
    ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) AS PremioMedio,
    LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) AS PremioMedioAnterior,
    CASE
        WHEN ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) > LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Aumento'
        WHEN ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) < LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM seguro
WHERE VlrPremio > 0 AND Regiao = 'Sicoob'
GROUP BY strftime('%m', Data);

-----------------------------************------------------------------------  
  --Bancos
SELECT 
    strftime('%m', Data) AS Mes,
    ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) AS PremioMedio,
    LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) AS PremioMedioAnterior,
    CASE
        WHEN ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) > LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Aumento'
        WHEN ROUND(SUM(VlrPremio) / COUNT(NroItem), 2) < LAG(ROUND(SUM(VlrPremio) / COUNT(NroItem), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM seguro
WHERE VlrPremio > 0 AND Regiao = 'Bancos'
GROUP BY strftime('%m', Data);




-----------------------------***---------------------------------
-- Frequencia
SELECT 
    Regiao,
    SUM(QtdSinistros) AS TotalSinistros,
    COUNT(NroItem) AS TotalItens,
    ROUND( CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT),2)AS Frequencia
FROM seguro
GROUP BY Regiao;

------------------------*************************
-- Calcular a frequência mensal (sinistros por item) e criar uma tabela temporária

CREATE TEMP TABLE temp_frequencias AS
SELECT
    strftime('%Y-%m', Data) AS Mes,
    COUNT(*) AS QtdItens,
    SUM(QtdSinistros) AS QtdSinistros,
    AVG(CAST(QtdSinistros AS FLOAT) / CAST(NroItem AS FLOAT)) AS FrequenciaMensal
FROM seguro
GROUP BY Mes;
SELECT
    Mes,
    QtdItens,
    QtdSinistros,
    FrequenciaMensal,
    (FrequenciaMensal - LAG(FrequenciaMensal) OVER (ORDER BY Mes)) / LAG(FrequenciaMensal) OVER (ORDER BY Mes) AS Tendencia
FROM temp_frequencia;

------------------------------------******************************
-- Calcular a frequência mensal (sinistros por item) e criar uma tabela temporária


--Por Produto
-- Calcular a frequência mensal (sinistros por item) e criar uma tabela temporária para cada região

----------------------------------------

-- Calcular a tendência de alta ou queda mensal usando a função de janela
SELECT
    Mes,
    QtdItens,
    QtdSinistros,
    FrequenciaMensal,
    (FrequenciaMensal - LAG(FrequenciaMensal) OVER (ORDER BY Mes)) / LAG(FrequenciaMensal) OVER (ORDER BY Mes) AS Tendencia
FROM temp_frequencia;


----*******************************************************
-- Calcular a frequência mensal (sinistros por item) e criar uma tabela temporária para cada produto

----************
---Frequencia temporari
-- Criar uma tabela temporária com todas as combinações possíveis de Produto e Mes


-- Frequencia por mes
SELECT 
    Produto,
    strftime('%m', Data) AS Mes,
    SUM(QtdSinistros) AS TotalSinistros,
    COUNT(NroItem) AS TotalItens,
    CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT) AS Frequencia
FROM seguro
GROUP BY Produto, strftime('%m', Data)
ORDER BY Produto, strftime('%m', Data);



-----Frequencia por Produto
e
-- Criar uma tabela temporária com todas as combinações possíveis de Produto e Mes para o produto "430"
CREATE TEMP TABLE temp_combinacoes_430 AS
SELECT DISTINCT strftime('%Y-%m', Data) AS Mes
FROM seguro
WHERE NroProduto = 430;

-- Calcular a frequência mensal (sinistros por item) e criar uma tabela temporária para o produto "430"
CREATE TEMP TABLE temp_frequencia_430 AS
SELECT
    strftime('%Y-%m', seguro.Data) AS Mes,
    COUNT(seguro.NroItem) AS QtdItens,
    SUM(seguro.QtdSinistros) AS QtdSinistros,
    AVG(CAST(seguro.QtdSinistros AS FLOAT) / CAST(seguro.NroItem AS FLOAT)) AS FrequenciaMensal
FROM seguro
WHERE NroProduto = 430
GROUP BY Mes;

-- Calcular a tendência de alta ou queda mensal para o produto "430" usando a função de janela
CREATE TEMP TABLE tabela_tendencia_430 AS
SELECT
    Mes,
    QtdItens,
    QtdSinistros,
    FrequenciaMensal,
    (FrequenciaMensal - LAG(FrequenciaMensal) OVER (ORDER BY Mes)) / LAG(FrequenciaMensal) OVER (ORDER BY Mes) AS Tendencia
FROM temp_frequencia_430;

-- Exibir a tabela de tendência para o produto "430"
SELECT * FROM tabela_tendencia_430;

-- Calcular a tendência de alta ou queda mensal para o produto "430" usando a função de janela
CREATE TEMP TABLE tabela_tendencia_430 AS
SELECT
    Mes,
    QtdItens,
    QtdSinistros,
    FrequenciaMensal,
    (FrequenciaMensal - LAG(FrequenciaMensal) OVER (ORDER BY Mes)) / LAG(FrequenciaMensal) OVER (ORDER BY Mes) AS Tendencia
FROM temp_frequencia_430;

-- Exibir a tabela de tendência para o produto "430"
SELECT * FROM tabela_tendencia_430;



-----------------------------------------------------------------------------------
SELECT 
    Produto,
    strftime('%m', Data) AS Mes,
    SUM(QtdSinistros) AS TotalSinistros,
    COUNT(NroItem) AS TotalItens,
    CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT) AS Frequencia
FROM seguro
WHERE Produto = 436
GROUP BY Produto, strftime('%m', Data)
ORDER BY Produto, strftime('%m', Data);

--------------------*******************--------------------
SELECT 
    Produto,
    strftime('%m', Data) AS Mes,
    SUM(QtdSinistros) AS TotalSinistros,
    COUNT(NroItem) AS TotalItens,
    CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT) AS Frequencia
FROM seguro
WHERE Produto = 436
GROUP BY Produto, strftime('%m', Data)
ORDER BY Produto, strftime('%m', Data);

---------------------******************
SELECT 
    Produto,
    strftime('%m', Data) AS Mes,
    SUM(QtdSinistros) AS TotalSinistros,
    COUNT(NroItem) AS TotalItens,
    ROUND(CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT),4) AS Frequencia
FROM seguro
WHERE Produto = 431
GROUP BY Produto, strftime('%m', Data)
ORDER BY Produto, strftime('%m', Data);

---*********************----------------------
WITH CTE AS (
    SELECT 
        Produto,
        strftime('%m', Data) AS Mes,
        SUM(QtdSinistros) AS TotalSinistros,
        ROUND( COUNT (NroItem),2) AS TotalItens,
        ROUND(CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT), 2) AS Frequencia,
        LAG(ROUND(CAST(SUM(QtdSinistros) AS FLOAT) / CAST(COUNT(NroItem) AS FLOAT), 2), 1, 0) 
        OVER (PARTITION BY Produto ORDER BY strftime('%m', Data)) AS FrequenciaAnterior
    FROM seguro
    WHERE Produto = 431 AND VlrIndenizacao > 0
    GROUP BY Produto, strftime('%m', Data)
)
SELECT 
    Produto,
    Mes,
    TotalSinistros,
    TotalItens,
    Frequencia,
    FrequenciaAnterior,
    ROUND(Frequencia - FrequenciaAnterior, 2) AS DiferencaMesAnterior,
    CASE
        WHEN Frequencia > FrequenciaAnterior THEN 'Aumento'
        WHEN Frequencia < FrequenciaAnterior THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM CTE
ORDER BY Produto, Mes;


---***Table
select*
FROM seguro s 

--Qual região vendeu mais por mês.
SELECT
    strftime('%m', Data) AS Mes,
    Regiao,
    COUNT(DISTINCT NroApolice) AS TotalApolices
FROM seguro
GROUP BY strftime('%m', Data), Regiao
ORDER BY Mes, TotalApolices DESC;


SELECT
    Regiao,
    strftime('%Y-%m', Data) AS Mes,
    COUNT(NroApolice) AS QuantidadeApolices
FROM seguro
WHERE Regiao IN ('Bancos', 'Banrisul', 'Sicoob')
GROUP BY Regiao, Mes;

---------------------------------
SELECT
    Regiao,
    SUM(QuantidadeApolices) AS TotalApolices
FROM (
    SELECT
        Regiao,
        COUNT(NroApolice) AS QuantidadeApolices
    FROM seguro
    WHERE Regiao IN ('Bancos', 'Banrisul', 'Sicoob')
    GROUP BY Regiao
) AS vendas_por_regiao
GROUP BY Regiao;
--------------------------

-- CTE com todos os produtos
WITH produtos AS (
    SELECT DISTINCT Produto
    FROM seguro
    WHERE Produto IN (430, 331, 436)
)
-- CTE com todos os meses
, meses AS (
    SELECT DISTINCT strftime('%Y-%m', Data) AS Mes
    FROM seguro
    -- Aqui você pode adicionar uma cláusula WHERE para filtrar os meses desejados
)
-- CROSS JOIN para combinar todos os produtos com todos os meses
, combinacoes AS (
    SELECT
        p.Produto,
        m.Mes
    FROM produtos p
    CROSS JOIN meses m
)
-- LEFT JOIN com a tabela "seguro" para obter a quantidade de apólices por combinação produto-mês
SELECT
    c.Produto,
    c.Mes,
    COUNT(s.NroApolice) AS QuantidadeApolices
FROM combinacoes c
LEFT JOIN seguro s ON c.Produto = s.Produto AND c.Mes = strftime('%Y-%m', s.Data)
GROUP BY c.Produto, c.Mes
ORDER BY c.Produto, c.Mes;
-------------------

SELECT
-- CTE com todos os produtos
-- Criar tabela temporária com os 12 meses distintos da tabela "seguro"
CREATE TEMP TABLE temp_meses AS
SELECT DISTINCT strftime('%Y-%m', Data) AS Mes
FROM seguro
ORDER BY Mes;

-- CROSS JOIN entre os produtos e a tabela temporária dos meses
SELECT
    p.Produto,
    m.Mes,
    COUNT(s.NroApolice) AS QuantidadeApolices
FROM (SELECT DISTINCT Produto FROM seguro WHERE Produto IN (430, 331, 436)) p
CROSS JOIN temp_meses m
LEFT JOIN seguro s ON p.Produto = s.Produto AND m.Mes = strftime('%Y-%m', s.Data)
GROUP BY p.Produto, m.Mes
ORDER BY p.Produto, m.Mes;

-- Drop da tabela temporária dos meses (opcional)
DROP TABLE IF EXISTS temp_meses;
----------------------------*************

-- Criar uma tabela temporária com os 12 meses distintos da tabela "seguro" para o produto "430"
CREATE TEMP TABLE temp_meses_430 AS
SELECT DISTINCT strftime('%Y-%m', Data) AS Mes
FROM seguro
WHERE Produto = 430
ORDER BY Mes;

-- CROSS JOIN entre o produto "430" e a tabela temporária dos meses
SELECT
    430 AS Produto,
    m.Mes,
    COUNT(s.NroApolice) AS QuantidadeApolices
FROM temp_meses_430 m
LEFT JOIN seguro s ON 430 = s.Produto AND m.Mes = strftime('%Y-%m', s.Data)
GROUP BY Produto, m.Mes
ORDER BY Produto, m.Mes;

-- Drop da tabela temporária dos meses para o produto "430" (opcional)
DROP TABLE IF EXISTS temp_meses_430;



------**********
--QUal o produto mais vendido por Mês
SELECT
    Mes,
    Produto,
    MAX(QuantidadeApolices) AS MaxQuantidadeApolices
FROM (
    SELECT
        strftime('%Y-%m', Data) AS Mes,
        Produto,
        COUNT(NroApolice) AS QuantidadeApolices
    FROM seguro
    GROUP BY Mes, Produto
) AS vendas_por_mes_produto
GROUP BY Mes;

-----
WITH vendas_por_mes_produto AS (
    SELECT
        strftime('%Y-%m', Data) AS Mes,
        Produto,
        COUNT(NroApolice) AS QuantidadeApolices
    FROM seguro
    GROUP BY Mes, Produto
),
ranked_vendas AS (
    SELECT
        Mes,
        Produto,
        QuantidadeApolices,
        RANK() OVER (PARTITION BY Mes ORDER BY QuantidadeApolices DESC) AS RankMaisVendido
    FROM vendas_por_mes_produto
)
SELECT
    Mes,
    Produto,
    QuantidadeApolices
FROM ranked_vendas
WHERE RankMaisVendido = 1;

----------------
-- Criar a tabela temporária com os meses e a coluna "Data" convertida para o tipo datetime
CREATE TEMP TABLE temp_mes AS
SELECT
    *,
    strftime('%Y-%m', Data) AS Mes
FROM seguro;

-- Agrupar os dados por produto e mês e calcular a quantidade de produto (número de apólices) por mês
SELECT
    Produto,
    Mes,
    COUNT(*) AS QuantidadeProduto
FROM temp_meses
GROUP BY Produto, Mes
ORDER BY Produto, Mes;



-- Drop da tabela temporária dos meses (opcional)
DROP TABLE IF EXISTS temp_meses;
-- Drop da tabela temporária dos meses (opcional)
DROP TABLE IF EXISTS temp_meses;






-----------***************

SELECT
    Mes,
    MAX(CASE WHEN Regiao = 'Banrisul' THEN TotalApolices ELSE 0 END) AS Banrisul,
    MAX(CASE WHEN Regiao = 'Bancos' THEN TotalApolices ELSE 0 END) AS Bancos,
    MAX(CASE WHEN Regiao = 'Sicoob' THEN TotalApolices ELSE 0 END) AS Sicoob
FROM (
    SELECT
        strftime('%m', Data) AS Mes,
        Regiao,
        COUNT(DISTINCT NroApolice) AS TotalApolices
    FROM seguro
    GROUP BY strftime('%m', Data), Regiao
) AS dados_agrupados
GROUP BY Mes
ORDER BY Mes;


-- Cálculo do custo médio por mês por região
  --Bancos
SELECT 
    strftime('%m', Data) AS Mes,
    ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2) AS CustoMedio,
    LAG(ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2)) OVER (ORDER BY strftime('%m', Data)) AS CustoMedioAnterior,
    CASE
        WHEN ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2) > LAG(ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Aumento'
        WHEN ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2) < LAG(ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM seguro
WHERE VlrIndenizacao  > 0 AND Regiao = 'Bancos'
GROUP BY strftime('%m', Data);


  --Sicoob
SELECT 
    strftime('%m', Data) AS Mes,
    ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2) AS CustoMedio,
    LAG(ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2)) OVER (ORDER BY strftime('%m', Data)) AS CustoMedioAnterior,
    CASE
        WHEN ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2) > LAG(ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Aumento'
        WHEN ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2) < LAG(ROUND(SUM(VlrIndenizacao) / COUNT(QtdSinistros), 2)) OVER (ORDER BY strftime('%m', Data)) THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM seguro
WHERE VlrIndenizacao  > 0 AND Regiao = 'Banrisul'
GROUP BY strftime('%m', Data);

-- Qual Produto apresenta queda ou aumento na frequência ao longo dos meses.

-- Produto 436
WITH CTE AS (
    SELECT 
        Produto,
        strftime('%m', Data) AS Mes,
        COUNT(QtdSinistros) / COUNT(NroItem) AS Frequencia,
        LAG(COUNT(QtdSinistros) / COUNT(NroItem), 1, 0) OVER (PARTITION BY Produto ORDER BY strftime('%m', Data)) AS FrequenciaAnterior
    FROM seguro
    WHERE VlrIndenizacao > 0 AND Produto IN (430, 431, 436)
    GROUP BY Produto, strftime('%m', Data)
)
SELECT 
    Produto,
    Mes,
    Frequencia,
    FrequenciaAnterior,
    ROUND(Frequencia - FrequenciaAnterior, 2) AS DiferencaMesAnterior,
    CASE
        WHEN Frequencia > FrequenciaAnterior THEN 'Aumento'
        WHEN Frequencia < FrequenciaAnterior THEN 'Queda'
        ELSE '-'
    END AS Tendencia
FROM CTE
ORDER BY Produto, Mes;

