/*#####################################################################################*/
/*                                CHECK_DUPLICATES                                     */
/*
This tells you the number of unique entries which have a particular number of appearances
in the dataset. Outputs to the log E.g. in the column "Bob Joe Andy Tim Paul Paul" the 
output would be:
Occurrences - Number
1 4
2 1
Because there were four unique entries which had only one occurrence, and one unique entry 
which had 2 occurrences. 

Have a look at the following examples:
%check_duplicates(sashelp.baseball , name);
%check_duplicates(sashelp.baseball , team);
%check_duplicates(sashelp.iris , species);
*/

%macro check_duplicates(dataset , var_name);
%put Dataset: &dataset;
proc sql;
create table num_of_occurrences_ds as select count(Count) as Count, Count as Occurrences  from 
	(select count(&var_name) as Count  from &dataset group by &var_name) 
	group by Count
;
quit;

data num_of_occurrences_ds;
	set num_of_occurrences_ds nobs=total;
	if total=1 then do;
		if Occurrences = 1 then put "All " Count "unique entries appeared once only" ;
		else put  "All " Count "unique entries appeared on " Occurrences "occasions only" ;
	end;
	else if _n_ <=25 then do;
		if _n_ = 1 then put "Occurrences - Number";
		put Occurrences Count ;
	end;
	else do;
		put "There were more than 25 different frequencies for this variable.";
		stop;
	end;
run;
%delete_dataset(num_of_occurrences_ds);
%mend;
