# Multi-Language SWIG Build and Usage Guide

This guide provides step-by-step instructions on how to generate, compile, and use native language bindings for your C library (`example.c` / `example.h`) using **SWIG**.

---

## 🚀 Quick Start: Using the Automated Build Script (`build_all.sh`)

Instead of compiling each language binding manually, you can use the `build_all.sh` shell script located in the project root to generate and compile bindings for all 8 target languages in one step.

### 1. Make the Script Executable
Run this command from your project root:

```bash
chmod +x build_all.sh
```

### 2. Run the Build Script
Execute the script to process all bindings (excluding Ruby):

```bash
./build_all.sh
```

### 3. Cleaning / Rebuilding
To clean up generated artifacts or re-run the build:

```bash
# Re-run build script
./build_all.sh
```

---

## 📁 Recommended Project Structure

```text
.
├── include/
│   └── example.h          # Core C header file (optional)
├── src/
│   └── example.c          # Core C implementation
├── swig/
│   └── example.i          # Universal SWIG interface file
├── docs/
│   └── multi_language_build_and_usage_guide.md
├── bindings/              # Language outputs
│   ├── python/
│   ├── node/
│   ├── octave/
│   ├── java/
│   ├── csharp/
│   ├── perl/
│   ├── php/
│   └── r/
└── build_all.sh           # Automated build script
```

---

## 🛠️ Target Language Build & Usage Reference

## 1. Python

### Build Instructions

```bash
mkdir -p bindings/python
swig -python -o bindings/python/example_wrap.c swig/example.i
PYTHON_INC=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))")
gcc -shared -fPIC src/example.c bindings/python/example_wrap.c -Iinclude -I$PYTHON_INC -o bindings/python/_example.so
```

### Usage Instructions

Open a terminal in `bindings/python/` and test:

```bash
python3 -c "import example; print(example.fact(4)); print(example.my_mod(23, 7))"
```

---

## 2. Node.js

### Build Instructions

```bash
mkdir -p bindings/node
swig -c++ -javascript -node -o bindings/node/example_wrap.cpp swig/example.i

# Ensure node-gyp is installed: npm install -g node-gyp
g++ -shared -fPIC src/example.c bindings/node/example_wrap.cpp -Iinclude -I$(node -p "require('node-addon-api').include" 2>/dev/null || echo ".") -o bindings/node/example.node
```

### Usage Instructions

```javascript
const ex = require('./bindings/node/example.node');
console.log(ex.fact(4));
console.log(ex.my_mod(23, 7));
```

---

## 3. GNU Octave

### Build Instructions

```bash
mkdir -p bindings/octave
swig -octave -c++ -o bindings/octave/example_wrap.cpp swig/example.i
mkoctfile src/example.c bindings/octave/example_wrap.cpp -Iinclude -o bindings/octave/example.oct
```

### Usage Instructions

```bash
octave -q --eval "example; disp(example.fact(4)); disp(example.my_mod(23, 7));"
```

*(Note: In Octave scripts, you must evaluate or call `example` first to load the loadable module into the namespace before accessing functions like `example.fact(4)`).*

---

## 4. Java

### Build Instructions

```bash
mkdir -p bindings/java
swig -java -outdir bindings/java -o bindings/java/example_wrap.c swig/example.i

# Compile C wrapper into shared library
gcc -shared -fPIC src/example.c bindings/java/example_wrap.c -Iinclude -I${JAVA_HOME:-/usr/lib/jvm/default-java}/include -o bindings/java/libexample.so

# Compile Java classes
javac bindings/java/*.java
```

### Usage Instructions

Create a `Main.java` file in `bindings/java/`:

```java
public class Main {
    public static void main(String[] args) {
        System.loadLibrary("example");
        System.out.println("Factorial: " + example.fact(4));
        System.out.println("Modulo: " + example.my_mod(23, 7));
    }
}
```

Compile and run:

```bash
javac -d . bindings/java/*.java Main.java
java -Djava.library.path=bindings/java Main
```

---

## 5. C# (.NET)

### Build Instructions

```bash
mkdir -p bindings/csharp
swig -csharp -outdir bindings/csharp -o bindings/csharp/example_wrap.c swig/example.i

# Compile C wrapper into shared library
gcc -shared -fPIC src/example.c bindings/csharp/example_wrap.c -Iinclude -o bindings/csharp/libexample.so
```

### Usage Instructions

Create a `Program.cs` in `bindings/csharp/`:

```csharp
using System;

class Program {
    static void Main() {
        Console.WriteLine("Factorial: " + example.fact(4));
        Console.WriteLine("Modulo: " + example.my_mod(23, 7));
    }
}
```

### Run the project:

   ```bash
   dotnet run
   ```
### Compile C# files into an executable
```
dotnet csc -target:exe -out:TestApp.exe Program.cs example.cs examplePINVOKE.cs

```
#### Expose shared library path and run
```
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
dotnet TestApp.exe

```
---

## 6. Perl

### Build Instructions

```bash
mkdir -p bindings/perl
swig -perl -o bindings/perl/example_wrap.c swig/example.i
PERL_INC=$(perl -MConfig -e 'print $Config{archlibexp}')/CORE
gcc -shared -fPIC src/example.c bindings/perl/example_wrap.c -Iinclude -I$PERL_INC -o bindings/perl/example.so
```

### Usage Instructions

```bash
perl -Ibindings/perl -e 'use example; print example::fact(4), "\n";'
```

---

## 7. PHP

### Build Instructions

```bash
mkdir -p bindings/php
swig -php -o bindings/php/example_wrap.c swig/example.i
PHP_INC=$(php-config --include 2>/dev/null || echo "/usr/include/php")
gcc -shared -fPIC src/example.c bindings/php/example_wrap.c -Iinclude -I$PHP_INC -o bindings/php/example.so
```

### Usage Instructions

```bash
php -d extension=bindings/php/example.so -r "echo fact(4) . '\n';"
```

---

## 8. R

### Build Instructions

```bash
mkdir -p bindings/r
swig -r -o bindings/r/example_wrap.c swig/example.i
R_INC=$(R RHOME)/include
gcc -shared -fPIC src/example.c bindings/r/example_wrap.c -Iinclude -I$R_INC -o bindings/r/example.so
```

### Usage Instructions

```R
dyn.load("bindings/r/example.so")
```