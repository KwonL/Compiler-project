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
%type<intVal> pointers
%token              RETURN
%token				NULL_TOKEN
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
%token				WRITE_INT WRITE_CHAR WRITE_STRING READ_INT READ_CHAR

%%
program
		: ext_def_list
		;

ext_def_list
		: ext_def_list ext_def
		| /* empty */
		;

ext_def
		: type_specifier pointers ID ';' {
			declare($3, makevardecl(makepointerdecl($2, $1)));
		}
		| type_specifier pointers ID '[' const_expr ']' ';' {
			declare($3, makeconstdecl(makearraydecl($5, makevardecl(makepointerdecl($2, $1)))));
		}
		| func_decl ';' {
			// Do nothing
		}
		| type_specifier ';' {
			// do nothing
		}
		| func_decl {
			push_scope($1->size + 1);
			struct ste* stelist = $1 != NULL ? $1->formals : NULL;
			while(stelist != NULL) {
				declare(stelist->name, stelist->decl);
				stelist = stelist->prev;
			}

			struct id* func_id = lookup_id($1);
			if (func_id != NULL) 
				fprintf(output_file, "%s :\n ", func_id->name);
		}  compound_stmt {
			free_ste_list(pop_scope());
			fprintf(output_file,"%s_final :\n", lookup_id($1)->name);
			fprintf(output_file, "\tpush_reg fp\n");
			fprintf(output_file, "\tpop_reg sp\n");
			fprintf(output_file, "\tpop_reg fp\n");
			fprintf(output_file, "\tpop_reg pc\n");
			fprintf(output_file,"%s_end :\n", lookup_id($1)->name);
		}

type_specifier
		: TYPE {
			$$ = lookup_whole($1);
		}
		| VOID {
			$$ = voidtype;
		}
		| struct_specifier {
			$$ = $1;
		}

struct_specifier
		: STRUCT ID {
			// Check if there are already declared struct
			check_struct_isdefined($2);
		} '{' { push_scope(0); } def_list '}' {

			struct ste* fieldlist = pop_scope();
			struct ste* cur = fieldlist;
			while (cur != NULL) {
				cur = cur->prev;
			}
			declare_struct($2, $$ = makestructdecl(fieldlist));
		}
		| STRUCT ID {
			struct decl* declptr = lookup_struct($2);
			check_is_struct_type(declptr);
			$$ = declptr;
		}

func_decl
		: type_specifier pointers ID '(' ')' {
			struct decl* procdecl = makeprocdecl();
			cur_func = procdecl;
			declare($3, procdecl);

			push_scope(1); 
			declare(returnid, makepointerdecl($2, $1));

			struct ste* formals;
			formals = pop_scope();
			add_formals(procdecl, formals);

			$$ = lookup_whole($3);
		}
		| type_specifier pointers ID '(' VOID ')' {
			struct decl* procdecl = makeprocdecl();
			cur_func = procdecl;
			declare($3, procdecl);

			push_scope(1); 
			declare(returnid, makepointerdecl($2, $1));

			struct ste* formals;
			formals = pop_scope();
			add_formals(procdecl, formals);

			$$ = lookup_whole($3);
		}
		| type_specifier pointers ID '(' {
			struct decl* procdecl = makeprocdecl();
			cur_func = procdecl;
			declare($3, procdecl);

			push_scope(1);
			declare(returnid, makepointerdecl($2, $1));
			$<declPtr>$ = procdecl;
		} param_list ')' {
			struct ste* formals;
			struct decl* procdecl = $<declPtr>5;
			formals = pop_scope();
			add_formals(procdecl, formals);

			$$ = lookup_whole($3);
		}

pointers
		: '*' {
			$$ = 1;
		}
		| /* empty */ {
			$$ = 0;
		}

param_list  /* list of formal parameter declaration */
		: param_decl
		| param_list ',' param_decl

param_decl  /* formal parameter declaration */
		: type_specifier pointers ID {
			declare($3, makevardecl(makepointerdecl($2, $1)));
		}
		| type_specifier pointers ID '[' const_expr ']' {
			declare($3, makeconstdecl(makearraydecl($5, makevardecl(makepointerdecl($2, $1)))));
		}

def_list    /* list of definitions, definition can be type(struct), variable, function */
		: def_list def {
			// do nothing
		}
		| /* empty */ {
			// do nothing
		}

def
		: type_specifier pointers ID ';' {
			declare($3, makevardecl(makepointerdecl($2, $1)));
		}
		| type_specifier pointers ID '[' const_expr ']' ';' {
			declare($3, makeconstdecl(makearraydecl($5, makevardecl(makepointerdecl($2, $1)))));
		}
		| type_specifier ';' {
			// do nothing
		}
		| func_decl ';' {
			// do nothing
		}

compound_stmt
		: '{' {

		} local_defs stmt_list '}' {
			
		}

local_defs  /* local definitions, of which scope is only inside of compound statement */
		:	def_list

stmt_list
		: stmt_list stmt
		| /* empty */

stmt
		: expr ';' {
			fprintf(output_file, "\tshift_sp -%d\n", $1->size);
		}
		| { push_scope(top->counter); }compound_stmt { free_ste_list(pop_scope()); }
		| RETURN ';' {
			// Check return type
			struct decl* func_decl = lookup_func();

			if (func_decl != NULL && func_decl->returntype != voidtype) {
				print_error("return value is not return type");
			}
		}
		| RETURN expr ';' {
			struct decl* func_decl = lookup_func();
			
			if (func_decl != NULL && $2 != NULL) {
				if ($2->declclass != 0 && $2->declclass != 1) {
					print_error("not const or variable");
				} else {
					check_return_type_compatibility(func_decl->returntype, $2->type);
				}
			}
		}
		| ';'
		| IF '(' expr ')' stmt %prec THEN
		| IF '(' expr ')' stmt ELSE stmt
		| WHILE '(' expr ')' stmt
		| FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
		| BREAK ';'
		| CONTINUE ';'
		| WRITE_INT {

		}

expr_e
		: expr
		| /* empty */

const_expr
		: expr

expr
		: unary {
			fprintf(output_file, "\tpush_reg sp\n");
			fprintf(output_file, "\tfetch\n");

		} '=' expr {
			if ($1 == NULL || $1->declclass != 0) print_error("LHS is not a variable");
			if ($4 == NULL || ($4->declclass != 0 && $4->declclass != 1)) {
				print_error("RHS is not a const or variable");
			}
			else 
				check_compatibility($1, $4, 1);
			$$ = clonedecl($1);

			fprintf(output_file, "\tassign\n");
			fetch_val($1);
		}
		| or_expr {
			$$ = $1;
		}

or_expr
		: or_list {
			$$ = $1;
		}

or_list
		: or_list LOGICAL_OR and_expr {
			if ($1 != NULL && $3 != NULL) 
				if ($1->type != inttype || $3->type != inttype) 
					print_error("not int type");

			$$ = $1;
		}
		| and_expr {
			$$ = $1;
		}

and_expr
		: and_list {
			$$ = $1;
		}

and_list
		: and_list LOGICAL_AND binary {
			if ($1 != NULL && $3 != NULL)
				if ($1->type != inttype || $3->type != inttype) 
					print_error("not int type");

			$$ = makeconstdecl(inttype);
		}
		| binary {
			$$ = $1;
		}

binary
		: binary RELOP binary {
			$$ = makeconstdecl(inttype);
			if ($1 != NULL && $3 != NULL) {
				if ($1->type != inttype && $1->type != chartype || $3->type != inttype && $3->type != chartype) { 
					print_error("not int or char type");
					$$ = NULL;
				} else {
					if ($1->type != $3->type) {
						print_error("not comparable");
						$$ = NULL;
					}			
				}
			}
		}
		| binary EQUOP binary {
			$$ = makeconstdecl(inttype);
			if ($1 != NULL && $3 != NULL) {
				if ($1->type != inttype && $1->type != chartype && $1->type->typeclass != 3 || $3->type != inttype && $3->type != chartype && $3->type->typeclass != 3) {
					print_error("not int or char or pointer type");
					$$ = NULL;
				} 
				if ($1->type->typeclass == 3 && $3->type->typeclass == 3) {
					if (!check_compatibility($1, $3, 0)) {
						print_error("not comparable");
						$$ = NULL;
					}
				}
				else if ($1->type != $3->type) {
					print_error("not comparable");
					$$ = NULL;
				}
			}
		}
		| binary '+' binary {
			if ($1 != NULL && $3 != NULL) {
				if ($1->type->typeclass == 0 && $3->type->typeclass == 0) {
					// int + int 
					$$ = clonedecl($1);
					if ($$ != NULL)
						$$->declclass = 1; // CONST
				}
				else {
					print_error("not int type");
				}
			}

			fprintf(output_file, "\tadd\n");
		}
		| binary '-' binary {
			if ($1 != NULL && $3 != NULL) {
				if ($1->type->typeclass == 0 && $3->type->typeclass == 0) {
					// int + int 
					$$ = clonedecl($1);
					if ($$ != NULL) 
						$$->declclass = 1;
				}
				else {
					print_error("not int type");
				}
			}

			fprintf(output_file, "\tsub\n");
		}
		| unary %prec '=' {
			$$ = $1;

			fetch_val($1);
		}

unary
		: '(' expr ')' {
			$$ = $2;
		}
		| '(' unary ')' {
			$$ = $2;
		}
		| INTEGER_CONST {
			$$ = makeintconstdecl($1);

			fprintf(output_file, "\tpush_const %d\n", $1);
		}
		| CHAR_CONST {
			$$ = makecharconstdecl($1);

			fprintf(output_file, "\tpush_const %d\n", $1[0]);
		}
		| STRING {
			$$ = addpointer(makecharconstdecl($1)); 

			fprintf(output_file, "Str%d. string %s\n", string_counter, $1);
			fprintf(output_file, "\tpush_const Str%d", string_counter);
			string_counter++;
		}
		| NULL_TOKEN {
			$$ = makeconstdecl(makepointerdecl(1, voidtype));
		}
		| ID {
			$$ = clonedecl(lookup_whole($1));
			
			if ($$ == NULL) print_error("not declared");

			if ($$->isglobal) {
				fprintf(output_file, "\tpush_const Lglob+%d\n", $$->offset);
			} else {
				fprintf(output_file, "\tpush_reg fp\n");
				fprintf(output_file, "\tpush_const %d\n", $$->offset);
				// Address of variable. We need to fetch actual value in operation.
				fprintf(output_file, "\tadd\n");
			}
		}
		| '-' unary	%prec '!' {
			$$ = $2;
			if ($$ != NULL)
				$$->declclass = 1;
			if ($2 != NULL && $2->type != inttype) print_error("not int type");
		}
		| '!' unary {
			$$ = $2;
			if ($$ != NULL) 
				$$->declclass = 1;
			if ($2 != NULL && $2->type != inttype) print_error("not int type");
		}
		| unary INCOP {
			$$ = $1; 
			check_incable($1);
		}
		| unary DECOP {
			$$ = $1;
			check_incable($1);
		}
		| INCOP unary {
			$$ = $2;
			check_incable($2);
		}
		| DECOP unary {
			$$ = $2;
			check_incable($2);
		}
		| '&' unary	%prec '!' {
			$$ = addpointer($2);

			if ($2 != NULL && $2->declclass != 0) {
				print_error("not variable");
			}
		}
		| '*' unary	%prec '!' {
			$$ = reference_ptr($2);

			fetch_val($2);
		}
		| unary '[' expr ']' {
			$$ = reference_array($1, $3);
		}
		| unary '.' ID {
			$$ = reference_struct($1, $3);
		}
		| unary STRUCTOP ID {
			$$ = reference_struct(reference_ptr($1), $3);
		}
		| unary '(' args ')' {
			struct decl* arg_list = $3;
			struct ste* form_cursor = $1->formals;
			while (arg_list != NULL && form_cursor != NULL) {
				if (!check_compatibility(arg_list, form_cursor->decl, 0)) {
					print_error("actual args are not equal to formal args");
					break;
				}
				arg_list = arg_list->next;
				form_cursor = form_cursor->prev;
			}
			if (arg_list != NULL || form_cursor != NULL) {
				print_error("actual args are not equal to formal args");
			}

			if ($1 != NULL) 
				$$ = makeconstdecl($1->returntype);
			else 
				$$ = NULL;
		}
		| unary '(' ')' {
			if ($1 != NULL && $1->declclass != 2) 
				print_error("not a function");
			if ($1 != NULL && $1->formals != NULL) {
				print_error("actual args are not equal to formal args");
			}
			if ($1 != NULL) 
				$$ = makeconstdecl($1->returntype);
			else 
				$$ = NULL;
		}

args    /* actual parameters(function arguments) transferred to function */
		: expr {
			$$ = clonedecl($1);
			$$->next = NULL;
		}
		| args ',' expr {
			struct decl* cur_node = $1;
			while (cur_node->next != NULL) 
				cur_node = cur_node->next;
			cur_node->next = $3;
			$3->next = NULL;
			$$ = $1;
		}
%%

/*  Additional C Codes here */

int    yyerror (char* s)
{
	fprintf (stderr, "%s\n", s);
}

// Print error message only once in one line
static int err_count = 0;
static int now_line = 0;
void print_error(const char *s) {
	if (now_line != read_line()) {
		now_line = read_line();
		err_count = 0;
	}
	if (!err_count) {
		// printf("%s:%d:error:%s\n", get_filename(), read_line(), s);
		err_count ++;
		return;
	}
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

struct decl* makevardecl(struct decl* typedecl) {
	if (typedecl == NULL) 
		return NULL;
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 0; // VAR
	new_node->type = typedecl;
	new_node->size = 1;
	new_node->origin = new_node;

	return new_node;
}

struct decl* makepointerdecl(int isPtr, struct decl* typedecl) {
	if (typedecl == NULL)
		return NULL;
	// Not a pointer. Just return type 
	if (!isPtr) {
		return typedecl;
	}
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 3; // TYPE
	new_node->typeclass = 3; // PTR
	new_node->ptrto = typedecl;
	new_node->size = 1;
	new_node->origin = new_node;

	// printf("make new pointer : %p\n", new_node);

	return new_node;
}

struct decl* makearraydecl(struct decl* const_decl, struct decl* var_decl) {
	if (const_decl == NULL || var_decl == NULL) 
		return NULL;
	// printf("makearray\n");
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	// Have to check if index is really const
	if (const_decl->declclass != 1) {
		print_error("not const or variable\n");
	}

	// Have to check if const value is int
	if (const_decl->type->typeclass != 0) {
		print_error("not int type\n");
	}
	new_node->declclass = 3; // TYPE
	new_node->typeclass = 2; // ARRAY
	new_node->elementvar = var_decl;
	new_node->num_index = const_decl->value;
	new_node->origin = new_node;
	new_node->size = const_decl->value * var_decl->size;

	return new_node;
}

struct decl* makeconstdecl(struct decl* type_decl) { 
	if (type_decl == NULL) 
		return NULL;
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 1; // CONST
	new_node->type = type_decl;
	new_node->size = type_decl != NULL ? type_decl->size : 0;
	new_node->origin = new_node;

	return new_node;
}

struct decl* makeintconstdecl(int int_const) {
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 1; // CONST
	new_node->type = inttype;
	new_node->value = int_const;
	new_node->size = 4;
	new_node->origin = new_node;

	return new_node;
}

struct decl* makecharconstdecl(char* char_const) {
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 1; // CONST
	new_node->type = chartype;
	new_node->char_value = char_const;
	new_node->size = 1;
	new_node->origin = new_node;

	return new_node;
}

struct decl* clonedecl(struct decl* arg_decl) {
	if (arg_decl == NULL) return NULL;
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	*new_node = *arg_decl;

	return new_node;	
}

struct decl* makeprocdecl() {
	// printf("checking\n");
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 2; // FUNC
	new_node->defined = 0;
	new_node->origin = new_node;

	return new_node;
}

void check_struct_isdefined(struct id* arg_id) {
	if (arg_id == NULL) return;
	struct ste* cur_node = top->ste;

	// Just check below int type
	while (cur_node != NULL) {
		if (cur_node->decl == inttype) 
			break;
		cur_node = cur_node->prev;
	}

	while (cur_node != NULL) { 
		if (cur_node->name == arg_id) {
			print_error("redeclaration");
			return;
		}
		cur_node = cur_node->prev;
	}
}

struct decl* makestructdecl(struct ste* arg_list) {
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	new_node->declclass = 3; // TYPE
	new_node->typeclass = 4; // struct
	new_node->fieldlist = arg_list;
	new_node->origin = new_node;
	new_node->size = 0;

	// Iterating over arg list to cacluate size
	struct ste* current = arg_list;
	while (current != NULL) {
		// printf("%d: cur node's name is : %s\n", read_line(), current->name->name);
		new_node->size += current->decl->size;

		current = current->prev;
	}

	return new_node;
}

struct decl* findcurrentdecl(struct id* arg_id) {
	return lookup_whole(arg_id);
}

void check_is_struct_type(struct decl* arg_decl) {
	// TYPE and STRUCT
	if (arg_decl != NULL && arg_decl->declclass == 3 && arg_decl->typeclass == 4) 
		return ;

	print_error("incomplete type error");
}

void add_formals(struct decl* procdecl, struct ste* formals) {
	if (procdecl == NULL || formals == NULL) 
		return ;

	// printf("%d: add formals called, procdecl is %p\n", read_line(), procdecl);

	procdecl->returntype = formals->decl;
	procdecl->formals = formals->prev;

	struct ste* cur_node = formals;
	procdecl->size = 0;
	while (cur_node != NULL) {
		procdecl->size += cur_node->decl->size;

		cur_node = cur_node->prev;
	}
	
	return;
}

struct decl* addpointer(struct decl* arg_decl) {
	if (arg_decl == NULL) {
		return NULL;
	}
	// printf("checking\n");
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	// printf("%d: arg decl's class is %d\n", read_line(), arg_decl->declclass);

	new_node->declclass = 1; // CONST
	new_node->origin = arg_decl;

	struct decl* new_type = (struct decl *)malloc(sizeof(struct decl));
	new_type->declclass = 4; //TYPE
	new_type->typeclass = 3; //ptr
	new_type->size = 1;

	if (arg_decl != NULL) {
		new_type->ptrto = arg_decl->type;
	}
	new_node->type = new_type;

	return  new_node;
}

void check_incable(struct decl* arg_decl) {
	// Only int, char can use incop
	// printf("arg decl's type class of type = %d\n", arg_decl->type->typeclass);
	if (arg_decl != NULL && arg_decl->declclass == 0) {
		if (arg_decl->type == inttype || arg_decl->type == chartype)
			return;
	}
	// printf("%d: arg_decl class is %d\n", read_line(), arg_decl->declclass);
	print_error("not int or char type");
}

struct decl* reference_ptr(struct decl * arg_decl) {
	if (arg_decl == NULL) return NULL;
	struct decl* new_node = (struct decl *)malloc(sizeof(struct decl));

	// printf("%d: argdecl class = %d\n", read_line(), arg_decl->declclass);
	// printf("%d: pointer is : %p\n", read_line(), arg_decl);

	new_node->declclass = 0; // VAR
	if (arg_decl != NULL) {
		new_node->origin = arg_decl->origin;
	}

	struct decl* type = arg_decl->type;
	if (type != NULL) {
		if (type->typeclass == 2) {
			// Array
			new_node->type = type->elementvar->type;
		}
		else if (type->typeclass == 3) {
			// Pointer type
			// printf("%d: ptrto is : %p, inttype : %p\n", read_line(), type->ptrto, inttype);
			new_node->type = type->ptrto;
		}
		else {
			print_error("not a pointer");
		}
	}

	return new_node;
}

struct decl* reference_array(struct decl* ptr_decl, struct decl* const_decl) {
	if (ptr_decl == NULL || ptr_decl->type == NULL || const_decl == NULL) 
		return NULL;

	// printf("%d: ptr decl class = %d\n", read_line(), ptr_decl->declclass);
	if (const_decl->type != inttype) {
		print_error("not int type");
		return NULL;
	}

	if (ptr_decl->type->typeclass == 2) {
		// printf("line : %d, type class is : %d\n", read_line(), ptr_decl->type->typeclass);
		return ptr_decl->type->elementvar;
	}
	else if (ptr_decl->type->typeclass == 3) {
		return reference_ptr(ptr_decl);
	}

	print_error("not array type");
	return NULL;
}

int check_compatibility(struct decl* arg1, struct decl* arg2, int enable) {
	// printf("%d: arg1 : %d, arg2 : %d\n", read_line(), arg1->declclass, arg2->declclass);
	// NULL blocking
	if (arg1 == NULL || arg2 == NULL) {
		if (enable)
			print_error("LHS and RHS are not same type");

		return 0;
	}

	if (arg1->declclass == 0 && (arg2->declclass == 0 || arg2->declclass == 1)) {
		if (arg1->type == arg2->type) 
			return 1;
	}
	if (arg2->declclass == 0 && (arg1->declclass == 0 || arg1->declclass == 1)) {
		if (arg1->type == arg2->type)
			return 1;
	}
	if (arg1->type != NULL && arg2->type !=	NULL) {
		// both pointer
		if (arg1->type->typeclass == 3 && arg2->type->typeclass == 3 && (arg1->type->ptrto == arg2->type->ptrto || arg2->type->ptrto == voidtype)) 
			return 1;
		// RHS is array pointer
		if (arg2->type->typeclass == 2 && arg1->type->ptrto == arg2->type->elementvar->type)
			return 1;
		if (arg1->type->typeclass == 2 && arg1->type->elementvar->type == arg2->type->ptrto)
			return 1;
	}
	if (enable) 
		print_error("LHS and RHS are not same type");

	return 0;
}

struct decl* reference_struct(struct decl* struct_name, struct id* member) {
	if (struct_name == NULL || struct_name->type == NULL) {
		print_error("not variable");

		return NULL;
	}
	if (struct_name->type != NULL && struct_name->type->typeclass != 4) {
		print_error("variable is not struct");

		return NULL;
	}

	struct ste* cur_node = struct_name->type->fieldlist;
	// printf("%d: cur node : %p\n", read_line(), cur_node);
	while (cur_node != NULL) {
		// printf("%d: cur node is %s, member is : %s\n", read_line(), cur_node->name->name, member->name);
		if (cur_node->name == member) {
			// printf("%d: member's name is : %s\n", read_line(), cur_node->name->name);
			return cur_node->decl;
		}
		cur_node = cur_node->prev;
	}

	print_error("struct not have same name field");
	return NULL;
}

void declare(struct id* arg_id, struct decl* arg_decl) {	
	if (arg_id == NULL || arg_decl == NULL) 
		return;
	// Checking redeclaration
	struct decl* tmp_decl = NULL;
	if ((tmp_decl = lookup_stack(arg_id)) != NULL){
		// check struct decl in other function
		if (tmp_decl->declclass != 4) {
			print_error("redeclaration");
		}
		return;
	}

	insert(arg_id, arg_decl);

	arg_decl->isglobal = (top->prev == NULL) ? 1 : 0;
	if (arg_decl->declclass == 0 || (arg_decl->declclass == 1 && arg_decl->type->typeclass == 2)) {
		arg_decl->offset = top->counter;
		top->counter += arg_decl->size;
	}
	/*
	 * This is for debugging
	 */
	// struct ste* test_node = top->ste; 
	// while (test_node != NULL) {
	// 	// printf("%d: cur node's name is : %s\n", read_line(), test_node->name->name);
	// 	test_node = test_node->prev;
	// }
	// if (arg_id == NULL || arg_decl == NULL) return;

	return;
}

void check_return_type_compatibility(struct decl* type1, struct decl* type2) {
	if (type1 == NULL || type2 == NULL)
		return;
	if (type1 == type2) 
		return;

	// both pointer
	if (type1->typeclass == 3 && type2->typeclass == 3 && (type1->ptrto == type2->ptrto || type2->ptrto == voidtype)) 
		return;
	// RHS is array pointer
	if (type2->typeclass == 2 && type1->ptrto == type2->elementvar->type)
		return;
	if (type1->typeclass == 2 && type1->elementvar->type == type2->ptrto)
		return;

	print_error("return value is not return type");
}

void declare_struct(struct id* arg_id, struct decl* arg_decl) {
	if (arg_id == NULL || arg_decl == NULL) return;
	// Declare struct at bottom of scope
	struct ste* node = top->ste;
	struct ste* new_node = (struct ste *)malloc(sizeof(struct ste));

	while (node->prev != NULL) 
		node = node->prev;

	new_node->name = arg_id;
	new_node->decl = arg_decl;
	new_node->prev = NULL;

	node->prev = new_node;
}

void fetch_val(struct decl* arg_decl) {
	// printf("fetch val called. declclass is %d, type is %d\n", arg_decl->declclass, arg_decl->type->typeclass);
	if (arg_decl->declclass == 1) {
		// Const 
	}
	// else if (arg_decl->declclass == 0 && arg_decl->type->typeclass == 3) {
	// 	// Pointer
	// 	fprintf(output_file, "\tfetch\n");
	// 	fprintf(output_file, "\tfetch\n");
	// }
	else if (arg_decl->declclass == 0) {
		// Variable 
		fprintf(output_file, "\tfetch\n");
	}
}