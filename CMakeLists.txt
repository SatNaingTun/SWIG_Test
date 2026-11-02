cmake_minimum_required(VERSION 3.14)
project(my_c_project C CXX)

# Require SWIG
find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

# Include directories for core C library
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# Core library source
set(CORE_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/example.c)

# Set SWIG flags
set(CMAKE_SWIG_FLAGS "")

# ==========================================
# 1. Python Binding
# ==========================================
find_package(Python3 COMPONENTS Interpreter Development QUIET)
if(Python3_FOUND)
    message(STATUS "Configuring Python SWIG module...")
    set_property(SOURCE swig/example.i PROPERTY CPLUSPLUS OFF)
    swig_add_library(example_python
        TYPE SHARED
        LANGUAGE python
        OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/bindings/python
        SOURCES swig/example.i ${CORE_SOURCES}
    )
    target_include_directories(example_python PRIVATE ${Python3_INCLUDE_DIRS})
    target_link_libraries(example_python PRIVATE ${Python3_LIBRARIES})
    set_target_properties(example_python PROPERTIES OUTPUT_NAME "_example")
endif()

# ==========================================
# 2. Java Binding
# ==========================================
find_package(JNI QUIET)
find_package(Java QUIET)
if(JNI_FOUND AND Java_FOUND)
    message(STATUS "Configuring Java SWIG module...")
    set_property(SOURCE swig/example.i PROPERTY CPLUSPLUS OFF)
    swig_add_library(example_java
        TYPE SHARED
        LANGUAGE java
        OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/bindings/java
        SOURCES swig/example.i ${CORE_SOURCES}
    )
    target_include_directories(example_java PRIVATE ${JNI_INCLUDE_DIRS})
    set_target_properties(example_java PROPERTIES OUTPUT_NAME "example")
endif()

# ==========================================
# 3. C# Binding
# ==========================================
message(STATUS "Configuring C# SWIG module...")
set_property(SOURCE swig/example.i PROPERTY CPLUSPLUS ON)
swig_add_library(example_csharp
    TYPE SHARED
    LANGUAGE csharp
    OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/bindings/csharp
    SOURCES swig/example.i ${CORE_SOURCES}
)
set_target_properties(example_csharp PROPERTIES OUTPUT_NAME "example")

# ==========================================
# 4. Perl Binding
# ==========================================
find_package(PerlLibs QUIET)
if(PERLIBS_FOUND)
    message(STATUS "Configuring Perl SWIG module...")
    set_property(SOURCE swig/example.i PROPERTY CPLUSPLUS OFF)
    swig_add_library(example_perl
        TYPE SHARED
        LANGUAGE perl
        OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/bindings/perl
        SOURCES swig/example.i ${CORE_SOURCES}
    )
    target_include_directories(example_perl PRIVATE ${PERL_INCLUDE_PATH})
    set_target_properties(example_perl PROPERTIES OUTPUT_NAME "example")
endif()

# ==========================================
# 5. PHP Binding
# ==========================================
find_package(PHP4 QUIET) # CMake uses PHP4 module for general PHP discovery
if(PHP4_FOUND OR EXISTS "/usr/include/php")
    message(STATUS "Configuring PHP SWIG module...")
    set_property(SOURCE swig/example.i PROPERTY CPLUSPLUS OFF)
    swig_add_library(example_php
        TYPE SHARED
        LANGUAGE php
        OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/bindings/php
        SOURCES swig/example.i ${CORE_SOURCES}
    )
    target_include_directories(example_php PRIVATE "/usr/include/php" "/usr/include/php/main" "/usr/include/php/TSRM" "/usr/include/php/Zend")
    set_target_properties(example_php PROPERTIES OUTPUT_NAME "example")
endif()

# ==========================================
# 6. R Binding
# ==========================================
find_package(R QUIET)
if(R_FOUND OR EXISTS "/usr/share/R/include")
    message(STATUS "Configuring R SWIG module...")
    set_property(SOURCE swig/example.i PROPERTY CPLUSPLUS OFF)
    swig_add_library(example_r
        TYPE SHARED
        LANGUAGE r
        OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/bindings/r
        SOURCES swig/example.i ${CORE_SOURCES}
    )
    target_include_directories(example_r PRIVATE "/usr/share/R/include")
    set_target_properties(example_r PROPERTIES OUTPUT_NAME "example")
endif()