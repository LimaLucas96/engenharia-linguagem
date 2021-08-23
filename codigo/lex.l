%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern int yyerror (char *msg);  
%}

%%

[ \t\n]               ;
[0-9]+           		{yylval.iValue = atoi(yytext); return NUMBER;}
"while"      			{return(WHILE);}
"begin"      			{return(BLOCK_BEGIN);}
"end"      				{return(BLOCK_END);}
"do"      				{return(DO);}
"se"      				{return(IF);}
"entao"      			{return(ELSE);}
";"      				{return(SEMI);}
"="					    {return(ASSIGN);}
"+"                     {return(PLUS);}
"-"                     {return(MINUS);}
"*"                     {return(TIMES);}
"/"                     {return(DIVIDE);}
"^"                     {return(POWER);}
"("                     {return(LEFT_PARENTHESIS);}
")"                     {return(RIGHT_PARENTHESIS);}
[a-zA-Z][a-zA-Z0-9]*	{yylval.sValue = strdup(yytext); return ID;}
.                       {yyerror("invalid character");}

%%


