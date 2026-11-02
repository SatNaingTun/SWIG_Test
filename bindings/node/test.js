const example = require("./build/Release/example");

console.log("fact(4) =", example.fact(4));
console.log("my_mod(23, 7) =", example.my_mod(23, 7));

example.My_variable = 3.0;
console.log("My_variable + 4.5 =", example.My_variable + 4.5);