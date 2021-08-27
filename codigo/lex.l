%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern int yyerror (char *msg);  
%}

%%

[ \t]                 ;
[ \n]                 { yylineno = yylineno + 1;}
"int"                 {return (INT);}
"float"               {return (FLOAT);}
"char"                {return (CHAR);}
"void"                {return (VOID);}
"double"              {return (DOUBLE);}
"for"                 {return (FOR);}
"struct"              {return(STRUCT);}

[0-9]+           		  { return NUMBER;}
"while"      			    {return(WHILE);}
"inicio"      			  {return(BLOCK_BEGIN);}
"fim"      			      {return(BLOCK_END);}
"se"      			      {return(IF);}
"entao"      			    {return(ELSE);}
";"      				      {return(SEMI);}

"="					          {return(ASSIGN);}
"+"                   {return(PLUS);}
"-"                   {return(MINUS);}
"*"                   {return(TIMES);}
"/"                   {return(DIVIDE);}

"<="                  {return (LE);}
">="                  {return (GE);}
"=="                  {return (EQ);}
"!="                  {return (NE);}
">"                   {return (GT);}
"<"                   {return (LT);}

"("                   {return(LEFT_PARENTHESIS);}
")"                   {return(RIGHT_PARENTHESIS);}
"["                   {return(LEFT_COCHETE);}
"]"                   {return(RIGHT_COCHETE);}

[a-zA-Z][a-zA-Z0-9]*	{return ID;}
.                       {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif
