# Projeto de engenharia de linguagens
---

### Comando para executar o compilador
```
lex example4.l
yacc example4.y -d -v -g  (-d: y.tab.h; -v: y.output; -g: y.vcg [Visualization of Compiler Graphs])
gcc lex.yy.c y.tab.c -o parser.exe 
```
