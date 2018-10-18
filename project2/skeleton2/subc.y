%{
/*
 * File Name   : subc.y
 * Description : a skeleton bison input
 */

#include "subc.h"

int    yylex ();
int    yyerror (char* s);
void 	REDUCE(char* s);

%}

/* yylval types */
%union {
	int		intVal;
	char	*stringVal;
}

/* Precedences and Associativities */
%left	','
%left 	STRUCTOP

/* Token and Types */
%token 				TYPE STRUCT
%token<stringVal>	ID CHAR_CONST STRING STRUCTOP
%token<intVal>		INTEGER_CONST

%%
program: ext_def_list	{
            REDUCE("program->ext_def_list");
        }
   ;
ext_def_list: ext_def_list ext_def	{
            REDUCE("ext_def_list->ext_def_list ext_def");
        }
   | /* empty */	{
            REDUCE("ext_def_list->epsilon");
        }
   ;
ext_def: TYPE def ';'	{}
   | /* empty */	{}
   ;
def: def ',' def	{}
   | unary	{}
   ;
unary: INTEGER_CONST {
            REDUCE("unary -> INTEGER_CONST");
        }
   | CHAR_CONST	{
            REDUCE("unary -> CHAR_CONST");
        }
   | STRING {
            REDUCE("unary -> STRING");
        }
   | ID {
            REDUCE("unary -> ID");
        }
   ;

%%

/*  Additional C Codes 
 	Implemnt REDUCE function here */

int    yyerror (char* s)
{
	fprintf (stderr, "%s\n", s);
}

void 	REDUCE( char* s)
{
	printf("%s\n",s);
}

