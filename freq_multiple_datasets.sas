/********************Run proc freq on multiple datasets - one or more tables*****************************/
/********************************************************************************************************/

data males;
infile datalines dlm='|' dsd missover;
input NAME : $8. SEX : $1. AGE : best32. HEIGHT : best32. WEIGHT : best32.;
label ;
format ;
datalines4;
Alfred|M|14|69|112.5
Henry|M|14|63.5|102.5
James|M|12|57.3|83
Jeffrey|M|13|62.5|84
John|M|12|59|99.5
Philip|M|16|72|150
Robert|M|12|64.8|128
Ronald|M|15|67|133
Thomas|M|11|57.5|85
William|M|15|66.5|112
;;;;
run;

data females;
infile datalines dlm='|' dsd missover;
input NAME : $8. SEX : $1. AGE : best32. HEIGHT : best32. WEIGHT : best32.;
label ;
format ;
datalines4;
Alice|F|13|56.5|84
Barbara|F|13|65.3|98
Carol|F|14|62.8|102.5
Jane|F|12|59.8|84.5
Janet|F|15|62.5|112.5
Joyce|F|11|51.3|50.5
Judy|F|14|64.3|90
Louise|F|12|56.3|77
Mary|F|15|66.5|112
;;;;
run;

*==============================================================================;
*Get the frequency of age variable in males and females datasets;
*==============================================================================;
 
 
proc freq data=males   ;
    tables sex*age   /list missing out=u01;
    where 1=1;
run;
 
proc freq data=females   ;
    tables sex*age   /list missing out=u02;
    where 1=1;
run;
 
*==============================================================================;
*Create the macro;
*==============================================================================;
 
%macro multfreq(dsnlist=%str( ),tables=%str( ),where=%str());
 
%local _dsncount _dsni _tablesi _tablescount _currentdsn _currentable;
 
%let _dsncount=%sysfunc(countw(&dsnlist,%str( )));
%let _tablescount=%sysfunc(countw(&tables,%str( )));
 
%do _dsni=1 %to &_dsncount.;
   %let _currentdsn=%scan(&dsnlist.,&_dsni,%str( ));
   title "&_currentdsn";
 
   proc freq data= &_currentdsn  ;
      %do _tablesi=1 %to &_tablescount.;
        %let _currenttable=%scan(&tables.,&_tablesi,%str( ));
          tables  &_currenttable.  /list missing out=%scan(&_currentdsn.,-1,%str(.))_freq0&_tablesi.;
      %end;
        &where.;
   run;
 
%end;
%mend multfreq;
 
*==============================================================================;
*Get the frequency of age variable in males and females datasets - using macro;
*==============================================================================;
 
%multfreq(
dsnlist=%str(males females)
,tables=%str(sex*age)
,where=%str()
);