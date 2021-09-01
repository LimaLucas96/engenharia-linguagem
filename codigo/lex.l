%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern int yyerror (char *msg);  
%}

%%

[ \t]                 ;
[ \n]                 { yylineno = yylineno + 1;}
","                   {return(COMMA);}
"int"                 {yylval.sValue = strdup(yytext); 
                       return TYPE;}
"float"               {yylval.sValue = strdup(yytext); 
                       return TYPE;}
"char"                {yylval.sValue = strdup(yytext); 
                       return TYPE;}
"void"                {yylval.sValue = strdup(yytext); 
                       return TYPE;}
"double"              {yylval.sValue = strdup(yytext); 
                       return TYPE;}
"for"                 {return (FOR);}
"struct"              {return(STRUCT);}

[0-9]+           		  { yylval.iValue = atoi(yytext); return NUMBER;}
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

">"                   {return (GT);}
"<"                   {return (LT);}
"<="                  {return (LE);}
">="                  {return (GE);}
"=="                  {return (EQ);}
"!="                  {return (NE);}

"("                   {return(LEFT_PARENTHESIS);}
")"                   {return(RIGHT_PARENTHESIS);}
"["                   {return(LEFT_COCHETE);}
"]"                   {return(RIGHT_COCHETE);}

[a-zA-Z][a-zA-Z0-9]*	{yylval.sValue = strdup(yytext); return ID;}
.                       {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif
