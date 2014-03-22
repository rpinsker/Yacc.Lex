%{
	// parse.y

#include <stdio.h>
#include <stdlib.h>

void yyerror(char *);
int yylex(void);

%}

%token ERROR EOLN EOFTOK 
%token OPEN_CURLY CLOSE_CURLY
%token OPEN_BRACKET CLOSE_BRACKET
%token OPEN_PAREN CLOSE_PAREN
%token PAIR

%start input

%%

input
	: 
        | input line
        | input EOFTOK				{ YYACCEPT; }
	;

line
	: str EOLN				{ printf("%i\n",$1); }
	| error EOLN				{ fprintf(stderr,"invalid\n"); }
	| EOLN
	;

pair
	: PAIR					{ $$ = 1; }
	| OPEN_PAREN str CLOSE_PAREN		{ $$ = $2 + 1; }
        | OPEN_CURLY str CLOSE_CURLY            { $$ = $2 + 1; }
        | OPEN_BRACKET str CLOSE_BRACKET { $$ = $2 + 1; }
	;

str
: str str 				{ if ($1 > $2) { $$ = $1; } 
   else { $$ = $2; } }
	| pair			
	;

%%

void yyerror(char *msg) {}

