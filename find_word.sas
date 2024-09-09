/*#####################################################################################*/
/*                                    FIND_WORD                                        */
/*
This returns zero or a postive number, so can be used for logical operations.

FINDW can also be used, but it returns the character position instead of the word position.
This function tells you if the word you're looking for is the first, second third (etc.) word
in a sentence.

This only finds whole words and is case insensitive.

%put Find the word: %find_word(It has been a busy day for Mr. Bee , bee);
%put Find the word: %find_word(It has been a busy day for Mr. Bee , crow);
*/
%macro find_word(sentence , word ) ;
%local word_position_counter;
%let word_position_counter = 0;
%if %sysfunc(findw(%lowcase(&sentence ), %lowcase(&word) , ,s )) %then %do;
	%do word_position_counter = 1 %to %num_words(&sentence);
		%if %lowcase(&word) = %lowcase(%scan(&sentence , &word_position_counter , ,s)) %then %goto LEAVE;
		%else %if &word_position_counter = %num_words(&sentence) %then %return;
	%end;
%end;
%LEAVE: &word_position_counter
%mend;