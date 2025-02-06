/*#####################################################################################*/
/*                                 SHOW_MACROS                                         */
/*
%show_macros;
*/
%macro show_macros;
proc sql;
  select * 
    from dictionary.catalogs
    where objtype='MACRO';
quit;
%mend;


/*#####################################################################################*/
/*                                   IS_BLANK                                          */
/*
%let var_1 = ;
%let var_2 = Hello;
%put %is_blank(&var_1);
%put %is_blank(&var_2);
*/
%macro is_blank(param);
  %sysevalf(%superq(param)=,boolean)
%mend;

/*#####################################################################################*/
/*                                   IS_INT                                            */
/*
With thanks to Lex Jansen
%put %is_int(2007);
%put %is_int(1E10);
%put %is_int(12345.4);
%put %is_int(123rabbit);
*/
%macro is_int(str);
%local test_string result;
%let test_string = %sysfunc(compress(&str ,, kd));
%if &test_string = &str %then %let result = 1;
%else %let result = 0;
&result
%mend; 
