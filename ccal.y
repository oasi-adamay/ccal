%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
%}
%union {
    int          int_value;
    double       double_value;
}
%token <int_value>      INT_LITERAL
%token ADD SUB MUL DIV CR
%token CMPEQ CMPNE CMPLE CMPLT CMPGE CMPLE 
%token HATENA COLON
%token ANDAND OROR OR XOR AND
%type <int_value> expression equality_expression relational_expression
%type <int_value> additive_expression multiplicative_expression primary_expression
%type <int_value> conditional_expression logical_or_expression logical_and_expression inclusive_or_expression exclusive_or_expression and_expression

%%
line_list
    : line
    | line_list line
    ;
line
    : expression CR
    {
       /* printf(">>%lf\n", $1);*/
       printf(">>%d\n", $1);
    }
expression
	: conditional_expression
conditional_expression
	: logical_or_expression
	| logical_or_expression HATENA expression COLON conditional_expression
    {
        $$ = $1 ? $3 : $5;
    }
	;	
logical_or_expression
	: logical_and_expression
	| logical_or_expression OROR logical_and_expression
    {
        $$ = $1 || $3;
    }
	;
logical_and_expression
	: inclusive_or_expression
    | logical_and_expression ANDAND inclusive_or_expression
    {
        $$ = $1 && $3;
    }
	;
inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression OR exclusive_or_expression
    {
        $$ = $1 | $3;
    }
	;
exclusive_or_expression
	: and_expression
	| exclusive_or_expression XOR and_expression
    {
        $$ = $1 ^ $3;
    }
	;
and_expression
	: equality_expression
	| and_expression AND equality_expression
    {
        $$ = $1 & $3;
    }
	;
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
    : INT_LITERAL
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