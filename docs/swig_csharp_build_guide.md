# SWIG C# Compilation & Integration Guide

This guide explains how to use SWIG to wrap C code for **C#** on Linux using GCC and the .NET CLI.

---

## Step 1: Prepare the SWIG Interface File (`example.i`)

Ensure your interface file declares the functions and variables in both the `%{%}` header block and the SWIG directive section:

```swig
%module example

%{
/* Included directly in example_wrap.c */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
%}

/* Parsed by SWIG to generate C# wrappers */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
```

---

## Step 2: Generate C# Wrappers

Run SWIG targeting C#:

```bash
swig -csharp example.i
```

This generates:
* `example_wrap.c` (C wrapper code)
* `example.cs` (High-level C# class API)
* `examplePINVOKE.cs` (P/Invoke bridge class)

---

## Step 3: Compile into a Shared Library

Compile the C code and wrapper into a shared library.

> **Note:** Linux requires the shared object to start with the `lib` prefix (`libexample.so`) for .NET to automatically locate it via P/Invoke.

```bash
gcc -c -fPIC example.c example_wrap.c
gcc -shared example.o example_wrap.o -o libexample.so
```

---

## Step 4: Setup and Run the C# Project

1. **Create a new .NET console application:**
   ```bash
   dotnet new console -n CSharpTest
   cd CSharpTest
   ```

2. **Move generated `.cs` files and shared library into the project:**
   ```bash
   cp ../example*.cs ./
   cp ../libexample.so ./
   ```

3. **Update `Program.cs`:**
   ```csharp
   using System;

   class Program
   {
       static void Main(string[] args)
       {
           // Test functions
           Console.WriteLine($"fact(4) = {example.fact(4)}");
           Console.WriteLine($"my_mod(23, 7) = {example.my_mod(23, 7)}");

           // Test global variable access
           example.My_variable = 3.0;
           double result = example.My_variable + 4.5;
           Console.WriteLine($"My_variable + 4.5 = {result}");
       }
   }
   ```

4. **Run the project:**
   ```bash
   dotnet run
   ```

### Expected Output
```text
fact(4) = 24
my_mod(23, 7) = 2
My_variable + 4.5 = 7.5
```