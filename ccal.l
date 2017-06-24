%{
#include <stdio.h>
#include "y.tab.h"
#define fileno _fileno
#define isatty _isatty
 
int
yywrap(void)
{
    return 1;
}
%}
%%
"+"		return ADD;
"-"		return SUB;
"*"		return MUL;
"/"		return DIV;
"=="	return CMPEQ;
"!="	return CMPNE;
"<"		return CMPLT;
">"		return CMPGT;
"<="	return CMPLE;
">="	return CMPGE;
"\n"		return CR;
[0-9][0-9]* {
    double temp;
    sscanf(yytext, "%lf", &temp);
    yylval.double_value = temp;
    return DOUBLE_LITERAL;
}
[0-9]*\.[0-9]* {
    double temp;
    sscanf(yytext, "%lf", &temp);
    yylval.double_value = temp;
    return DOUBLE_LITERAL;
}
%%