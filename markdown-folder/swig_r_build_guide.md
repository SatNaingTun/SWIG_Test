# SWIG R Compilation & Integration Guide

This guide details the step-by-step process for using SWIG to wrap C code for the **R programming language** on Linux.

## Step 1: Prepare the C Source and Header Files

Ensure your C source and header files are set up.

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

## Step 2: Create the SWIG Interface File (`example.i`)

Create an interface file declaring the functions and variables to be exposed to R.

**`example.i`**

```swig
%module example

%{
#include "example.h"
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
%}

/* Declarations parsed by SWIG to generate R wrappers */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
```

## Step 3: Generate R Wrapper Files

Run SWIG using the `-r` flag:

```bash
swig -r example.i
```

This command generates two files:

* **`example_wrap.c`**: The C wrapper source file implementing the R C API interfaces.
* **`example.R`**: The R wrapper script that manages loading the shared library and exposing functions to R.

## Step 4: Compile into a Shared Library

Use R's built-in tool `R CMD SHLIB` to automatically resolve header includes, compiler flags, and link the object files into a shared library:

```bash
R CMD SHLIB example.c example_wrap.c
```

Upon completion, this command creates the shared library object file **`example.so`** (or `example.dll` on Windows).

## Step 5: Create and Run the R Test Script

1. Create an R script named `test.R`:

   **`test.R`**

   ```r
   # Source the SWIG-generated R interface module
   source("example.R")

   # Call wrapped C functions
   cat("fact(4) =", fact(4), "\n")
   cat("my_mod(23, 7) =", my_mod(23, 7), "\n")
   ```

2. Execute the R script:

   ```bash
   Rscript test.R
   ```

### Expected Output

```text
fact(4) = 24 
my_mod(23, 7) = 2 
```