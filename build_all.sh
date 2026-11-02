#!/bin/bash
set -e

# Define paths relative to project root
SRC="src/example.c"
INC="include"
SWIG_FILE="swig/example.i"

echo "=========================================="
echo "Starting Multi-Language SWIG Build "
echo "=========================================="

# 1. PYTHON
echo "[1/8] Building Python binding..."
mkdir -p bindings/python
swig -python -o bindings/python/example_wrap.c $SWIG_FILE
# Detect python include path dynamically
PYTHON_INC=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))" 2>/dev/null || echo "/usr/include/python3")
gcc -shared -fPIC $SRC bindings/python/example_wrap.c -I$INC -I$PYTHON_INC -o bindings/python/_example.so
echo "-> Python binding built successfully."

# 2. NODE.JS (Using node-gyp)
echo "[2/8] Building Node.js binding..."
mkdir -p bindings/node
swig -c++ -javascript -node -o bindings/node/example_wrap.cpp $SWIG_FILE

# Ensure node-gyp is available
if ! command -v node-gyp &> /dev/null; then
    npm install -g node-gyp
fi

# Create a temporary binding.gyp inside bindings/node if it doesn't exist
cat << 'EOF' > bindings/node/binding.gyp
{
  "targets": [
    {
      "target_name": "example",
      "sources": [ "example_wrap.cpp", "../../src/example.c" ],
      "include_dirs": [ "../../include" ]
    }
  ]
}
EOF

# Build using node-gyp
cd bindings/node
node-gyp configure
node-gyp build
cd ../..
echo "-> Node.js binding built successfully via node-gyp."

# 3. GNU OCTAVE
echo "[3/8] Building GNU Octave binding..."
mkdir -p bindings/octave
swig -octave -c++ -o bindings/octave/example_wrap.cpp $SWIG_FILE
if command -v mkoctfile &> /dev/null; then
    mkoctfile -p $SRC bindings/octave/example_wrap.cpp -I$INC -o bindings/octave/example.oct 2>/dev/null || \
    mkoctfile $SRC bindings/octave/example_wrap.cpp -I$INC -o bindings/octave/example.oct
    echo "-> Octave binding built successfully."
else
    echo "-> mkoctfile not found, skipped Octave compilation."
fi

# 4. JAVA
echo "[4/8] Generating Java bindings..."
mkdir -p bindings/java
swig -java -outdir bindings/java -o bindings/java/example_wrap.c $SWIG_FILE
echo "-> Java wrapper code generated in bindings/java/"

# 5. C#
echo "[5/8] Generating C# bindings..."
mkdir -p bindings/csharp
swig -csharp -outdir bindings/csharp -o bindings/csharp/example_wrap.c $SWIG_FILE
echo "-> C# wrapper code generated in bindings/csharp/"

# 6. PERL
echo "[6/8] Generating Perl bindings..."
mkdir -p bindings/perl
swig -perl -o bindings/perl/example_wrap.c $SWIG_FILE
echo "-> Perl wrapper code generated in bindings/perl/"

# 7. PHP
echo "[7/8] Generating PHP bindings..."
mkdir -p bindings/php
swig -php -o bindings/php/example_wrap.c $SWIG_FILE
echo "-> PHP wrapper code generated in bindings/php/"

# 8. R
echo "[8/8] Generating R bindings..."
mkdir -p bindings/r
swig -r -o bindings/r/example_wrap.c $SWIG_FILE
echo "-> R wrapper code generated in bindings/r/"

echo "=========================================="
echo "All selected language bindings processed!"
echo "=========================================="