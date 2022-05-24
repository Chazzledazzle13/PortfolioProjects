Select *
FROM PortfolioProject.dbo.[Covid Deaths]
WHERE continent IS NOT NULL
ORDER BY 3,4

--Select *
--FROM PortfolioProject.dbo.['Covid Vaccinations$']
--WHERE continent IS NOT NULL
--ORDER BY 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..[Covid Deaths]
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract COVID in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..[Covid Deaths]
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 1,2

--Looking at Total Cases Vs Population
--Shows what percentage of population received Covid

SELECT Location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..[Covid Deaths]
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 1,2

--Looking At Countries With Highest Infection Rate Compared to Population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..[Covid Deaths]
--WHERE location LIKE '%states%'
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC

--Showing Death Count By Continent

SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..[Covid Deaths]
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int))AS total_deaths, SUM(CAST(New_deaths AS INT)) / SUM(New_cases) *100 AS DeathPercentage
FROM PortfolioProject..[Covid Deaths]
--WHERE location LIKE '%states%' 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int))AS total_deaths, SUM(CAST(New_deaths AS INT)) / SUM(New_cases) *100 AS DeathPercentage
FROM PortfolioProject..[Covid Deaths]
--WHERE location LIKE '%states%' 
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..['Covid Vaccinations$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..['Covid Vaccinations$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..['Covid Vaccinations$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating View to store data for later visualizations


CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..['Covid Vaccinations$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated