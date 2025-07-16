-- ============================================================
-- 🔋 Electricity Access in Africa: SQL Analysis (2000–2023)
-- Author: Collins Njehya
-- ============================================================

-- 📌 PROJECT SUMMARY:
-- This SQL project explores trends in electricity access across Africa using World Bank data 
-- from 2000 to 2023. The analysis focuses on national and regional access to electricity, 
-- comparing urban vs rural gaps, tracking long-term improvement, and investigating correlations 
-- with GDP growth.

-- 👨‍💻 Key Questions Answered:
-- - What is the electricity access trend in Kenya?
-- - How do rural and urban access compare in Kenya?
-- - Which African countries had the highest and lowest rural electricity access in 2023?
-- - Which countries improved the most in electricity access (2000–2023)?
-- - Is there a relationship between GDP growth and electricity access improvement?
-- - Which countries have the biggest rural–urban electricity access inequality?
-- - Are there countries where access declined?
-- - What is the average electricity access rate in Africa in 2023?
-- - What is the average access improvement by subregion?
-- - How many African countries have access > 80%? How many have < 50%?

-- 🧰 Skills Used:
-- - Joins (inner/self joins)
-- - Subqueries
-- - Aggregation functions (AVG, COUNT)
-- - Data cleaning and reshaping
-- - Real-world interpretation of energy access data

-- ✅ Outcome:
-- This SQL script demonstrates practical data analysis of sustainable development metrics 
-- using publicly available energy and economic indicators. It’s suitable for a data analyst 
-- portfolio, especially for energy, environment, and economic policy domains in Africa.

-- ============================================================
-- Below are the SQL queries used to answer each client-style question.
-- ============================================================


## What is the trend of total electricity access in Kenya from 2000 to 2023?
select `ï»¿country_name`,
       value
from total_population
where `ï»¿country_name` = 'Kenya'
order by Year;

##What is the trend of rural and urban electricity access in Kenya from 2000 to 2023?
SELECT
    r.rural_year AS year,
    r.Value AS rural_access,
    u.Value AS urban_access,
    (u.Value - r.Value) AS access_gap
FROM rural r
JOIN urban u
  ON r.`ï»¿Country Name` = u.`ï»¿Country Name`
  AND r.rural_year = u.urban_year
WHERE r.`ï»¿Country Name` = 'Kenya'
ORDER BY r.rural_year;

##Which 5 African countries had the highest and lowest rural electricity access in 2023?
SELECT rural.`ï»¿Country Name`,
		country_region.region,
         rural.Value
from rural JOIN country_region
	ON rural.`ï»¿Country Name` = country_region.country_name
WHERE rural.rural_year = 2023
	AND country_region.region = 'Africa'
ORDER BY rural.Value desc;

SELECT rural.`ï»¿Country Name`,
		country_region.region,
         rural.Value
from rural JOIN country_region
	ON rural.`ï»¿Country Name` = country_region.country_name
WHERE rural.rural_year = 2023
	AND country_region.region = 'Africa'
ORDER BY rural.Value asc
limit 5;

##Which African countries have improved the most in total electricity access between 2000 and 2023?
SELECT
    tp2023.`ï»¿country_name` AS country_name,
    tp2000.Value AS access_2000,
    tp2023.Value AS access_2023,
    (tp2023.Value - tp2000.Value) AS access_improvement
FROM total_population tp2000
JOIN total_population tp2023
  ON tp2000.`ï»¿country_name` = tp2023.`ï»¿country_name`
JOIN country_region
		ON tp2023.`ï»¿country_name` = country_region.country_name
WHERE tp2000.Year = 2000
  AND tp2023.Year = 2023
  AND country_region.region = 'Africa'
  ORDER BY access_improvement DESC;
  
  ##Does electricity access improvement correlate with GDP per capita growth in Africa between 2000 and 2023
  SELECT
    sub_electric.country_name,
    sub_electric.access_improvement,
    sub_gdp.gdp_growth
FROM
   (
   SELECT
    tp2023.`ï»¿country_name` AS country_name,
    tp2000.Value AS access_2000,
    tp2023.Value AS access_2023,
    (tp2023.Value - tp2000.Value) AS access_improvement
FROM total_population tp2000
JOIN total_population tp2023
  ON tp2000.`ï»¿country_name` = tp2023.`ï»¿country_name`
JOIN country_region
		ON tp2023.`ï»¿country_name` = country_region.country_name
WHERE tp2000.Year = 2000
  AND tp2023.Year = 2023
  AND country_region.region = 'Africa'
  ) AS sub_electric
JOIN
	(
		SELECT
		g2023.`ï»¿Country Name` AS country_name,
        g2000.Value AS growth_200,
        g2023.Value AS growth_2023,
        (g2023.Value - g2000.Value) as gdp_growth
FROM gdp g2000 
JOIN gdp g2023
		ON g2000.`ï»¿Country Name` = g2023.`ï»¿Country Name`
JOIN country_region 
		ON g2023.`ï»¿Country Name` = country_region.country_name
WHERE country_region.region = 'Africa'
	AND g2000.Attribute = 2000
		AND g2023.Attribute = 2023
        ) AS sub_gdp
  ON sub_electric.country_name = sub_gdp.country_name
ORDER BY sub_electric.access_improvement DESC;

## Which African countries have the highest inequality in urban vs rural electricity access in 2023
select 
		urban.`ï»¿Country Name`,
        urban.Value as urban_access,
        rural.Value as rural_access,
        (urban.Value - rural.Value) as diff_electric_access
from urban join rural
	on urban.`ï»¿Country Name` = rural.`ï»¿Country Name`
join country_region
	on urban.`ï»¿Country Name` = country_region.country_name
where urban.urban_year = 2023
	and rural.rural_year = 2023
	and country_region.region = 'Africa'
order by diff_electric_access desc;

## Are there African countries where access to electricity declined between 2000 and 2023
SELECT
    tp2023.`ï»¿country_name` AS country_name,
    tp2000.Value AS access_2000,
    tp2023.Value AS access_2023,
    (tp2023.Value - tp2000.Value) AS access_improvement
FROM total_population tp2000
JOIN total_population tp2023
  ON tp2000.`ï»¿country_name` = tp2023.`ï»¿country_name`
JOIN country_region
		ON tp2023.`ï»¿country_name` = country_region.country_name
WHERE tp2000.Year = 2000
  AND tp2023.Year = 2023
  AND (tp2023.Value - tp2000.Value) < 0
  AND country_region.region = 'Africa';
  
  ## What is the average electricity access rate across Africa in 2023
  select avg(total_population.Value)
from total_population 
join country_region
	on total_population.`ï»¿country_name` = country_region.country_name
where total_population.Year = 2023
	and country_region.region = 'Africa';
    
## Get a regional summary of electricity access improvements between 2000 and 2023
SELECT
    cr.subregion,
    AVG(tp2023.Value - tp2000.Value) AS avg_access_improvement
FROM total_population tp2000
JOIN total_population tp2023
    ON tp2000.`ï»¿country_name` = tp2023.`ï»¿country_name`
JOIN country_region cr
    ON tp2023.`ï»¿country_name` = cr.country_name
WHERE tp2000.Year = 2000
  AND tp2023.Year = 2023
  AND cr.region = 'Africa'
GROUP BY cr.subregion
ORDER BY avg_access_improvement DESC;

 ## Number of African countries with electricity access > 80% in 2023
 select count(total_population.`ï»¿country_name`)
from total_population join country_region
	on total_population.`ï»¿country_name` = country_region.country_name
where total_population.Year = 2023
	and country_region.region = 'Africa'
    and total_population.Value > 80;

## How many African countries still had electricity access below 50% in 2023
select count(total_population.`ï»¿country_name`)
from total_population join country_region
	on total_population.`ï»¿country_name` = country_region.country_name
where total_population.Year = 2023
	and country_region.region = 'Africa'
    and total_population.Value < 50;