SELECT *
FROM PortfolioProject.dbo.[Covid Deaths]
where continent is not null
Order by 3,4

SELECT *
FROM PortfolioProject.dbo.[Covid Vaccines]
Order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.[Covid Deaths]
Order by 1,2

--Looking at total cases versus total deaths
--Likelihood of dying if you contract Covid

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.[Covid Deaths]
Where location = 'Pakistan'
Order by 1,2

--Looking at total cases versus the population
--Shows what percetage of population got Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.[Covid Deaths]
Where location = 'United States'
Order by 1,2

--Looking at countries with highest infection count compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.[Covid Deaths]
GROUP BY Location, Population
Order by 4 desc

--Showing countries wih highest death count per population

SELECT location, MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.[Covid Deaths]
WHERE continent is not null
GROUP BY Location
Order by 2 desc


SELECT location, MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.[Covid Deaths]
WHERE continent is null
GROUP BY Location
Order by 2 desc

--Showing continents with the highest death count
SELECT continent, MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.[Covid Deaths]
WHERE continent is not null
GROUP BY continent
Order by 2 desc

--Global Numbers
SELECT date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.[Covid Deaths]
WHERE continent is not null
GROUP BY date
Order by 1,2

SELECT SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.[Covid Deaths]
WHERE continent is not null
Order by 1,2

Select *
FROM PortfolioProject.dbo.[Covid Deaths] as dea
JOIN PortfolioProject.dbo.[Covid Vaccines] as vacc
ON dea.date = vacc.date
AND dea.location = vacc.location

--Looking at total population versus vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
FROM PortfolioProject.dbo.[Covid Deaths] as dea
JOIN PortfolioProject.dbo.[Covid Vaccines] as vacc
ON dea.date = vacc.date
AND dea.location = vacc.location
where dea.continent is not null

SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(Convert(bigint,vacc.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.dbo.[Covid Deaths] as dea
JOIN PortfolioProject.dbo.[Covid Vaccines] as vacc
ON dea.date = vacc.date
AND dea.location = vacc.location
where dea.continent is not null
order by 2,3

--USE CTE
WITH PopVersusVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(Convert(bigint,vacc.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.dbo.[Covid Deaths] as dea
JOIN PortfolioProject.dbo.[Covid Vaccines] as vacc
ON dea.date = vacc.date
AND dea.location = vacc.location
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVersusVac

--Creating viw to store data for later visualisations

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(Convert(bigint,vacc.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.dbo.[Covid Deaths] as dea
JOIN PortfolioProject.dbo.[Covid Vaccines] as vacc
ON dea.date = vacc.date
AND dea.location = vacc.location
where dea.continent is not null




