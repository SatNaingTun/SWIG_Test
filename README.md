# Multi-Language SWIG Build and Usage Guide

This guide provides step-by-step instructions on how to generate, compile, and use native language bindings for your C library (`example.c` / `example.h`) using **SWIG**.

## 🚀 Quick Start: Building with CMake

Using CMake is the recommended cross-platform method for automating SWIG bindings generation and compilation.

### Step-by-Step Instructions

1. **Navigate to the Project Root Directory** (where `CMakeLists.txt` is located):
   ```bash
   cd /path/to/project_root
   ```

2. **Create and Enter a Build Directory**:
   ```bash
   mkdir -p build && cd build
   ```

3. **Configure the Project**:
   ```bash
   cmake ..
   ```

4. **Compile the Bindings**:
   ```bash
   cmake --build .
   # OR simply:
   make
   ```

All compiled shared libraries and generated code wrappers will be placed inside their respective subfolders in `build/bindings/`.

---

## 📜 Alternative: Using the Automated Shell Script (`build_all.sh`)

Instead of CMake, you can also use the `build_all.sh` shell script in the project root:

```bash
chmod +x build_all.sh
./build_all.sh
```

---

## 📁 Recommended Project Structure

```
.
├── CMakeLists.txt         # Modern CMake build configuration
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

### Build Instructions (Manual)
```bash
mkdir -p bindings/python
swig -python -o bindings/python/example_wrap.c swig/example.i
PYTHON_INC=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))")
gcc -shared -fPIC src/example.c bindings/python/example_wrap.c -Iinclude -I$PYTHON_INC -o bindings/python/_example.so
```

### Usage Instructions
Open a terminal in `bindings/python/` (or `build/bindings/python/` if built with CMake) and run:
```bash
python3 -c "import example; print(example.fact(4)); print(example.my_mod(23, 7))"
```

---

## 2. Node.js

### Build Instructions (Manual)
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

### Build Instructions (Manual)
```bash
mkdir -p bindings/octave
swig -octave -c++ -o bindings/octave/example_wrap.cpp swig/example.i
mkoctfile src/example.c bindings/octave/example_wrap.cpp -Iinclude -o bindings/octave/example.oct
```

### Usage Instructions
```bash
octave -q --eval "example; disp(example.fact(4)); disp(example.my_mod(23, 7));"
```

---

## 4. Java

### Build Instructions (Manual)
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

### Build Instructions (Manual)
```bash
mkdir -p bindings/csharp
swig -csharp -c++ -outdir bindings/csharp -o bindings/csharp/example_wrap.cxx swig/example.i

# Compile C/C++ wrapper into shared library
g++ -shared -fPIC src/example.c bindings/csharp/example_wrap.cxx -Iinclude -o bindings/csharp/libexample.so
```

### Usage Instructions

#### Option A: Running directly with `dotnet run` (Recommended)

1. Create a `.csproj` file in `bindings/csharp/App.csproj`:
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>

  <!-- Include generated SWIG C# files from directory -->
  <ItemGroup>
    <Compile Include="*.cs" />
  </ItemGroup>
</Project>
```

2. Add your `Program.cs` in `bindings/csharp/`:
```csharp
using System;

class Program {
    static void Main() {
        Console.WriteLine("Factorial: " + example.fact(4));
        Console.WriteLine("Modulo: " + example.my_mod(23, 7));
    }
}
```

3. Run without manual compilation steps:
```bash
cd bindings/csharp
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
dotnet run
```

#### Option B: Quick CLI compilation with `dotnet csc`
```bash
cd bindings/csharp
dotnet csc -target:exe -out:TestApp.exe Program.cs example.cs examplePINVOKE.cs
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
dotnet TestApp.exe
```

---

## 6. Perl

### Build Instructions (Manual)
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

### Build Instructions (Manual)
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

### Build Instructions (Manual)
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