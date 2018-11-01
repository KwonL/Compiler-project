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
%left   ','
%right  ASSIGNOP    '='
%left   LOGICAL_OR
%left   LOGICAL_AND
%left   '|'
%left   '&'
%left   EQUOP
%left   RELOP
%left   '+'    '-'
%left   '*'    '%'    '/'
%right  '!'    PLUS_PLUS   MINUS_MINUS
%left 	STRUCTOP

/* Token and Types */
%token 				TYPE STRUCT
%token<stringVal>	ID CHAR_CONST STRING STRUCTOP
%token<intVal>		INTEGER_CONST
%token              RETURN
%token              IF
%token              ELSE
%token              WHILE
%token              FOR
%token              BREAK
%token              CONTINUE

%%
program: 
    ext_def_list	{
        REDUCE("program->ext_def_list");
    }
    ;
ext_def_list: 
    ext_def_list ext_def {
        REDUCE("ext_def_list->ext_def_list ext_def")
    }
	| /* empty */ {
        REDUCE("ext_def_list->epsilon")
    }
    ;
ext_def: 
    opt_specifier ext_decl_list ';' {
        REDUCE("ext_def_list->opt_specifier ext_decl_list ';'");
    }
    | opt_specifier funct_decl compound_stmt {
        REDUCE("ext_def_list->opt_specifier funct_decl compound_stmt");
    }
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

