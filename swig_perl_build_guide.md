# SWIG Perl Compilation & Integration Guide

This guide details the step-by-step process for using SWIG to wrap C code for **Perl** on Linux.

## Step 1: Prepare the C Source and Header Files

Ensure your C code and declarations are prepared.

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

Create an interface file specifying the C declarations to include in the wrapper block (`%{ ... %}`) and the functions to expose to Perl.

**`example.i`**

```swig
%module example

%{
#include "example.h"
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
%}

/* Declarations parsed by SWIG for generating Perl bindings */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
```

## Step 3: Generate Perl Wrappers

Run SWIG using the `-perl` flag:

```bash
swig -perl example.i
```

This generates:

* **`example.pm`**: The high-level Perl module file.
* **`example_wrap.c`**: The C wrapper code interfacing with Perl's internals.

## Step 4: Compile Object Files and Link Shared Library

1. **Compile C source and wrapper into object files (`.o`):**  
   Use Perl's built-in configuration helper (`perl -MConfig`) to auto-detect the required compiler flags and header include path (`CORE`).

   ```bash
   gcc -c -fPIC example.c example_wrap.c $(perl -MConfig -e 'print $Config{ccflags}') -I$(perl -MConfig -e 'print $Config{archlib}')/CORE
   ```

2. **Link into a shared object file (`example.so`):**

   ```bash
   gcc -shared example.o example_wrap.o -o example.so
   ```

## Step 5: Create and Run the Perl Test Script

1. Create a Perl script named `test.pl`:

   **`test.pl`**

   ```perl
   use strict;
   use warnings;
   use lib '.';
   use example;

   # Call wrapped C functions
   print "fact(4) = " . example::fact(4) . "\n";
   print "my_mod(23, 7) = " . example::my_mod(23, 7) . "\n";

   # Read and modify global variables
   $example::My_variable = 3.0;
   my $result = $example::My_variable + 4.5;
   print "My_variable + 4.5 = $result\n";
   ```

2. Execute the test script:

   ```bash
   perl test.pl
   ```

### Expected Output

```text
fact(4) = 24
my_mod(23, 7) = 2
My_variable + 4.5 = 7.5
```