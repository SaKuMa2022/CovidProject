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
  

  proc shewhart data= covid_newcases ;
  where continent='Nort' ;
  boxchart new_cases*month_year/ nochart 
  outlimits=Timelim;;
  run;


ods graphics on;
title 'Variation of new cases in North America over time';
proc shewhart data=covid_newcases limits=Timelim ;
where continent='Nort';
boxchart new_cases*month_year /
readlimits
/*nohlabel
nolegend*/
odstitle = title;
run;

proc shewhart data=covid_newcases;
where location= 'Afghanistan' ;
boxchart new_cases*date;
run;