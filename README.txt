*** Shell Script to Perl Converter ***

-OPTION 1-

step.1) Open a terminal(console line) inside the converter's location folder in Ubuntu.

step.2) If lex and yacc is not installed, write "sudo apt-get install flex byacc" to the console line, it will install lex&yacc.

step.3) To generate the yacc code, write "yacc -d project.y" to the console line, it will generate "y.tab.h" and "y.tab.c".
	"y.tab.h" is the header file for the definitions. 
	"y.tab.c" is the syntax and semantic analyzer code.

step.4) Yacc needs a lexer so that our lex file must be generated too.
	Write "lex project.l" to the console line and then it will generate "lex.yy.c" file.

step.5) For compilation:
	Write "gcc y.tab.c lex.yy.c -o project -lfl" to the console line and it will generate an executable code converter into "project"

step.6) For execution:
	Copy the executable "project" inside the "Examples" folder.
	To change directory, write "cd Examples" to the console line
	Write "./project example1.sh example1.pl" to the console line.
	"example1.sh" is the shell script input file for our converter.
	"example1.pl" is the output perl file that will be converted to.

step.7) To run the converted Perl code:
	Write "perl example1.pl" to the console line and it will print the output on the console line.
	If there are any syntax errors inside the example Shell Script inputs, converter will warn you by printing the error line on the console line.

-OPTION 2-

step.1) To make the compilation steps easier, you can simply write "make" to the console line.
	"make" command will simply run the first 5 steps in OPTION 1 by using our "Makefile".

step.2) Go to OPTION 1 and repeat step.6 & step.7.

![sh](https://user-images.githubusercontent.com/31376025/54943171-cc442f80-4f41-11e9-9c3c-e2444e646f1c.jpg)

