/*#####################################################################################*/
/*                                 DELETE_DATASET                                      */
/*
%delete_dataset(data_1 data_2 );
%delete_dataset( TEMP_: );
*/
%macro delete_dataset(list);
%local list;
proc datasets lib=work memtype=data nolist ;
	delete &list;
quit;
run;
%mend;


/*#####################################################################################*/
/*                                 RENAME_VAR                                          */
/*
data something;
	set sashelp.cars;
run;
%rename_var(something , old_name=Make , new_name = Make_of_car );

If the dataset doesn't exist then ABORT.
If warning is YES and the old_name doesn't exist then ERROR ABORT
ELSE If warning is YES and the new_name exists then ERROR ABORT
ELSE If warning is NO and the old_name doesn't exist then NOTE 
ELSE If warning is NO and the new_name exists then NOTE 
ELSE (old_name exists and new_name doesn't) RENAME

*/

%macro rename_var(ds , old_name= , new_name= , warn=YES);
%if %dataset_exist(&ds)=0 %then %do;
	%put ERROR: The dataset passed to the rename macro does not exist: &ds ;
	%abort;
%end;

%if &warn = YES and %var_exist(&ds , &new_name) %then %do;
	%put ERROR: The variable &new_name already exists in the dataset &ds; 
	%abort;
%end;
%else %if &warn = YES and %var_exist(&ds , &old_name)=0 %then %do;
	%put ERROR: The variable &old_name does not exist in the dataset &ds; 
	%abort;
%end;
%else %if &warn = NO  and %var_exist(&ds , &new_name) %then %do;
	%put NOTE: The variable &new_name already exists in the dataset &ds so nothing will be renamed; 
%end;
%else %if &warn = NO  and %var_exist(&ds , &old_name)=0 %then %do;
	%put NOTE: The variable &old_name does not exist in the dataset &ds so nothing will be renamed; 
%end;
%else %do;
	PROC DATASETS LIBRARY=work nolist;
	MODIFY &ds ;
	RENAME &old_name=&new_name;
	QUIT;
	RUN;
%end;
%mend; 


/*#####################################################################################*/
/*                                 ADD_LABEL                                           */
/*
data names_of_people;
	input name $;
	datalines;
Joe
Tim
Brendan
;
run;
%add_label( names_of_people , name , "Name of person"  );
%add_label( names_of_people , hat , "Name of person"  );
%add_label( names_of_people , hat , "Name of person" , warn=NO );
%print_vars(names_of_people);
*/
%macro add_label(ds_label , var_label , label , warn=YES);
%if &warn = YES | %Var_Exist(&ds_label  , &var_label ) %then %do;
PROC DATASETS LIBRARY=work nolist;
MODIFY &ds_label ;
label &var_label = &label;
RUN;
quit;
%end;
%mend;


/*#####################################################################################*/
/*                                 DROP_FORMAT                                         */
%macro drop_format(ds , var);
proc datasets lib=work memtype=data nolist;
   	modify &ds;
    attrib &var format=;
run;
%mend;
