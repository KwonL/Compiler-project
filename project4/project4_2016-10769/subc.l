%{
/*
 * File Name   : subc.l
 * Description : a skeleton flex input
 */

#include "subc.h"
#include "subc.tab.h"
static int comment_depth = 0;
static int lineno = 1;
static char filename[100] = { 0 };

%}

/* regular definitions */
letter		[A-Za-z_]
digit		[0-9]
id		{letter}({letter}|{digit})*
integer_const	([1-9]{digit}*)|"0"
white-space		[ \t]+
special-char	\\[nt]
return_single	","|"!"|"-"|"+"|"*"|"&"|"|"|"="|";"|"("|")"|"{"|"}"|"["|"]"|"/"|"%"|"."


%x COMMENT
%%
{integer_const}	{
	yylval.intVal = atoi(yytext);
	return INTEGER_CONST;
}
{id}	{
	// search if already entered
	struct id * entered = lookup(yytext);
	if (entered == NULL) {
		// enter new token
		entered  = enter(ID, yytext, yyleng);
	}
	// return token
	yylval.stringVal = entered->name;
	yylval.idPtr = entered;

	return entered->lextype;
}
"->"	{return STRUCTOP; }
{return_single}		{ return yytext[0]; }
"||"	{ return LOGICAL_OR; }
"&&"	{ return LOGICAL_AND; }
"<"|"<="|">"|">="	{
	yylval.stringVal = (char *)malloc(3);
	strncpy(yylval.stringVal, yytext, 2);
	yylval.stringVal[2] = '\0';
	return RELOP; 
}
"=="|"!="	{ 
	yylval.stringVal = (char *)malloc(3);
	strncpy(yylval.stringVal, yytext, 2);
	yylval.stringVal[2] = '\0';
	return EQUOP; 
}
"++"	{ return INCOP; }
"--"	{return DECOP; }
\"({special-char}|[^\\\"\n])*\"	{
	/* String Variable */
	yylval.stringVal = yytext;
	return STRING;
}
'({special-char}|[^\\'\n])'	{
	/* Character Variable */
	yylval.stringVal = yytext;
	return CHAR_CONST;
}

{white-space}
<*>\n		   ++lineno;
<INITIAL,COMMENT>"/*"	{
		   ++comment_depth;
		   BEGIN (COMMENT);
		}
<COMMENT>"*/"	   if(--comment_depth == 0) BEGIN (INITIAL);
<COMMENT>.		 {}


%%

int read_line()
{
   return lineno;
}

char* get_filename() {
	return (char *)filename;
}


void init_type()
{
	inttype = maketypedecl(INT);
	chartype = maketypedecl(CHAR);
	voidtype = maketypedecl(VOID);

	declare(lookup("int"), inttype);
	declare(lookup("char"), chartype);
	declare(lookup("void"), voidtype);

	returnid = enter(ID, "*return", 7);
}

void entry_code() {
	fprintf(output_file, "\tpush_const EXIT\n");
	fprintf(output_file, "\tpush_reg fp\n");
	fprintf(output_file, "\tpush_reg sp\n");
	fprintf(output_file, "\tpop_reg fp\n");
	fprintf(output_file, "\tjump main\n");
	fprintf(output_file, "EXIT :\n");
	fprintf(output_file, "\texit\n");
}
   
int main(int argc, char* argv[])
{
   static char *keyword[] = { "int","char", "void", "struct", "return", "if", "else", "while", "for", "break", "continue", "NULL", "write_int", "write_char", "write_string", "read_int", "read_char", NULL };
   static int tokentype[] = { TYPE, TYPE, VOID, STRUCT, RETURN, IF, ELSE, WHILE, FOR, BREAK, CONTINUE, NULL_TOKEN, WRITE_INT, WRITE_CHAR, WRITE_STRING, READ_INT, READ_CHAR, 0 };
   int i;
   for(i = 0; keyword[i] != NULL; i++)
      enter(tokentype[i], keyword[i], strlen(keyword[i]));

   if(argc >= 2) {
	   yyin = fopen(argv[1], "r");
	   strcpy(filename, argv[1]);
   }
   else yyin = stdin;
   if (argc >= 3) {
	   output_file = fopen(argv[2], "w");
   }
   else { 
	   output_file = stdout;
   }
	output_origin = output_file;
	null_dev = fopen("/dev/null", "rw");

   if(!yyin) {
      printf("Can't open input stream!\n");
      exit(1);
   }

   // Initialize
   entry_code();
   push_scope(0);
   init_type();
	
   yyparse();

   fprintf(output_file, "Lglob.\tdata %d\n", top->counter);
   fclose(yyin);
   return 0;
}
