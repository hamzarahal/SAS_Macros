/*#####################################################################################*/
/*                                 DATASET_EXIST                                       */
/*
Returns 1 or 0 depending on whether the dataset exists

%put %dataset_exist(sashelp.cars);
%put %dataset_exist(sashelp.boats);
*/
%macro Dataset_Exist(ds);
%local rc dsid result;
%let dsid=%sysfunc(open(&ds));

%if &dsid %then %do;
	%let result = 1;
%end;
%else %do;
	/*%put Dataset &ds does not exist;*/
	%let result = 0;	
%end;
%let rc=%sysfunc(close(&dsid));
&result
%mend ;