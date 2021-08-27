%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};

%token <sValue> ID
%token <iValue> NUMBER
%token WHILE BLOCK_BEGIN BLOCK_END DO IF THEN ELSE SEMI ASSIGN
%token DIVIDE PLUS RIGHT_PARENTHESIS TIMES LEFT_PARENTHESIS MINUS

%start prog

%type <sValue> stm

%%

prog: stmlist {}
     ;

stmlist: stm {printf("stm \n");}
        | stmlist SEMI stm {}
        ;


stm: ID ASSIGN exp {printf("stm %s = EXP\n", $1);} 
    ;

exp: exp PLUS term  {printf("stm exp + term\n");} 
    | exp MINUS term {printf("stm exp  - term\n");} 
    | term {} 
    ;

term: term TIMES factor {printf("stm  * \n");}
    | term DIVIDE factor {printf("stm  / \n");}
    | factor {}
    ;

factor: LEFT_PARENTHESIS exp RIGHT_PARENTHESIS {printf("stm ( exp )\n");} 
    | ID {printf("ID %s \n", $1);} | NUMBER  {printf("NUMBER %d \n", $1);}
    ;
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s em '%s'\n", yylineno, msg, yytext);
	return 0;
}