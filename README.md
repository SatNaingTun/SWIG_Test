# SWIG Python 3 Compilation Guide

Modern GCC compilers enforce strict function declarations (`-Werror=implicit-function-declaration`). When `example_wrap.c` cannot find the definitions for your C functions or variables, compilation fails with undeclared identifier and implicit declaration errors.

Follow these steps to update your SWIG interface file and build the module for Python 3.

---

## Step 1: Update the SWIG Interface File (`example.i`)

Ensure that the function prototypes and external variable declarations are included inside the `%{%}` block. This block copies the contained C code directly into the header section of `example_wrap.c`.

```swig
%module example

%{
/* Includes and declarations in this block are copied directly to example_wrap.c */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
%}

/* Declarations parsed by SWIG to generate wrapper functions */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
```

---

## Step 2: Regenerate Wrapper and Compile Object Files

Re-run SWIG to regenerate `example_wrap.c`, then compile both your source file and wrapper file into object files (`.o`) using `python3-config` to automatically resolve header paths:

```bash
swig -python example.i
gcc -c -fPIC example.c example_wrap.c $(python3-config --cflags)
```

---

## Step 3: Link into a Shared Library and Test

Link the compiled object files into the Python shared library (`_example.so`) using the Python 3 linker flags:

```bash
gcc -shared example.o example_wrap.o -o _example.so $(python3-config --ldflags)
```

### Verification

Run Python 3 to test the module:

```bash
python3
```

```python
>>> import example
>>> example.fact(4)
24
>>> example.my_mod(23, 7)
2
>>> example.cvar.My_variable + 4.5
7.5
```
# SWIG C Sharp Compilation Guide

• [SWIG CSharp](./swig_csharp_build_guide.md)

# SWIG Java Compilation Guide

• [SWIG Java](./swig_java_build_guide.md)

# SWIG JavaScript Compilation Guide

• [SWIG JavaScript](./swig_javascript_build_guide.md)

# SWIG Perl Compilation Guide

• [SWIG Perl](./swig_perl_build_guide.md)
