%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}
/*
Perguntar ao professor essa parte, com fica para tipagem no codigo
*/

// %union {
// 	int    iValue; 	/* integer value */
// 	char   cValue; 	/* char value */
// 	char * sValue;  /* string value */
// 	};

// %token <sValue> ID
// %token <iValue> NUMBER

%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE
%token IF ELSE 
%token BLOCK_BEGIN BLOCK_END LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_COCHETE RIGHT_COCHETE SEMI ASSIGN COMMA
%token PLUS MINUS TIMES DIVIDE LE GE NE EQ GT LT
%token STRUCT
%token NUMBER ID

%start prog

%%

prog: func {} 
    | dec {} 
    ;

dec: type Assignment SEMI {} 
    | Assignment SEMI {} 
    | funcCall SEMI {}
    | array SEMI {}
    | type array SEMI {}
    | structStmt SEMI {}
    ;

Assignment: ID ASSIGN Assignment {}
    | ID ASSIGN funcCall {}
    | ID ASSIGN array {}
    | array ASSIGN Assignment {}
    | ID COMMA Assignment {}
    | NUMBER COMMA Assignment {}
    | ID PLUS Assignment {}
    | ID MINUS Assignment {}
    | ID TIMES Assignment {}
    | ID DIVIDE Assignment {}
    | NUMBER PLUS Assignment {}
    | NUMBER MINUS Assignment {}
    | NUMBER TIMES Assignment {}
    | NUMBER DIVIDE Assignment {}
    | LEFT_PARENTHESIS Assignment RIGHT_PARENTHESIS { }
    | NUMBER
    | ID
    ;

funcCall: ID LEFT_PARENTHESIS RIGHT_PARENTHESIS { }
    | ID LEFT_PARENTHESIS Assignment RIGHT_PARENTHESIS { }
    ;

array: ID LEFT_COCHETE Assignment RIGHT_COCHETE {}
    ;

func: type ID LEFT_PARENTHESIS argListOpt RIGHT_PARENTHESIS CompoundStmt {} 
    ;

argListOpt: argList { }
    |
    ;

argList: argList COMMA arg { } 
    | arg { }
    ;

arg: type ID {}
    ;

CompoundStmt: BLOCK_BEGIN stmtlist BLOCK_END {}
    ;

stmtlist: stmtlist stmt { }
    |
    ;

stmt: whileStmt { }
    | declarationStmt { }
    | forStmt { }
    | ifStmt { }
    | SEMI
    ;

type: INT { }
    | FLOAT { }
    | DOUBLE { }
    | CHAR { }
    | VOID { }
    ;

whileStmt: WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS stmt { } 
    | WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS CompoundStmt { }
    ;

forStmt: FOR LEFT_PARENTHESIS expr SEMI expr SEMI expr RIGHT_PARENTHESIS stmt { } 
    | FOR LEFT_PARENTHESIS expr SEMI expr SEMI expr RIGHT_PARENTHESIS CompoundStmt { } 
    ;

ifStmt: IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS stmt {}
    ;

structStmt: STRUCT ID BLOCK_BEGIN type Assignment BLOCK_END { }
    ;

expr: expr LE expr { }
    | expr GE expr { }
    | expr NE expr { }
    | expr EQ expr { }
    | expr GT expr { }
    | expr LT expr { }
    | Assignment { }
    | array { }
    | 
    ;

%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s em '%s'\n", yylineno, msg, yytext);
	return 0;
}