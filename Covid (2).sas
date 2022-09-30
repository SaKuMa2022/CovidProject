
libname carrs '/home/u57958949/sasuser.v94/carrs';/*Local file folder path used*/
filename Covidths '/home/u57958949/sasuser.v94/carrs/CovidDeaths.csv';


proc import datafile= Covidths
out=carrs.Covidths
dbms=csv
replace;
getnames=yes;
run;



proc contents data=carrs.Covidths;
run;

proc print data=carrs.covidths (obs=1000) ;
var total_deaths;
run;

proc sql;
select location, date, total_cases, new_cases, total_deaths,population, ((input(total_deaths,best.)/total_cases))*100 as DeathPctg
from carrs.covidths
where location like '%Afg%'  and Continent is not null
order by 1,2;
quit;

proc sql; 
select location, date, total_cases, new_cases, total_deaths,population, ((input(total_deaths,best.)/total_cases))*100 as DeathPctg
from carrs.covidths
where location like '%Sta%'
order by 1,2;
quit;

proc sql ; /* Highest infection rate*/
select location, population,max(total_cases) as HighestInfectionCount, 
max(total_cases/population)*100 as PctPopInfect 
from carrs.covidths 
where continent is not null 
group by location,population
order by PctPopInfect desc;
quit;

proc sql; /*by location*/
select location, max(input(total_deaths,best.)) as TotDthCnt
from carrs.covidths
where continent is not null
group by location
order by TotDthCnt desc;
quit;


proc sql; /*by continent*/
select continent, max(input(total_deaths,best.)) as TotDthCnt
from carrs.covidths
where continent is not null
group by continent
order by TotDthCnt desc;
quit;


