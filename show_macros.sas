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