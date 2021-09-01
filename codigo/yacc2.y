%{
#include <stdio.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

struct idsReturnType{
    char * code;
    int n;
    char * ids;
};

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
    struct idsReturnType * idsValue;
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

%type <sValue> Assignment dec funcCall array func argListOpt argList arg CompoundStmt stmtlist stmt whileStmt forStmt ifStmt structStmt expr

%%

prog: func { 
            printf("%s",$1);

            printf("\n\nFIM\n");
            // free($1);
        } 
    | dec {  
            printf("%s",$1);

            printf("\n\nFIM\n");
            free($1);
        } 
    ;

dec: TYPE Assignment SEMI { 
                    // printf("tip %s\n", $2);
                    int size = strlen($1) + strlen($2) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s, "%s %s;", $1, $2);
                    free($2);
                    $$ = s;
                } 
    | Assignment SEMI {  
                    int size = strlen($1) + 2;
                    // printf("dec %s\n", $1);
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s;",$1);
                    free($1);
                    $$ = s; 
                }
    | funcCall SEMI {}
    | array SEMI {}
    | TYPE array SEMI {}
    | structStmt SEMI {}
    ;
//expression
Assignment: ID ASSIGN Assignment {  
                    // printf("igal %s\n", $3);
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | ID ASSIGN funcCall {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | ID ASSIGN array {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | array ASSIGN Assignment {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s = %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | NUMBER COMMA Assignment {  
                    int size = sizeof(int) + strlen($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d, %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | ID PLUS Assignment {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s + %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | ID MINUS Assignment {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s - %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | ID TIMES Assignment {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s * %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | ID DIVIDE Assignment {  
                    int size = strlen($1) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s / %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | NUMBER PLUS Assignment {  
                    int size = sizeof(int) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d + %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | NUMBER MINUS Assignment {  
                    int size = sizeof(int) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d - %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | NUMBER TIMES Assignment {  
                    int size = sizeof(int) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d * %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | NUMBER DIVIDE Assignment {  
                    int size = sizeof(int) + strlen($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d / %s",$1, $3);
                    free($3);
                    $$ = s; 
                }
    | LEFT_PARENTHESIS Assignment RIGHT_PARENTHESIS {  
                    int size = strlen($2) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"(%s)",$2);
                    free($2);
                    $$ = s; 
                }
    | NUMBER { 
        // printf("num\n");
                    int size = sizeof(int);
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%d",$1);
                    $$ = s; 

            }
    | ID { 
        int size = strlen($1) +1;
                char * s = malloc(sizeof(char) * size);
                sprintf(s,"%s",$1);
                $$ = $1; 
        }
    ;

funcCall: ID LEFT_PARENTHESIS RIGHT_PARENTHESIS { 
                    int size = sizeof($1)+ 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s()",$1);
                    $$ = s; 
            }
    | ID LEFT_PARENTHESIS Assignment RIGHT_PARENTHESIS { 
                    int size = sizeof($1) + sizeof($3)+ 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s(%s)",$1, $3);
                    free($3);
                    $$ = s; 
            }
    ;

array: ID LEFT_COCHETE Assignment RIGHT_COCHETE { 
                    int size = sizeof($1) + sizeof($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s[%s]",$1, $3);
                    free($3);
                    $$ = s; 
            }
    ;

func: TYPE ID LEFT_PARENTHESIS argListOpt RIGHT_PARENTHESIS CompoundStmt  { 

                    int size = sizeof($1) + sizeof($2) + sizeof($4) + sizeof($6) + 5;
                    char * s = malloc(sizeof(char) * size);

                    sprintf(s,"%s %s(%s) %s",$1, $2, $4, $6);
                    free($6);
                    $$ = s; 

                    // printf("%s %s(%s) %s",$1, $2, $4, $6);
                    
            }
    ;

argListOpt: argList { $$ = $1; }
    | { $$ =""; }
    ;

argList: argList COMMA arg { 
                    int size = sizeof($1) + sizeof($3) + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s, %s",$1, $3);
                    free($1);
                    free($3);
                    $$ = s; 
            } 
    | arg { $$ = $1; }
    ;

arg: TYPE ID { 
                    int size = sizeof($1) + sizeof($2) + 2;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s %s",$1, $2);
                    $$ = s; 
            } 
    ;

CompoundStmt: BLOCK_BEGIN ID stmtlist BLOCK_END ID { 
                    int size = sizeof($3) + 5;
                    printf("Open ID %d\n", ID);
                    char * s = malloc(sizeof(char) * size);
                    // printf("{%s}", $3);
                    sprintf(s,"{\n%s\n}",$3);
                    printf("main -> %s\n", $3);
                    free($3);
                    printf("CLOSE ID %d\n", ID);
                    $$ = s; 
                    // printf("{}");
            }  
    | BLOCK_BEGIN WHILE stmtlist BLOCK_END WHILE { 
                    int size = sizeof($3) + 5;
                    // printf("SIZE-> %d\n", size);
                    char * s = malloc(sizeof(char) * size);
                    // printf("{%s}", $3);
                    sprintf(s,"{\n%s\n}",$3);
                    free($3);
                    $$ = s; 
                    // printf("{}");
            } 
    | BLOCK_BEGIN FOR stmtlist BLOCK_END FOR { 
                    // printf("stm -> %s\n", $3);
                    int size = sizeof($3) + 5;
                    char * s = malloc(sizeof(char) * size);
                    // sprintf(s,"{\n%s\n}",$3);
                    // free($3);
                    $$ = s; 
            }
    | BLOCK_BEGIN IF stmtlist BLOCK_END IF { 
                    printf("OPEN BLOCO IF\n");
                    int size = sizeof($3) + 6;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"{\n%s\n}",$3);
                    printf("CLOSE BLOCO IF\n");
                    free($3);
                    $$ = s; 
            }
    ;

stmtlist: stmtlist stmt  { 
                    
                    printf("OPEN STMT\n");
                    int size =sizeof($1) + sizeof($2) + 4;
                    
                    char * s = malloc(sizeof(char) * size);
                    printf("\n --> exe{[%s] %s}<--\n", $1,$2);
                    sprintf(s,"%s\n%s",$1, $2);
                    
                    // printf("exe2{%s}\n", $2);
                    free($1);
                    printf("f1{%s}\n", $1);
                    printf("f2{%s}\n", $2);
                    free($2);
                    printf("f1{%s}\n", $1);
                    printf("f2{%s}\n", $2);
                    
                    printf("CLOSE STMT\n");
                    
                    $$ = s; 
            }
    | stmt { printf("tem ND -> %s\n", $1);
        // char * s = malloc(sizeof(char) * 1);
        $$=$1; }
    ;

stmt: whileStmt { $$ = $1; }
    | dec       { $$ = $1; }
    | forStmt   { $$ = $1; }
    | ifStmt    { $$ = $1; }
    | SEMI      { 
                    // int size = 3;
                    // char * s = malloc(sizeof(char) * size);
                    // sprintf(s,";\n");
                    $$ = ";\n"; 
            }
    ;


whileStmt: WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS stmt { 
                    int size = sizeof($3) + sizeof($5) + 9;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"while(%s) %s",$3, $5);
                    free($3);
                    free($5);
                    $$ = s; 
            } 
    | WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS CompoundStmt { 
                    int size = sizeof($3) + sizeof($5) + 9;
                    // printf("-> %s", $5);
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"while(%s) %s",$3, $5);
                    // free($3);
                    free($5);
                    $$ = s; 
            }
    ;

forStmt: FOR LEFT_PARENTHESIS expr SEMI expr SEMI expr RIGHT_PARENTHESIS stmt { 
                    int size = sizeof($3) + sizeof($5) + sizeof($7) + sizeof($9) + 11;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"for(%s; %s; %s) %s",$3, $5, $7, $9);
                    // free($3);
                    // free($5);
                    // free($7);
                    // free($9);
                    $$ = s; 
            }  
    | FOR LEFT_PARENTHESIS expr SEMI expr SEMI expr RIGHT_PARENTHESIS CompoundStmt { 
                    int size = sizeof($3) + sizeof($5) + sizeof($7) + sizeof($9) + 11;
                    // printf("for(%s; %s; %s) %s",$3, $5, $7, $9);
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"for(%s; %s; %s) %s",$3, $5, $7, $9);
                    // free($3);
                    // free($5);
                    // free($7);
                    // free($9);
                    $$ = s; 
            } 
    ;

ifStmt: IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS stmt { 
                    int size = sizeof($3) + sizeof($5) + 6;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"if(%s) %s",$3, $5);
                    free($3);
                    free($5);
                    $$ = s; 
            }
    | IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS CompoundStmt { 
                    printf("Open if\n");
                    int size = sizeof($3) + sizeof($5) + 6;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"if(%s) %s",$3, $5);
                    
                    free($5);
                    free($3);
                    printf("CLOSE IF\n");
                    $$ = s; 
            }
    ;

structStmt: STRUCT ID BLOCK_BEGIN TYPE Assignment BLOCK_END { 
                    int size = sizeof($2) + sizeof($4) + sizeof($5) + 17 + 3 + 3;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"typedef struct{\n%s\n}%s;",$5, $2);
                    free($5);
                    $$ = s; 
            }
    ;

expr: expr LE expr { 
                    int size = sizeof($1) + sizeof($3) + 5;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s <= %s",$1, $3);
                    free($1);
                    free($3);
                    $$ = s; 
            }
    | expr GE expr { 
                    int size = sizeof($1) + sizeof($3) + 5;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s >= %s",$1, $3);
                    free($1);
                    free($3);
                    $$ = s; 
            }
    | expr NE expr { 
                    int size = sizeof($1) + sizeof($3) + 5;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s != %s",$1, $3);
                    free($1);
                    free($3);
                    $$ = s; 
            }
    | expr EQ expr { 
                    int size = sizeof($1) + sizeof($3) + 5;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s == %s",$1, $3);
                    // free($1);
                    // free($3);
                    $$ = s; 
            }
    | expr GT expr { 
                    int size = sizeof($1) + sizeof($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s > %s",$1, $3);
                    free($1);
                    free($3);
                    $$ = s; 
            }
    | expr LT expr { 
                    int size = sizeof($1) + sizeof($3) + 4;
                    char * s = malloc(sizeof(char) * size);
                    sprintf(s,"%s < %s",$1, $3);
                    // free($1);
                    // free($3);
                    $$ = s; 
            }
    | Assignment { $$ = $1; }
    | array      { $$ = $1; }
    |  { $$ = "";}
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