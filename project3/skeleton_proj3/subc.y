%{
/*
 * File Name   : subc.y
 * Description : a skeleton bison input
 */

#include "subc.h"
#include "subc.tab.h"

int    yylex ();
int    yyerror (char* s);

%}

/* yylval types */
%union {
	int		intVal;
	char	*stringVal;
}

/* Precedences and Associativities */
%left	','

/* Token and Types */
%token TYPE STRUCT RETURN IF ELSE WHILE FOR BREAK CONTINUE LOGICAL_OR LOGICAL_AND INCOP DECOP STRUCTOP VOID STRING CHAR_CONST ID INTEGER_CONST

%%
program
    : ext_def_list
    ;

    /*fill in here*/
    
%%

/*  Additional C Codes here */

int    yyerror (char* s)
{
	fprintf (stderr, "%s\n", s);
}

