%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdbool.h>
    
    #define SIZE 100
    
    void yyerror(char *);
    int yylex(void);
    extern FILE *yyin;
    extern int linenum;
    
	/*- FILE FUNCTIONS -*/

	FILE *outputFile;
	
	void openFile(char* fileName){
		outputFile=fopen(fileName,"w");
	}

	void writeLinetoFile(char* str){
		fprintf(outputFile,"%s",str);
	}

	void closeFile(){
		fclose(outputFile);
	}
	
	int tabCounter = 0;	
	
	void printTabs(){			/* C function to print tab characters to output file. */
		for(int i = tabCounter; i > 0; i--)
		fprintf(outputFile,"\t");
	}
	
	char stringBuffer[SIZE] = {0}; 	/* Character array for numeric assignments */

%}
%union
{
char *string;
}

%token SHELLPRED

%token ECHO IF ELIF ELSE THEN FI WHILE DO DONE

%token DOLLARSIGN PLUSOP MINUSOP MULTOP DIVIDEOP ASSIGNOP CONCATOP OPENPARAN CLOSEPARAN OPENBRACKET CLOSEBRACKET OPENCURLY CLOSECURLY GREATERTHAN LESSTHAN lessORequal greaterORequal EQUALCHECK SEMICOLON NEWLINE WHITESPACE TAB


%token <string> INTEGER 
%token <string> VARIABLE1
%token <string> VARIABLE2
%token <string> STRLITERAL1
%token <string> STRLITERAL2
%token <string> COMMENT

%type <string> numeric_assignment_block
%type <string> echo_block
%type <string> variable_call
%type <string> operations
%type <string> condition_decleration
%type <string> conditions


%left PLUSOP MINUSOP
%left MULTOP DIVIDEOP
%%

program:
      	statements	
        ;

statements:
		statement statements	
		|
		statement			
		;

statement:
		tab			{ printTabs(); tabCounter--; }
		|
		whitespace
		|
		SHELLPRED	{ fprintf(outputFile,"\n"); }
		|
		COMMENT		{ fprintf(outputFile,"%s\n",$1); }
		|
		numeric_assignment	{ memset(&stringBuffer[0], 0, sizeof(stringBuffer)); }	/* We need to clean-up the character array for every new numeric assignment because character array holds previous numeric assignment's characters. */
		|
		ECHO WHITESPACE echo_block		/* echo_block also uses stringBuffer to print multiple assignments so that we need to clean-up the array at each time if the next statement is an echo block. */
		{
		 	fprintf(outputFile,"print %s . \"\\n\";\n",$3); 
		 	memset(&stringBuffer[0], 0, sizeof(stringBuffer));  
		}	
		|
		condition_blocks 		{ fprintf(outputFile,"}\n"); }
		;

condition_blocks:		/* elif block and else block must be connected with an if block, we can't declare a single elif or else block without an if statement that is not decleared previously. */
		if FI
		|
		if recursive_elsif FI
		|
		if else FI
		|
		if recursive_elsif else FI
		|
		while 
		;

if:
		IF WHITESPACE if_block inside_block
		;

elsif:
		ELIF WHITESPACE elif_block inside_block
		;
	
recursive_elsif:
		elsif
		|
		elsif recursive_elsif
		;

else:
		else_block statements
		;

while:	/* Bonus Example */
		WHILE WHITESPACE while_block inside_block
		;

if_block:
		condition_decleration
		{
			fprintf(outputFile,"if (%s){\n",$1);
		}
		;

elif_block:
		condition_decleration
		{
			fprintf(outputFile,"}elsif (%s){\n",$1);
		}
		;

else_block:
		ELSE	{ fprintf(outputFile,"}else{\n"); }
		;
		
while_block:
		condition_decleration
		{
			fprintf(outputFile,"while (%s){\n",$1);
		}
		;

		
inside_block:			/* The condition blocks can be in nested form so that this is block is to handle tab characters before THEN or DO statements because THEN statement must be connected with if OR elif statement and DO statement must be connected with the WHILE statement. */
		THEN statements
		|
		tab THEN statements
		|
		DO statements DONE
		|
		tab DO statements DONE
		;

tab:
		TAB tab
		|
		TAB		{ tabCounter = tabCounter+1; }
		;

whitespace:
		WHITESPACE	{ fprintf(outputFile," "); }
		;
		

numeric_assignment:						
		VARIABLE1 ASSIGNOP variable_call				/* Single Assignment */
		{
			fprintf(outputFile,"%s=%s;\n",$1,$3);
		}	
		|
		VARIABLE1 ASSIGNOP DOLLARSIGN OPENPARAN OPENPARAN numeric_assignment_block CLOSEPARAN CLOSEPARAN /* Multiple Operation Assignment */
		{
			fprintf(outputFile,"%s=%s;\n",$1,stringBuffer);
		}
		;
		
numeric_assignment_block:
		variable_call { strcat(stringBuffer,$1); }	
		|
		numeric_assignment_block operations numeric_assignment_block /* ex: a+b... */
		|
		open_paranthesis numeric_assignment_block operations numeric_assignment_block close_paranthesis	/* Multiple operations can be in between paranthesis. */
		;

open_paranthesis:
		OPENPARAN		{ strcat(stringBuffer,"("); }
		;

close_paranthesis:
		CLOSEPARAN		{ strcat(stringBuffer,")"); }	
		;


operations:
		MINUSOP  { strcat(stringBuffer,"-"); }
		|
		PLUSOP	 { strcat(stringBuffer,"+"); }
		|
		MULTOP   { strcat(stringBuffer,"*"); }
		|
		DIVIDEOP { strcat(stringBuffer,"/"); }
		;

condition_decleration:
		OPENBRACKET WHITESPACE variable_call WHITESPACE conditions WHITESPACE variable_call WHITESPACE CLOSEBRACKET
		{
			sprintf($$,"%s %s %s",$3,$5,$7);
		}
		;

conditions:
		lessORequal		{ $$ = "<="; }
		|
		greaterORequal	{ $$ = ">="; }
		|
		GREATERTHAN		{ $$ = ">"; }
		|
		LESSTHAN		{ $$ = "<"; }
		|
		EQUALCHECK		{ $$ = "=="; }
		;

		

echo_block:
		variable_call	{ $$ = $1; }		
		|
		STRLITERAL1		{ $$ = $1; }
		|
		STRLITERAL2		{ $$ = $1; }	
		|
		DOLLARSIGN OPENPARAN OPENPARAN numeric_assignment_block CLOSEPARAN CLOSEPARAN 
		{ 
			$$ = stringBuffer; 	/* numeric_assignment_block adds the arguments to the buffer so we need to use stringBuffer if we want to print multiple numeric operations with echo. */
		}
		;
		

variable_call:
		INTEGER 	{ $$ = $1; }
		|
		VARIABLE1	{ $$ = $1; }		
		|
		VARIABLE2 	{ $$ = $1; }		/* Th difference between VARIABLE1 & VARIABLE2 is that VARIABLE2 starts with a dollar sign. */
		;

		
%%

void yyerror(char *s){
	fprintf(stderr,"Error at line: %d\n",linenum);
}
int yywrap(){
	return 1;
}

int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    openFile(argv[2]);
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    closeFile();
    return 0;
}


