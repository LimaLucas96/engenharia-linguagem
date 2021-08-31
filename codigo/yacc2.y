%{
#include <stdio.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

struct idsReturnType{
    char * code;
    int n;
    char * ids
    idsReturnType * idsValue;
}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
    idsReturnType * idsValue;
	};

%token <sValue> ID TYPE
%token <iValue> NUMBER

%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE DO
%token IF ELSE 
%token BLOCK_BEGIN BLOCK_END LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_COCHETE RIGHT_COCHETE SEMI ASSIGN COMMA
%token PLUS MINUS TIMES DIVIDE LE GE NE EQ GT LT
%token STRUCT
// %token NUMBER ID

%right ASSIGN
%left LE GE EQ
%left NE LT GT

%start prog

%type <sValue> Assignment dec funcCall array

%%

prog: func {} 
    | dec {  
            printf("%s",$1);

            printf("\n\nFIM\n");
            free($1);
        } 
    ;

dec: TYPE Assignment SEMI { 
                    int size = strlen($1) + strlen($2) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s, "%s %s;", $1, $2);
                    free($2);
                    $$ = s;
                } 
    | Assignment SEMI {  
                    int size = strlen($1) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s;\n",$1);
                    // free($1);
                    $$ = $1; 
                }
    | funcCall SEMI {}
    | array SEMI {}
    | TYPE array SEMI {}
    | structStmt SEMI {}
    ;

Assignment: ID ASSIGN Assignment {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    $$ = s; 
                }
    | ID ASSIGN funcCall {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    $$ = s; 
                }
    | ID ASSIGN array {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    $$ = s; 
                }
    | array ASSIGN Assignment {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    $$ = s; 
                }
    | NUMBER COMMA Assignment {  
                    int size = sizeof(int) + strlen($3) + 2;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d, %s",$1, $3);
                    $$ = s; 
                }
    | ID PLUS Assignment {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s + %s",$1, $3);
                    $$ = s; 
                }
    | ID MINUS Assignment {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s - %s",$1, $3);
                    $$ = s; 
                }
    | ID TIMES Assignment {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s * %s",$1, $3);
                    $$ = s; 
                }
    | ID DIVIDE Assignment {  
                    int size = strlen($1) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s / %s",$1, $3);
                    $$ = s; 
                }
    | NUMBER PLUS Assignment {  
                    int size = sizeof(int) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d + %s",$1, $3);
                    $$ = s; 
                }
    | NUMBER MINUS Assignment {  
                    int size = sizeof(int) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d - %s",$1, $3);
                    $$ = s; 
                }
    | NUMBER TIMES Assignment {  
                    int size = sizeof(int) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d * %s",$1, $3);
                    $$ = s; 
                }
    | NUMBER DIVIDE Assignment {  
                    int size = sizeof(int) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d / %s",$1, $3);
                    $$ = s; 
                }
    | LEFT_PARENTHESIS Assignment RIGHT_PARENTHESIS {  
                    int size = strlen($2) + 2;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"(%s)",$2);
                    $$ = s; 
                }
    | NUMBER { 
                    int size = sizeof(int);
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d",$1);
                    $$ = s; 

            }
    | ID { 
                $$ = $1; 
        }
    ;

funcCall: ID LEFT_PARENTHESIS RIGHT_PARENTHESIS { }
    | ID LEFT_PARENTHESIS Assignment RIGHT_PARENTHESIS { }
    ;

array: ID LEFT_COCHETE Assignment RIGHT_COCHETE {}
    ;

func: TYPE ID LEFT_PARENTHESIS argListOpt RIGHT_PARENTHESIS CompoundStmt {} 
    ;

argListOpt: argList { }
    |
    ;

argList: argList COMMA arg { } 
    | arg { }
    ;

arg: TYPE ID {}
    ;

CompoundStmt: BLOCK_BEGIN ID stmtlist BLOCK_END ID {} 
    | BLOCK_BEGIN WHILE stmtlist BLOCK_END WHILE {}
    | BLOCK_BEGIN FOR stmtlist BLOCK_END FOR {}
    | BLOCK_BEGIN IF stmtlist BLOCK_END IF {}
    ;

stmtlist: stmtlist stmt { }
    |
    ;

stmt: whileStmt { }
    | dec { }
    | forStmt { }
    | ifStmt { }
    | SEMI
    ;


whileStmt: WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS stmt { } 
    | WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS CompoundStmt { }
    ;

forStmt: FOR LEFT_PARENTHESIS expr SEMI expr SEMI expr RIGHT_PARENTHESIS stmt { } 
    | FOR LEFT_PARENTHESIS expr SEMI expr SEMI expr RIGHT_PARENTHESIS CompoundStmt { } 
    ;

ifStmt: IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS stmt {}
    | IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS CompoundStmt {}
    ;

structStmt: STRUCT ID BLOCK_BEGIN TYPE Assignment BLOCK_END { }
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

int main(void){
   return yyparse ( );
}

// yyin(){

// }

int yyerror(char *s) {
    printf("%d : %s %s\n", yylineno, s, yytext );
    return 0;
}