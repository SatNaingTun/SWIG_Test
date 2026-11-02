# SWIG GNU Octave Compilation & Integration Guide

This guide documents the exact shell commands and execution sequence for building and loading SWIG-wrapped C modules in **GNU Octave**.

## Step 1: Prepare C Source and Header Files

**`example.h`**

```c
#ifndef EXAMPLE_H
#define EXAMPLE_H

extern double My_variable;
int fact(int n);
int my_mod(int x, int y);

#endif
```

**`example.c`**

```c
#include "example.h"

double My_variable = 3.0;

int fact(int n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
}

int my_mod(int x, int y) {
    return x % y;
}
```

## Step 2: Create the Interface File (`example.i`)

**`example.i`**

```swig
%module example

%{
#include "example.h"
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
%}

extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
```

## Step 3: SWIG Wrapper Generation & Compilation Commands

Execute the following exact commands in your terminal directory:

```bash
# 1. Generate the Octave C++ wrapper with explicit output naming (.cpp extension)
swig -octave -c++ -o example_wrap.cpp example.i

# 2. Compile and link the wrapper and C source file into example.oct
mkoctfile example_wrap.cpp example.c
```

> **Note on `mkoctfile`:** Running `mkoctfile example_wrap.cpp example.c` automatically compiles both files and outputs `example.oct`.

---

## Step 4: Interactive Octave Execution & Module Initialization

Launch the GNU Octave CLI in quiet mode:

```bash
octave -q
```

### Important Module Initialization Step

In GNU Octave, you must call the module name `example` **once as a command** to initialize the loadable module bindings into the environment before accessing its functions.

```octave
octave:1> example
octave:2> example.fact(4)
ans = 24
octave:3> example.my_mod(23,7)
ans = 2
```

### Script Execution (`test.m`)

Alternatively, automate execution via an Octave script file:

**`test.m`**

```octave
% Initialize the module
example;

% Call wrapped functions
printf("fact(4) = %d\n", example.fact(4));
printf("my_mod(23, 7) = %d\n", example.my_mod(23, 7));
```

Run from shell:

```bash
octave -q test.m
```

### Expected Output

```text
fact(4) = 24
my_mod(23, 7) = 2
```