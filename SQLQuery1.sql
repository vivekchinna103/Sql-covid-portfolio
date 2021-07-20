Select * from Portfolio.dbo.covidDeaths;
Select * from Portfolio.dbo.covidVaccinations


--Total cases Vs Total deaths for a particular country(India)
Select iso_code,continent,location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as percentage  from Portfolio.dbo.covidDeaths 
where location like '%India%'
order by 1,2 Desc

--Total cases Vs Total deaths for ervery country
Select iso_code,location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as percentage  from Portfolio.dbo.covidDeaths 
order by 1,2 Desc


--Total cases vs Total population for india
Select Portfolio.dbo.coviddeaths.iso_code,Portfolio.dbo.CovidDeaths.location,population, total_cases,(total_cases/population)*100 as Death_percentage  from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code
Where Portfolio.dbo.covidDeaths.location Like '%India'
order by Death_percentage Desc


---Total cases vs Total population for every country
Select Portfolio.dbo.coviddeaths.iso_code,Portfolio.dbo.CovidDeaths.location,population, total_cases,(total_cases/population)*100 as percentage_  from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code
order by 4 Desc


--Looking at the countries which infected more
Select Portfolio.dbo.CovidDeaths.location,population, max(total_cases) as max_cases,max(total_cases/population)*100 as Infected_percentage  from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code  group by population,Portfolio.dbo.CovidDeaths.location
order by Infected_percentage desc 


--Looking at the each country  and their death count percentage w.r.t cases 
Select Portfolio.dbo.CovidDeaths.location,max(total_deaths)as death, max(total_cases)as total_case,max(total_deaths/total_cases)*100 as Infected_percentage  from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code
group by population,Portfolio.dbo.CovidDeaths.location
order by Infected_percentage desc 


---Looking at the each country  and their death count percentage w.r.t cases(for India)
Select Portfolio.dbo.CovidDeaths.location,max(total_deaths)as death, max(total_cases)as total_case,max(total_deaths/total_cases)*100 as Infected_percentage  from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code
where Portfolio.dbo.CovidDeaths.location like '%India%'
group by population,Portfolio.dbo.CovidDeaths.location
order by Infected_percentage desc 

---Looking at each continent and their total cases:-
Select location,max(total_cases) as cases from Portfolio.dbo.covidDeaths 
where continent is null
group by location
order by cases desc

---Looking the GLOBAL Infection rate on each day 
Select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as infection_rate  from Portfolio.dbo.covidDeaths 
where new_cases!=0
group by date
order by 3 desc

----Total population vs vaccinations
Select Portfolio.dbo.covidDeaths.location,max(total_vaccinations) as vaccination_count,population, (max(total_vaccinations)/population)*100 as vaccination_density from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code
where Portfolio.dbo.covidDeaths.continent is not null
group by Portfolio.dbo.covidDeaths.location,population
order by 4 desc

----Total population vs vaccinations(India)
Select Portfolio.dbo.covidDeaths.location,max(total_vaccinations) as vaccination_count,population, (max(total_vaccinations)/population)*100 as vaccination_density from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code 
where Portfolio.dbo.covidDeaths.continent is not null and Portfolio.dbo.covidDeaths.location like '%India%'
group by Portfolio.dbo.covidDeaths.location,population
order by 4 desc

---Looking likelihood of contraction of virus of each country
Select Portfolio.dbo.covidDeaths.location,population,max(total_deaths) as total_deaths,(max(total_deaths)/population)*100 as Likelihood_percentage from Portfolio.dbo.covidDeaths
inner join Portfolio.dbo.covidVaccinations on Portfolio.dbo.covidDeaths.iso_code=Portfolio.dbo.covidVaccinations.iso_code
where Portfolio.dbo.covidDeaths.continent is not null
group by Portfolio.dbo.covidDeaths.location,population
order by 4 desc

---GLOBAL NUMBERS total cases and total deaths on each day and death percentage 
select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage from Portfolio.dbo.covidDeaths
where continent is not null
group by date
order by 1,2

---Total Vaccinations vs population
---Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

