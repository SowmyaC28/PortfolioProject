select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4 


select * 
from PortfolioProject..CovidVaccinations
where continent is not null
order by 3,4 

select location,date,total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%india'
order by 1,2

select location,date,population,total_cases, (total_cases/population)*100 as PercentoFPopulationInfected
from PortfolioProject..CovidDeaths
where location like '%states' and continent is not null
order by 1,2

select location,population,max(total_cases) as Highest_Infection_Count, max((total_cases/population)*100 )as PercentoFPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
group by location,population
order by PercentoFPopulationInfected desc

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
group by location
order by TotalDeathCount desc

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
group by continent
order by TotalDeathCount desc


select sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
--where location like '%states%'and 
where continent is not null
--group by date
order by 1,2





select date,sum(new_cases)as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
--where location like '%states%'and 
where continent is not null
group by date
order by 1,2


select dea.continent, dea.location,dea.date ,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated, 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
        on dea.location = vac.location
        and dea.date = vac.date
where dea.continent is not null 
order by 2,3

WITH PopvsVac (Continent, Location,date,Population,New_Vaccinations,RollingPeopleVaccinated) as 
(
select dea.continent, dea.location,dea.date ,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
        on dea.location = vac.location
        and dea.date = vac.date
where dea.continent is not null 
)
select *, (RollingPeopleVaccinated/Population)*100 From PopvsVac