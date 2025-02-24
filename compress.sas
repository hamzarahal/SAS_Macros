%macro compress(source,chars,mod);
%local MsgType;
%let MsgType=NOTE;
%if %superq(source)= %then %do; 
   %let MsgType=ERROR;
   %put;
   %put &MsgType: &SYSMACRONAME Error:;
   %put &MsgType- You must supply the source text to be processed.;
   %put;
   %goto Syntax; 
%end;
%if %SUPERQ(source)= ? %then %do;
%Syntax:
   %put;
   %put &MsgType: &SYSMACRONAME documentation:;
   %put &MsgType- Purpose: Returns a character string with specified ;
   %put &MsgType-          characters removed from the original string.;
   %put &MsgType-          The resulting text is not quoted.;
   %put;
   %put &MsgType- Syntax: %nrstr(%%)&SYSMACRONAME(source<,chars><,mod>);
   %put &MsgType- source: Source text to be processed;
   %put &MsgType- chars:  list of characters (optional);
   %put &MsgType- mod:    function behavior modifier characters (Optional);
   %put ;
   %put &MsgType- See the SAS documentation for COMPRESS() for more info.;
   %put ;
   %put &MsgType- Example: %nrstr(%%)&SYSMACRONAME(a1b2c3d4,,ka);
   %put &MsgType- Result:  abcd;
   %put ;
   %put &MsgType- Use ? to print documentation to the SAS log.;
   %put;
   %return;
%end; 
	%if %superq(chars)= and %superq(mod)= %then %let chars=%str( );
	%sysfunc(compress(%superq(source),%superq(chars),%superq(mod)))
%mend compress;