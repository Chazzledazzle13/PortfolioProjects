-- Looking at population change per subregion
SELECT un_continential_region, un_subregion, SUM(population_change) AS subregion_change
FROM dbo.countries
GROUP BY un_continential_region, un_subregion
ORDER BY un_continential_region, un_subregion;


-- Subregions ordered by the ones with the lowest human development
SELECT un_continential_region, un_subregion, CAST(MIN(human_develop) AS DECIMAL(10,2)) AS DevelopMin
FROM dbo.countries
GROUP BY un_continential_region, un_subregion
ORDER BY DevelopMin;


-- Subregion ordered by highest population change
SELECT un_continential_region, un_subregion, CAST(MAX(population_change) AS DECIMAL(10,2)) AS ChangeMax
FROM dbo.countries
GROUP BY un_continential_region, un_subregion
ORDER BY ChangeMax DESC;

-- Average Human Development Index Growth by UN Subregion
SELECT un_continential_region, un_subregion, AVG(hdi_growth) AS avg_hdi_growth
FROM dbo.countries
GROUP BY un_continential_region, un_subregion
ORDER BY avg_hdi_growth DESC;

-- Total count of countries per subregion
SELECT un_continential_region, COUNT(country) AS total_countries
FROM dbo.countries
GROUP BY un_continential_region
ORDER BY total_countries DESC;


-- Selects all countries where subregion ends in Africa and that has a population change of > 1
SELECT un_subregion, country
FROM dbo.countries
WHERE un_subregion LIKE '% Africa'
AND population_change > 1.00
ORDER BY un_subregion, country;

--Looking at all countries with between 1 and 5 million internet users, descending
SELECT country, internet_users
from dbo.countries
WHERE internet_users BETWEEN 1000000 AND 5000000
ORDER BY internet_users DESC;

-- Looking at countries not contained within IN statement
SELECT country, population_2023
FROM dbo.countries
WHERE country NOT IN ('Ireland', 'Belgium', 'United Kingdom')
ORDER BY population_2023 DESC;

-- Casting percent_water as decimal to get 2 decimal places
SELECT un_continential_region, un_subregion, CAST(AVG(percent_water) AS DECIMAL(10,2)) AS WaterAvg
FROM dbo.countries
WHERE percent_water > 0
GROUP BY
un_continential_region, un_subregion
ORDER BY
WaterAvg DESC;

--All continents that have more than 20 million average population in 2023
SELECT un_continential_region
FROM dbo.countries
GROUP BY un_continential_region
HAVING AVG(population_2023) > 20000000
ORDER BY un_continential_region;

-- All countries where wb_fore_nom has an empty value
SELECT country, wb_fore_nom
FROM dbo.countries
WHERE wb_fore_nom IS NULL;

-- All subregions included in the database
SELECT DISTINCT un_subregion AS subregion
FROM dbo.countries
ORDER BY subregion;

-- All countries that begin with a B and are 6 letters long or start with a C
SELECT country
FROM dbo.countries
WHERE country LIKE 'B_____'
OR country LIKE 'C%'
ORDER BY country;

--Deleting any instances of Cameroon from the database
DELETE FROM dbo.countries
WHERE country = 'Cameroon';

--Updating un_subregion from Eastern Africa to East Africa
UPDATE dbo.countries
SET un_subregion = 'East Africa'
WHERE un_subregion = 'Eastern Africa';

-- Countries within the Top 10% of 2023 Population
SELECT TOP 10 PERCENT country, population_2023
FROM dbo.countries
ORDER BY population_2023 DESC;

-- If Netherlands is in the database, show me all countries listed
SELECT country
FROM dbo.countries
WHERE EXISTS
	(SELECT country 
	 FROM dbo.countries
	 WHERE country LIKE 'Netherlands')

-- Looking to see if any one population from 2023 is greater than another countries population from 2022 and 2023 combined
SELECT country
FROM dbo.countries
WHERE population_2022 + population_2023 < ANY
	(SELECT population_2023
	 FROM dbo.countries)

-- Same as above, but every country has to be greater
SELECT country
FROM dbo.countries
WHERE population_2022 + population_2023 < ALL
	(SELECT population_2023
	 FROM dbo.countries)

-- Nested subquery to display population changes that are greater than the average, Created View

SELECT country, population_change
FROM dbo.countries
WHERE population_change > 
	(SELECT AVG(population_change) 
	 FROM dbo.countries)
ORDER BY population_change DESC;

-- Created View to see this query later
CREATE VIEW PopAvg AS
SELECT country, population_change
FROM dbo.countries
WHERE population_change > 
	(SELECT AVG(population_change) 
	 FROM dbo.countries);

--Case to organize countries based on their water percentages
SELECT country, percent_water,
CASE
 WHEN  percent_water > 10 THEN 'High Water Percentage'
 WHEN  percent_water BETWEEN 5.0 AND 9.99 THEN 'Medium Water Percentage'
 ELSE 'Low Water Percentage'
END AS WaterAmount
FROM DBO.countries
ORDER BY percent_water DESC;


-- CTE created with AVG Internet Users
WITH CTE_country AS
(SELECT un_continential_region, un_subregion, country
, AVG(internet_users) OVER (PARTITION BY internet_users) As AvgUsers
FROM dbo.countries
WHERE internet_users > 2000000
)
SELECT country, AvgUsers
FROM CTE_country