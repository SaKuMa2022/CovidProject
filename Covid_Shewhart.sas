libname carrs '/home/u57958949/sasuser.v94/carrs';/*Local file folder path used*/
filename Covidths '/home/u57958949/sasuser.v94/carrs/CovidDeaths.csv';


proc import datafile= Covidths
out=carrs.Covidths
dbms=csv
replace;
getnames=yes;
run;

data new_data;
 set carrs.covidths;
  month_year = date;
  format month_year mmyyn6.;
run;
proc sort data=new_data out=covid_newcases;
  by month_year;
  run;
  
title 'Variation of new cases over time in North America';
  symbol v=.;
  proc shewhart data= covid_newcases;
  where continent='Nort';
  boxchart new_cases*month_year/ maxpanels=42;
  run;
