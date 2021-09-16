/****************************************************************************************
* Purppose: Calculate median wire transaction amount for each of the cohorts
* Universtiy Name: Utica College
* Course Name: DSC-680-Z1 Research Practicum
* Student Name: Henry J. Hu
* Program Director Name: Dr. McCarthy, Michael
* Last Upate: August 5th, 2021   
*****************************************************************************************/

/** 1st Method **/
SELECT DISTINCT 
T2.[CONTINENT_CODE],
T2.[SWIFT MSG TYPE],
T2.[TRXN_MONTH],
MAX(T2.[TRANSACTION AMOUNT]) [AVG_TRXN_AMT]
--INTO AVG_TEMP
FROM
(
	SELECT [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH], MIN(AMOUNT_RANK) AMOUNT_RANK_MIN, MAX(AMOUNT_RANK) AMOUNT_RANK_MAX
	FROM
	(
		SELECT	[CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH],CONVERT(REAL,[TRANSACTION AMOUNT]) [TRANSACTION AMOUNT], 
				DENSE_RANK() OVER (PARTITION BY [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH]  ORDER BY CONVERT(REAL,[TRANSACTION AMOUNT]) DESC) AS AMOUNT_RANK
		FROM   [DSC-680].[DBO].[MERGE_FINAL_FINAL] 
	) T
	GROUP BY [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH]
) T1,
(
	SELECT	[CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH],CONVERT(REAL,[TRANSACTION AMOUNT]) [TRANSACTION AMOUNT], 
			DENSE_RANK() OVER (PARTITION BY [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH]  ORDER BY CONVERT(REAL,[TRANSACTION AMOUNT]) DESC) AS AMOUNT_RANK
	FROM	[DSC-680].[DBO].[MERGE_FINAL_FINAL] 
	WHERE	[NUMBER OF CLIENT]=1 AND [TRXN_YEAR]='2020'  
) T2
WHERE	T1.[CONTINENT_CODE] = T2.[CONTINENT_CODE]
	AND T1.[SWIFT MSG TYPE] = T2.[SWIFT MSG TYPE]
	AND T1.[TRXN_MONTH] = T2.[TRXN_MONTH]
	AND T2.AMOUNT_RANK BETWEEN ((T1.AMOUNT_RANK_MAX)/2) AND (((T1.AMOUNT_RANK_MAX)/2)+10) 
group by
T2.[CONTINENT_CODE],
T2.[SWIFT MSG TYPE],
T2.[TRXN_MONTH]


/** 2nd Method **/
SELECT DISTINCT 
T2.[CONTINENT_CODE],
T2.[SWIFT MSG TYPE],
T2.[TRXN_MONTH],
MAX(T2.[TRANSACTION AMOUNT]) [AVG_TRXN_AMT]
--INTO AVG_TEMP
FROM
(
	SELECT [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH], MIN(AMOUNT_RANK) AMOUNT_RANK_MIN, MAX(AMOUNT_RANK) AMOUNT_RANK_MAX
	FROM
	(
		SELECT	[CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH],CONVERT(REAL,[TRANSACTION AMOUNT]) [TRANSACTION AMOUNT], 
				DENSE_RANK() OVER (PARTITION BY [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH]  ORDER BY CONVERT(REAL,[TRANSACTION AMOUNT]) ASC) AS AMOUNT_RANK
		FROM   [DSC-680].[DBO].[MERGE_FINAL_FINAL] 
	) T
	GROUP BY [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH]
) T1,
(
	SELECT	[CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH],CONVERT(REAL,[TRANSACTION AMOUNT]) [TRANSACTION AMOUNT], 
			DENSE_RANK() OVER (PARTITION BY [CONTINENT_CODE],[SWIFT MSG TYPE],[TRXN_MONTH]  ORDER BY CONVERT(REAL,[TRANSACTION AMOUNT]) ASC) AS AMOUNT_RANK
	FROM	[DSC-680].[DBO].[MERGE_FINAL_FINAL] 
	WHERE	[NUMBER OF CLIENT]=1 AND [TRXN_YEAR]='2020'  
) T2
WHERE	T1.[CONTINENT_CODE] = T2.[CONTINENT_CODE]
	AND T1.[SWIFT MSG TYPE] = T2.[SWIFT MSG TYPE]
	AND T1.[TRXN_MONTH] = T2.[TRXN_MONTH]
	AND T2.AMOUNT_RANK BETWEEN  T1.AMOUNT_RANK_MIN AND ((T1.AMOUNT_RANK_MAX)/2)
group by
T2.[CONTINENT_CODE],
T2.[SWIFT MSG TYPE],
T2.[TRXN_MONTH]
