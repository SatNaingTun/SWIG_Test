use strict;
use warnings;
use lib '.';
use example;

print "fact(4) = " . example::fact(4) . "\n";
print "my_mod(23, 7) = " . example::my_mod(23, 7) . "\n";

# Accessing global variables
$example::My_variable = 3.0;
my $result = $example::My_variable + 4.5;
print "My_variable + 4.5 = $result\n";