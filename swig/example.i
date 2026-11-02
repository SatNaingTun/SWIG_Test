%module example

%{
#ifdef __cplusplus
extern "C" {
#endif

extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);

#ifdef __cplusplus
}
#endif
%}

/* SWIG interface declarations */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);