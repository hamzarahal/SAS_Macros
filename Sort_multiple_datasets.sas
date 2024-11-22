/*********************Run proc sort nodupkey on multiple datasets using same by variables*********************/
/************************************************************************************************************/

data dm;
infile datalines dlm='|' dsd missover;
input usubjid : $20.;
label ;
format ;
datalines4;
1001
1002
1003
1004
1005
2001
2002
2003
;;;;
run;

data ae;
infile datalines dlm='|' dsd missover;
input usubjid : $20. aeterm : $30.;
label ;
format ;
datalines4;
1001|headache
1001|headache
1001|nausea
1002|nausea
1002|gastric ulcer
1003|vomiting
1004|diarrhea
1004|diarrhea
;;;;
run;

data cm;
infile datalines dlm='|' dsd missover;
input usubjid : $20. cmtrt : $30.;
label ;
format ;
datalines4;
1001|paracetmaol
1001|ibuprofen
1001|ibuprofen
1002|ondansetran
1002|rabeprazole
1004|loperamide
1004|loperamide
;;;;
run;

*==============================================================================;
*Identify the list of subjects who has at least one event and who has taken atleast one medication;
*==============================================================================;
 
proc sort data=ae out=ae_subj nodupkey;
   by usubjid;
run;
 
proc sort data=cm out=cm_subj nodupkey;
   by usubjid;
run;
 
*==============================================================================;
*Create a macro to Run proc sort nodupkey on multile datasets using same by variables;
*==============================================================================;
 
%macro multdup(dsnlist=%str( ),byvars=%str( ),where=%str());
 
%local _dsncount _dsni _currentdsn;
 
%let _dsncount=%sysfunc(countw(&dsnlist,%str( )));
%do _dsni=1 %to &_dsncount.;
   %let _currentdsn=%scan(&dsnlist.,&_dsni,%str( ));
 
   proc sort data= &_currentdsn. out=%scan(&_currentdsn.,-1,%str(.))_firstocc dupout=%scan(&_currentdsn.,-1,%str(.))_subsqoccs nodupkey;
      by &byvars.;
      &where.;
   run;
%end;
%mend multdup;
 
*==============================================================================;
*Achieve the same result using macro;
*==============================================================================;
 
%multdup(
dsnlist=%str(ae cm)
,byvars=%str(usubjid)
,where=%str()
);
 
data dm01;
   merge dm(in=a)
         ae_firstocc(in=b keep=usubjid)
         cm_firstocc(in=c keep=usubjid);
   by usubjid;
 
   if a;
   if b then hasae="Y";
   if c then hascm="Y";
run;
 