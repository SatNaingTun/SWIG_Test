# SWIG JavaScript / Node.js Compilation & Integration Guide

This guide details the complete process for using SWIG to wrap C code for **JavaScript (Node.js)** on Linux using `node-gyp`.

---

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

---

## Step 2: Create the SWIG Interface File (`example.i`)

Because Node.js native addons require a C++ wrapper backend (`.cxx`), C function declarations inside the `%{ ... %}` block **must be wrapped in `extern "C"`** to prevent C++ name mangling (symbol lookup errors like `undefined symbol: _Z4facti`).

**`example.i`**
```swig
%module example

%{
#ifdef __cplusplus
extern "C" {
#endif

#include "example.h"
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);

#ifdef __cplusplus
}
#endif
%}

/* Declarations parsed by SWIG for generating wrapper methods */
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
```

---

## Step 3: Generate JavaScript/Node.js C++ Wrapper

Run SWIG using the `-c++`, `-javascript`, and `-node` flags:

```bash
swig -c++ -javascript -node example.i
```

This generates:
* **`example_wrap.cxx`**: The C++ wrapper source containing Node.js V8 engine bindings.

---

## Step 4: Create `binding.gyp` Configuration

Create a file named `binding.gyp` in the project root so `node-gyp` knows how to compile your original C code and the C++ wrapper together.

**`binding.gyp`**
```json
{
  "targets": [
    {
      "target_name": "example",
      "sources": [
        "example.c",
        "example_wrap.cxx"
      ]
    }
  ]
}
```

---

## Step 5: Install `node-gyp` and Build the Native Addon

1. Ensure `node-gyp` is installed globally:
   ```bash
   sudo npm install -g node-gyp
   ```

2. Configure and build the binary addon:
   ```bash
   node-gyp rebuild
   ```

Upon success, `node-gyp` creates the binary native module at `./build/Release/example.node`.

---

## Step 6: Create and Run the Node.js Test Script

1. Create a JavaScript script named `test.js`:

   **`test.js`**
   ```javascript
   const example = require("./build/Release/example");

   // Call wrapped C functions
   console.log("fact(4) =", example.fact(4));
   console.log("my_mod(23, 7) =", example.my_mod(23, 7));

   // Read and modify global variables
   example.My_variable = 3.0;
   let result = example.My_variable + 4.5;
   console.log("My_variable + 4.5 =", result);
   ```

2. Execute the test script:
   ```bash
   node test.js
   ```

### Expected Output
```text
fact(4) = 24
my_mod(23, 7) = 2
My_variable + 4.5 = 7.5
```