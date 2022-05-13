--Kaheem Walters
--This script contains queries that reveals answers to common questions related to the global COVID cases, deaths, and vaccinations

SELECT *
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;


--total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM COVIDPortfolioProject..CovidDeaths
WHERE location like '%States'
ORDER BY 1, 2;

--total cases vs population
SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentInfected
FROM COVIDPortfolioProject..CovidDeaths
WHERE location like '%States'
ORDER BY 1, 2;


--Countries with highest infection rate
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is not null
Group by location, population
ORDER BY PercentPopulationInfected DESC;


--countries with highest death count per population
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is not null
Group by location
ORDER BY TotalDeathCount DESC;


--same thing but for continents
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is null
Group by location
ORDER BY TotalDeathCount DESC;


--Global numbers per day
SELECT date, SUM(new_cases) as GlobalCases, SUM(CAST(new_deaths AS int)) as GlobalDeathCount, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as GlobalDeathPercentage
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2;


--Total Numbers from 01-23-2020 until 05-11-2022
SELECT SUM(new_cases) as GlobalCases, SUM(CAST(new_deaths AS int)) as GlobalDeathCount, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as GlobalDeathPercentage
FROM COVIDPortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;





--Joining COVID Deaths table with COVID Vaccninations table
SELECT *
FROM COVIDPortfolioProject..CovidDeaths death
JOIN COVIDPortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date;

--Total vaccinated in country per day
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
FROM COVIDPortfolioProject..CovidDeaths death
JOIN COVIDPortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent is not null
ORDER BY 2, 3;


-- CTE for Percentage of vaccinated per country
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/death.population)*100
FROM COVIDPortfolioProject..CovidDeaths death
JOIN COVIDPortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as Vaccination_Percentage
FROM PopvsVac;
-- End of CTE


--If TEMP Table is preferred:
DROP TABLE if exists PercentofPeopleVaccinated
CREATE TABLE PercentofPeopleVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
) 

INSERT INTO PercentofPeopleVaccinated
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/death.population)*100
FROM COVIDPortfolioProject..CovidDeaths death
JOIN COVIDPortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100 as Vaccination_Percentage
FROM PercentofPeopleVaccinated;



--Views for later visualizations
CREATE VIEW ViewPercentofPeopleVaccinated as
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/death.population)*100
FROM COVIDPortfolioProject..CovidDeaths death
JOIN COVIDPortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent is not null;