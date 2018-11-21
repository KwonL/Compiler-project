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
	int		 intVal;
	double		 floatVal;
	char		*stringVal;
	struct id	*idPtr;
	struct decl	*declPtr;
	struct ste	*stePtr;
}

/* Precedences and Associativities */
%left   ','
%right  ASSINGOP    '='
%left   LOGICAL_OR
%left   LOGICAL_AND
%left   '&'
%left   EQUOP
%left   RELOP
%left   '+'    '-'
%left   '*'    '%'    '/'
%right  '!'    INCOP   DECOP
%left 	STRUCTOP '[' ']' '(' ')'  '.'

/* Token and Types */
%token 				STRUCT
%token<stringVal>	CHAR_CONST STRING
%token<intVal>		INTEGER_CONST
%token              RETURN
%type<declPtr>		type_specifier struct_specifier unary binary expr expr_e or_expr or_list and_expr and_list const_expr args func_decl
%token<idPtr>		ID INT CHAR TYPE VOID
// ELSE and THEN have no associativity. ELSE has higher precedence, so can resolve conflict
%nonassoc               THEN
%nonassoc              ELSE
%token              IF
%token              WHILE
%token              FOR
%token              BREAK
%token              CONTINUE

%%
program
		: ext_def_list
		;

ext_def_list
		: ext_def_list ext_def
		| /* empty */
		;

ext_def
		: type_specifier pointers ID ';'
		| type_specifier pointers ID '[' const_expr ']' ';'
		| func_decl ';'
		| type_specifier ';'
		| func_decl compound_stmt

type_specifier
		: TYPE
		| VOID
		| struct_specifier

struct_specifier
		: STRUCT ID '{' def_list '}'
		| STRUCT ID

func_decl
		: type_specifier pointers ID '(' ')'
		| type_specifier pointers ID '(' VOID ')'
		| type_specifier pointers ID '(' param_list ')'

pointers
		: '*'
		| /* empty */

param_list  /* list of formal parameter declaration */
		: param_decl
		| param_list ',' param_decl

param_decl  /* formal parameter declaration */
		: type_specifier pointers ID
		| type_specifier pointers ID '[' const_expr ']'

def_list    /* list of definitions, definition can be type(struct), variable, function */
		: def_list def
		| /* empty */

def
		: type_specifier pointers ID ';'
		| type_specifier pointers ID '[' const_expr ']' ';'
		| type_specifier ';'
		| func_decl ';'

compound_stmt
		: '{' local_defs stmt_list '}'

local_defs  /* local definitions, of which scope is only inside of compound statement */
		:	def_list

stmt_list
		: stmt_list stmt
		| /* empty */

stmt
		: expr ';'
		| compound_stmt
		| RETURN ';'
		| RETURN expr ';'
		| ';'
		| IF '(' expr ')' stmt %prec THEN
		| IF '(' expr ')' stmt ELSE stmt
		| WHILE '(' expr ')' stmt
		| FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
		| BREAK ';'
		| CONTINUE ';'

expr_e
		: expr
		| /* empty */

const_expr
		: expr

expr
		: unary '=' expr
		| or_expr

or_expr
		: or_list

or_list
		: or_list LOGICAL_OR and_expr
		| and_expr

and_expr
		: and_list

and_list
		: and_list LOGICAL_AND binary
		| binary

binary
		: binary RELOP binary
		| binary EQUOP binary
		| binary '+' binary
		| binary '-' binary
		| unary %prec '='

unary
		: '(' expr ')'
		| '(' unary ')' 
		| INTEGER_CONST
		| CHAR_CONST
		| STRING
		| ID
		| '-' unary	%prec '!'
		| '!' unary
		| unary INCOP
		| unary DECOP
		| INCOP unary
		| DECOP unary
		| '&' unary	%prec '!'
		| '*' unary	%prec '!'
		| unary '[' expr ']'
		| unary '.' ID
		| unary STRUCTOP ID
		| unary '(' args ')'
		| unary '(' ')'

args    /* actual parameters(function arguments) transferred to function */
		: expr
		| args ',' expr
%%

/*  Additional C Codes here */

int    yyerror (char* s)
{
	fprintf (stderr, "%s\n", s);
}

void print_error(const char *s) {
	return;
}

struct decl* maketypedecl(int type) {
    struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

    new_node->declclass = 3; // TYPE
	switch (type) {
		case INT :
			new_node->typeclass = 0;
			break;
		case CHAR :
			new_node->typeclass = 1;
			break;
		case VOID :
			new_node->typeclass = 5;
			break;
	}

	return new_node;
}

void declare(struct id* arg_id, struct decl* arg_decl) {
	/*
	 * This is for debugging
	 */
	// printf("declare called!\n");
	// struct ste* test_node = top->ste; 
	// while (test_node != NULL) {
	// 	printf("cur node's name is : %s\n", test_node->name->name);
	// 	test_node = test_node->prev;
	// }
	// if (arg_id == NULL || arg_decl == NULL) return;

	struct ste* ste_top = top->ste;
	struct ste* new_ste = (struct ste *)malloc(sizeof(struct ste));

	// Checking redeclaration
	struct ste* cur_node = top->ste;
	while(cur_node != NULL){
		if(top->prev!=NULL && cur_node == top->prev->ste)
			break;
		if(cur_node->name == arg_id && !(cur_node->decl == arg_decl->type) ){
			print_error("redeclaration");
			return;
		}
		cur_node = cur_node->prev;
	}

	// Is global?
	arg_decl->isglobal = (top->prev == NULL);

	// Push decl to the top of ste
	new_ste->prev = ste_top;
	top->ste = new_ste;

	// Set value of ste node
	top->ste->decl = arg_decl;
	top->ste->name = arg_id;

	return;
}