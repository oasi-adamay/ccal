%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
%}
%union {
    int          int_value;
    double       double_value;
}
%token <double_value>      DOUBLE_LITERAL
%token ADD SUB MUL DIV CR
%token CMPEQ CMPNE CMPLE CMPLT CMPGE CMPLE 
%type <double_value> expression equality_expression relational_expression additive_expression multiplicative_expression primary_expression
%%
line_list
    : line
    | line_list line
    ;
line
    : expression CR
    {
        printf(">>%lf\n", $1);
    }
expression
	: equality_expression
equality_expression
	: relational_expression
	| equality_expression CMPEQ relational_expression 
    {
        $$ = $1 == $3;
    }
	| equality_expression CMPNE relational_expression 
    {
        $$ = $1 != $3;
    }
	;
relational_expression
	: additive_expression
	| relational_expression CMPLT additive_expression
    {
        $$ = $1 < $3;
    }
	| relational_expression CMPGT additive_expression
    {
        $$ = $1 > $3;
    }
	| relational_expression CMPLE additive_expression
    {
        $$ = $1 <= $3;
    }
	| relational_expression CMPGE additive_expression
    {
        $$ = $1 >= $3;
    }
	;
additive_expression
    : multiplicative_expression
    | additive_expression ADD multiplicative_expression
    {
        $$ = $1 + $3;
    }
    | additive_expression SUB multiplicative_expression
    {
        $$ = $1 - $3;
    }
    ;
multiplicative_expression
    : primary_expression
    | multiplicative_expression MUL primary_expression 
    {
        $$ = $1 * $3;
    }
    | multiplicative_expression DIV primary_expression
    {
        $$ = $1 / $3;
    }
    ;
primary_expression
    : DOUBLE_LITERAL
    ;                 
%%
int
yyerror(char const *str)
{
    extern char *yytext;
    fprintf(stderr, "parser error near %s\n", yytext);
    return 0;
}

int main(void)
{
    extern int yyparse(void);
    extern FILE *yyin;

    yyin = stdin;
    if (yyparse()) {
        fprintf(stderr, "Error!\n");
        exit(1);
    }
}