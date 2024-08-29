/*#####################################################################################*/
/*                                 VAR_EXIST                                          */
/*
%put %var_exist(sashelp.cars , model);
%put %var_exist(sashelp.cars , sandwich);
*/
%macro Var_Exist(ds,var);
	%local rc dsid result;

	%let dsid=%sysfunc(open(&ds));
	%if %sysfunc(varnum(&dsid,&var)) > 0 %then %do;
		%let result=1;
		/*%put NOTE: Variable &var exists in &ds;*/
	%end;
	%else %do;
		%let result=0;
		/*%put NOTE: Variable &var does not exist in &ds;*/
	%end;
	%let rc=%sysfunc(close(&dsid));
	&result
%mend ;

/*#####################################################################################*/
/*                                 VARS_EXIST                                          */
/*
%put %vars_exist(sashelp.cars , model model_name model_id);
*/
