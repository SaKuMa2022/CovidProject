Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects .. CovidDeaths
order by 1,2

-- Looking at total cases vs total cases
Select location, date, total_cases, new_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects .. CovidDeaths
where location =  'United States' 
order by 1,2

--Total cases vs population
Select location, date, total_cases, new_cases, population,total_deaths,(total_cases/population)*100 as PercentageInfected
from PortfolioProjects .. CovidDeaths
where location =  'United States' 
order by 1,2

--Looking at countries with highest perentage of infection

Select location,  population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentageInfected
from PortfolioProjects .. CovidDeaths
group by location, population
order by PercentageInfected desc

--Total death count by location(country)
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects .. CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Total death count by continent
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects .. CovidDeaths
where continent is  null
group by location
order by TotalDeathCount desc
--Total deaths by continent with variation
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects .. CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc
-- Global total cases
Select  sum(new_cases) as TotalNewCases, sum(cast(new_deaths as int)) as Totalnewdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 
as Deathpercentage
from PortfolioProjects ..CovidDeaths
where continent is not null
--group by date 
order by 1 desc,2


select dea.continent, dea.location, dea.date, population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over ( partition by dea.location order by dea.location,
dea.date) as Cummul_Vacc
from PortfolioProjects..CovidDeaths dea
Join  PortfolioProjects..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3
--Looking at Total people vaccinated CTE created 
with PopvsVac(Continent, Location, Date,Population,new_vaccinations,Cummul_Vacc)
as
(select dea.continent, dea.location, dea.date, population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over ( partition by dea.location order by dea.location,
dea.date) as Cummul_Vacc
from PortfolioProjects..CovidDeaths dea
Join  PortfolioProjects..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	)
Select *,(Cummul_Vacc/Population)*100
From PopvsVac



--Temp table variation
Drop Table if exists PerctPopulationVaccinated
Create Table PerctPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Cummul_Vacc numeric
)


Insert into  PerctPopulationVaccinated

select dea.continent, dea.location, dea.date, population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over ( partition by dea.location order by dea.location,
dea.date) as Cummul_Vacc
from PortfolioProjects..CovidDeaths dea
Join  PortfolioProjects..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null
	--order by 2,3
	

Select *,(Cummul_Vacc/Population)*100 as PctPopVacc
From PerctPopulationVaccinated

Create View PerctPopulationVacc as
select dea.continent, dea.location, dea.date, population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over ( partition by dea.location order by dea.location,
dea.date) as Cummul_Vacc
from PortfolioProjects..CovidDeaths dea
Join  PortfolioProjects..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3


Select *
From PerctPopulationVacc





