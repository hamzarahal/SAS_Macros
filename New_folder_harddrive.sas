/**************************Create new folder on harddrive from a sas program*************************/
/*****************************************************************************************************/

*==============================================================================;
*Create the macro to create a new folder;
*==============================================================================;
 
%macro create_newfolder(newfld);
 
%*---------------------------------------------------------;
%*check for the existence of the folder;
%*---------------------------------------------------------;
 
%if %sysfunc(fileexist(&newfld)) %then %put NOTE:The directory "&newfld" already EXISTS.;
 
%*---------------------------------------------------------;
%*create the folder(s) recursively if absent;
%*---------------------------------------------------------;
%else %do;
   %*---------------------------------------------------------;
   %*check the operating system and use the OS specific command;
   %*---------------------------------------------------------;
   %if "%bquote(%substr(&sysscp,1,3))"="WIN" %then %sysexec md "&newfld";
   %else %if "%bquote(%substr(&sysscp,1,3))"="LIN" %then %sysexec mkdir -p "&newfld";
 
    %put NOTE:The directory "&newfld" has been CREATED.;
%end;
 
 
%mend csg_create_newfolder_001;
 
*==============================================================================;
*Create a temporary folder and store a copy of class dataset in it;
*==============================================================================;
 
%create_newfolder(D:\SAS\mactest);
 
libname mylib "D:\SAS\mactest";
 
data mylib.class;
   set class;
run;