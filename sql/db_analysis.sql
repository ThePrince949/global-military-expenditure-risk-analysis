


-------------------------------- Regional Analysis (Macro-Level) -------------------------------------



-- 1) Which regions have experienced the most significant military expenditure acceleration over time?

WITH RegionalYoY AS (
	SELECT
		ur.Region,
		rs.Year,
		rs.Value,
		LAG(rs.Value) OVER (                                                                     ---- LAG = look at previous rows values
			PARTITION BY ur.Region                                                               ---- i.e. Western Europe compares only to Western Europe
			ORDER BY rs.Year
		) AS Previous_Year_Spend
	FROM dbo.regional_spending as rs
	JOIN dbo.unique_regions as ur
		ON rs.RegionID = ur.RegionID
),

YoYCalculated AS (
	SELECT
		Region,
		Year,
		ROUND(
			((Value - Previous_Year_Spend) / NULLIF(CAST(Previous_Year_Spend AS FLOAT),0)) * 100, 3) AS YoY_Percent_Change
	FROM RegionalYoY
	WHERE Previous_Year_Spend IS NOT NULL
)


SELECT
	Region,
	ROUND(CAST(MAX(CASE WHEN Year = 2014 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2014],
	ROUND(CAST(MAX(CASE WHEN Year = 2015 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2015],
	ROUND(CAST(MAX(CASE WHEN Year = 2016 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2016],
	ROUND(CAST(MAX(CASE WHEN Year = 2017 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2017],
	ROUND(CAST(MAX(CASE WHEN Year = 2018 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2018],
	ROUND(CAST(MAX(CASE WHEN Year = 2019 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2019],
	ROUND(CAST(MAX(CASE WHEN Year = 2020 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2020],
	ROUND(CAST(MAX(CASE WHEN Year = 2021 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2021],
	ROUND(CAST(MAX(CASE WHEN Year = 2022 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2022],
	ROUND(CAST(MAX(CASE WHEN Year = 2023 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2023],
	ROUND(CAST(MAX(CASE WHEN Year = 2024 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2024]

FROM YoYCalculated
GROUP BY Region
ORDER BY Region;


-- 2) What regions demonstrate the highest levels of defence prioritization relative to economic output and government expenditure? 

WITH RegionAverages AS (
	SELECT 
		rs.Region,
		AVG(pg.Value / 100.0) as [Avg % of GDP],
		AVG(pgo.Value / 100.0) as [Avg % of Govt Spending]
	FROM dbo.regional_spending as rs
	INNER JOIN dbo.unique_regions as ur
		ON rs.RegionID = ur.RegionID
	INNER JOIN dbo.locationmaster as lm
		ON ur.RegionID = lm.RegionID
	INNER JOIN dbo.perc_gdp as pg
		ON lm.CountryID = pg.CountryID
	INNER JOIN dbo.perc_govt as pgo
		ON lm.CountryID = pgo.CountryID
		AND pg.Year = pgo.Year
	--WHERE pg.Year = 2024                                                      --For KPI in Power BI
	GROUP BY rs.Region
)


SELECT
	Region,
	[Avg % of GDP],
	[Avg % of Govt Spending]
FROM RegionAverages
ORDER BY [Avg % of GDP] DESC;


-- 3) Which subregions specifically are responsible for the military expenditure acceleration?

WITH SubRegionalYoY AS (
	SELECT
		us.SubRegion,
		ss.Year,
		ss.Value,
		LAG(ss.Value) OVER (
			PARTITION BY us.SubRegion
			ORDER BY ss.Year
		) AS Previous_Year_Spend
	FROM dbo.subregional_spending as ss
	INNER JOIN dbo.unique_subregions as us
		ON ss.SubRegionID = us.SubRegionID
),

YoYCalculated AS (
	SELECT
		SubRegion,
		Year,
		ROUND(
		((Value - Previous_Year_Spend) / NULLIF(CAST(Previous_Year_Spend AS FLOAT), 0)) * 100, 3) AS YoY_Percent_Change
	FROM SubRegionalYoY
	WHERE Previous_Year_Spend IS NOT NULL
)

SELECT
	SubRegion,
	ROUND(CAST(MAX(CASE WHEN Year = 2014 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2014],
	ROUND(CAST(MAX(CASE WHEN Year = 2015 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2015],
	ROUND(CAST(MAX(CASE WHEN Year = 2016 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2016],
	ROUND(CAST(MAX(CASE WHEN Year = 2017 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2017],
	ROUND(CAST(MAX(CASE WHEN Year = 2018 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2018],
	ROUND(CAST(MAX(CASE WHEN Year = 2019 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2019],
	ROUND(CAST(MAX(CASE WHEN Year = 2020 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2020],
	ROUND(CAST(MAX(CASE WHEN Year = 2021 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2021],
	ROUND(CAST(MAX(CASE WHEN Year = 2022 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2022],
	ROUND(CAST(MAX(CASE WHEN Year = 2023 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2023],
	ROUND(CAST(MAX(CASE WHEN Year = 2024 THEN YoY_Percent_Change END) / 100.0 AS FLOAT), 3) AS [2024]

FROM YoYCalculated
GROUP BY SubRegion
ORDER BY SubRegion;


-- 4) Which subregions demonstrate persistent long-term defense spending increases?

WITH SubRegionalYoY AS (
	SELECT
		us.SubRegion,
		ss.Year,
		ss.Value,
		LAG(ss.Value) OVER (
			PARTITION BY us.SubRegion
			ORDER BY ss.Year
		) AS Previous_Year_Spend
	FROM dbo.subregional_spending as ss
	INNER JOIN dbo.unique_subregions as us
		ON ss.SubRegionID = us.SubRegionID
),

YoYCalculated AS (
	SELECT
		SubRegion,
		Year,
		ROUND(
		((Value - Previous_Year_Spend) / NULLIF(CAST(Previous_Year_Spend AS FLOAT), 0)) * 100, 3) AS YoY_Percent_Change
	FROM SubRegionalYoY
	WHERE Previous_Year_Spend IS NOT NULL
),

SpendChange AS (
	SELECT
		SubRegion,
		MAX(CASE WHEN Year = 2014 THEN Value END) AS Spend_2014,
		MAX(CASE WHEN Year = 2024 THEN Value END) AS Spend_2024
	FROM SubRegionalYoY
	WHERE Year in (2014, 2024)
	GROUP BY SubRegion
)

SELECT
	y.SubRegion,
	SUM(CASE WHEN y.YoY_Percent_Change >= 0 THEN 1 ELSE 0 END) AS [Num Positive Growth Years],
	sc.Spend_2014,
	sc.Spend_2024,
	ROUND(
		((sc.Spend_2024 - sc.Spend_2014) / NULLIF(CAST(sc.Spend_2014 AS FLOAT), 0)),
		4
	) AS [10-Year % Change]
FROM YoYCalculated AS y
	INNER JOIN SpendChange AS sc
		ON y.SubRegion = sc.SubRegion
WHERE y.Year BETWEEN 2014 AND 2024
GROUP BY 
	y.SubRegion,
	sc.Spend_2014,
	sc.Spend_2024
ORDER BY
	[Num Positive Growth Years] DESC,
	[10-Year % Change] DESC;



-------------------------------- National Analysis (Micro-Level) -------------------------------------


-- 5) Which countries are spending an unusually high % of GDP on Military Expenditures?

 WITH FiveYearAvg AS (
	SELECT
		pg.Country,
		ROUND(AVG(CAST(pg.Value AS FLOAT)) / 100.0, 4) AS [Recent 5-Year Avg]
	FROM dbo.perc_gdp as pg
	WHERE pg.Year BETWEEN 2020 AND 2024
	GROUP BY pg.Country
)


SELECT
	gp.Country,
	ROUND(CAST(AVG(gp.Value) AS FLOAT) / 100.0, 4) AS [Historical AVG % GDP],
	[Recent 5-Year Avg],
	ROUND(([Recent 5-Year Avg] - (AVG(CAST(gp.Value AS FLOAT)) / 100.0)), 4) AS [Difference from Historical Avg]
FROM FiveYearAvg AS fya
JOIN dbo.perc_gdp AS gp
	ON fya.Country = gp.Country
GROUP BY 
	gp.Country,
	[Recent 5-Year Avg]
ORDER BY
	[Difference from Historical Avg] DESC;


-- 6) Which countries have demonstrated the most significant recent acceleration in military expenditure? (YoY change)

WITH CountryYoY AS (
	SELECT
		uc.Country,
		cs.Year,
		cs.Value AS [Current_Year_Spend],
		LAG(cs.Value) OVER (
			PARTITION BY uc.Country
			ORDER BY cs.Year
		) AS Previous_Year_Spend
	FROM dbo.current_spending as cs
	INNER JOIN dbo.unique_countries as uc
		ON cs.CountryID = uc.CountryID
	GROUP BY
		uc.Country,
		cs.Year,
		cs.Value
),

YoYCalculated AS (
	SELECT
		Country,
		Year,
		ROUND(((Current_Year_Spend - Previous_Year_Spend) / NULLIF(CAST(Previous_Year_Spend AS FLOAT), 0)), 3) AS YoY_Percent_Change 
	FROM CountryYoY
	WHERE Previous_Year_Spend IS NOT NULL
)

SELECT
	Country,
	ROUND(AVG(YoY_Percent_Change), 3) AS [Avg Recent YoY Growth],
	ROUND(MAX(YoY_Percent_Change), 3) AS [Max Recent YoY Growth],
	RANK() OVER (
		ORDER BY AVG(YoY_Percent_Change) DESC
	) AS Acceleration_Rank
FROM YoYCalculated
WHERE Year BETWEEN 2022 AND 2024
GROUP BY Country
ORDER BY [Avg Recent YoY Growth] DESC;


-- 7) How concentrated is global military expenditure among major powers?

 WITH TotalCurrentSpending AS (
	SELECT
		Year,
		SUM(Value) AS [Sum of Current Spending]
	FROM dbo.current_spending
	WHERE Year BETWEEN 2022 AND 2024
	GROUP BY
		Year
),

MajorPowerCurrentSpending AS (
	SELECT
		Year,
		SUM(Value) AS [Total Major Power Current Spend]
	FROM dbo.current_spending
	WHERE Year BETWEEN 2022 AND 2024
		  AND Country IN (
			'China',
			'France',
			'India',
			'Russia',
			'United Kingdom',
			'United States'
			)
	GROUP BY Year
)

SELECT
	tcs.Year,
	[Total Major Power Current Spend],
	[Sum of Current Spending],
	([Total Major Power Current Spend] / [Sum of Current Spending]) AS [Major Power Share %]
FROM TotalCurrentSpending AS tcs
JOIN MajorPowerCurrentSpending AS mpc 
	ON tcs.Year = mpc.Year




-------------------------------- NATO Analysis (Alliance-Level) -------------------------------------

-- 8) How has NATO compliance with the 2% GDP defense spending target evolved over time?

WITH CompliantCountries AS (
	SELECT
		Country,	
		Year,
		Value AS [% GDP]
	FROM dbo.perc_gdp 
	WHERE Value >= 0.20
		AND Country IN (	
		'Albania',
		'Belgium',
		'Bulgaria',
		'Canada',
		'Croatia',
		'Czech Republic',
		'Denmark',
		'Estonia',
		'Finland',
		'France',
		'Germany',
		'Greece',
		'Hungary',
		'Iceland',
		'Italy',
		'Latvia',
		'Lithuania',
		'Luxembourg',
		'Montenegro',
		'Netherlands',
		'North Macedonia',
		'Norway',
		'Poland',
		'Portugal',
		'Romania',
		'Slovakia',
		'Slovenia',
		'Spain',
		'Sweden',
		'Turkey',
		'United Kingdom',
		'United States'
		)
	GROUP BY 
		Country,
		Year,
		Value
) 

SELECT
	Year,
	COUNT(DISTINCT Country) AS [Compliant NATO Members],
	32 AS [Total NATO Members],
	ROUND(COUNT(DISTINCT Country) / 32.0, 2) AS [Compliance Rate %]
FROM CompliantCountries
GROUP BY Year
ORDER BY Year;


-- 9) Which NATO members had the highest average defence burden over the past 5 years?
 
SELECT
	Country,
	ROUND(AVG(CAST(Value AS FLOAT)) / 100.0, 4) as [Recent AVG % GDP]
FROM dbo.perc_gdp
WHERE Year BETWEEN 2020 AND 2024
		AND Country IN (
	'Albania',
	'Belgium',
	'Bulgaria',
	'Canada',
	'Croatia',
	'Czech Republic',
	'Denmark',
	'Estonia',
	'Finland',
	'France',
	'Germany',
	'Greece',
	'Hungary',
	'Iceland',
	'Italy',
	'Latvia',
	'Lithuania',
	'Luxembourg',
	'Montenegro',
	'Netherlands',
	'North Macedonia',
	'Norway',
	'Poland',
	'Portugal',
	'Romania',
	'Slovakia',
	'Slovenia',
	'Spain',
	'Sweden',
	'Turkey',
	'United Kingdom',
	'United States'
	)	
GROUP BY Country
ORDER BY [Recent AVG % GDP] DESC;


-- 10) How have Scandinavian defense spending patterns changed amid changing regional security dynamics?

 WITH RecentGovtAvg AS (
	SELECT
		Country,
		ROUND(AVG(CAST(Value AS FLOAT)) / 100.0, 4) AS [Recent % Govt Spend AVG]
	FROM dbo.perc_govt
	WHERE Year BETWEEN 2020 AND 2024
		  AND Country IN (
			'Denmark',
			'Finland',
			'Norway',
			'Sweden'
			)
	GROUP BY Country
),

RecentGDPAvg AS (
	SELECT
		Country,
		ROUND(AVG(CAST(Value AS FLOAT)) / 100.0, 4) AS [Recent % GDP AVG]
	FROM dbo.perc_gdp 
	WHERE Year BETWEEN 2020 AND 2024
		  AND Country IN (
			'Denmark',
			'Finland',
			'Norway',
			'Sweden'
			)
		GROUP BY Country
)

SELECT
	lm.Country,
	ROUND(AVG(CAST(pgo.Value AS FLOAT)) / 100.0, 4) AS [Historical AVG Govt Spend],
	[Recent % Govt Spend AVG],
	[Recent % Govt Spend AVG] - ROUND(AVG(CAST(pgo.Value AS FLOAT)) / 100.0, 4) AS [Govt Spend Difference from Historical AVG],
	ROUND(AVG(CAST(pgd.Value AS FLOAT)) / 100.0, 4) AS [Historical % GDP AVG],
	[Recent % GDP AVG],
	[Recent % GDP AVG] - ROUND(AVG(CAST(pgd.Value AS FLOAT)) / 100.0, 4) AS [GDP Spend Difference from Historical AVG]
FROM dbo.perc_govt AS pgo
INNER JOIN dbo.locationmaster as lm
	ON pgo.CountryID = lm.CountryID 
INNER JOIN dbo.perc_gdp as pgd
	ON lm.CountryID = pgd.CountryID
    AND pgo.Year = pgd.Year
INNER JOIN RecentGovtAvg as rga
	ON lm.Country = rga.Country
INNER JOIN RecentGDPAvg as rda
	ON lm.Country = rda.Country
WHERE lm.Country IN (
	'Denmark',
	'Finland',
	'Norway',
	'Sweden'
	)
GROUP BY
	lm.Country,
	[Recent % Govt Spend AVG],
	[Recent % GDP AVG];


