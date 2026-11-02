<?php
// Load the compiled SWIG shared extension
if (!extension_loaded('example')) {
    dl('example.so'); // Alternatively, load via extension=./example.so in php.ini
}

// Include the generated PHP wrapper bindings if generated
if (file_exists('example.php')) {
    include('example.php');
}

// Call the wrapped C functions
echo "fact(4) = " . fact(4) . "\n";
echo "my_mod(23, 7) = " . my_mod(23, 7) . "\n";

// Accessing and modifying global variables
// PHP exposes SWIG global variables through getter/setter functions
if (function_exists('My_variable_set')) {
    My_variable_set(3.0);
    echo "My_variable + 4.5 = " . (My_variable_get() + 4.5) . "\n";
}
?>