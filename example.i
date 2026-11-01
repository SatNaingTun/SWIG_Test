%module example

%{
/* C code block copied directly into example_wrap.c */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
%}

/* SWIG parsing directives */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);