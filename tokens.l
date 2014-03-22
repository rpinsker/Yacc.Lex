%{
    // tokens.l
    // tokenization description for para program

#include <stdio.h>
#include <string.h>
#include "para.h"

int yyparse();

%}

%option noyywrap

pair \(\)|\{\}|\[\]
badpair \(\]|\(\}|\[\)|\[\}|\{\]|\{\)
%%

{pair} {return PAIR; }
{badpair} {return ERROR;}

\( { 	return OPEN_PAREN; }
\) {	return CLOSE_PAREN; }
\{ { return OPEN_CURLY; }
\} { return CLOSE_CURLY; }
\[ { return OPEN_BRACKET; } 
\] { return CLOSE_BRACKET; }

.               {	return ERROR; }

\n              {	return EOLN; }

<<EOF>>         {	return EOFTOK; }

%%

void parse_string(char *s) {
	char *str;
	asprintf(&str,"%s\n",s);
    YY_BUFFER_STATE bh = yy_scan_string(str);
    yyparse();
    yy_delete_buffer(bh);
    free(str);
}

int main(int argc, char **argv) {
	if (argc > 1) {
	  int i;
	  for (i = 1; i < argc; ++i) {
	    parse_string(argv[i]);
	  }
	} else {
		yyparse();
	}

	exit(0);
}