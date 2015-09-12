%{
#include <stdio.h>
extern int yylineno; 
%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_PRINTLN TOK_OPENCURL TOK_CLOSECURL TOK_MAIN

%union{
        int int_val;
}

/*%type <int_val> expr TOK_NUM*/
%type <int_val> expr TOK_NUM

%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%

prog: TOK_MAIN TOK_OPENCURL stmts TOK_CLOSECURL
;
stmts: 
	| stmt  stmts
;
stmt:
	| expr TOK_SEMICOLON stmt
	   | TOK_PRINTLN expr TOK_SEMICOLON 
		{
			//printf("%d\n",yylineno );
			fprintf(stdout, "the value is %d\n", $2);
		} 
;

expr: 	 
	expr TOK_ADD expr
	  {
		$$ = $1 + $3;
	  }
	| expr TOK_SUB expr
	  {
		$$ = $1 - $3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
	  }
	| expr TOK_DIV expr
	  {
		$$ = $1 / $3; 
	  }
	| TOK_NUM
	  { 	
		$$ = $1;
	  }
;


%%

int yyerror(char *s)
{
	printf("\nsyntax error on line no %d\n",yylineno);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}