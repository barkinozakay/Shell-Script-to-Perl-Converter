all: yacc lex
	cc lex.yy.c y.tab.c -o project -lfl

yacc: project.y
	yacc -d project.y

lex: project.l
	lex project.l

clean:
	rm lex.yy.c y.tab.* project
