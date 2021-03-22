# ecoar-x86
x86 assembly project for Computer Architecture course at Faculty of Electronics of Warsaw University of Technology.

## Fuctionality
Program is capable of parsing lines of x86 assembly code and printing first numerical constant, i.e. when the line contains a number in a comment or a
variable's name it will not print the value. Program supports hexadecimal, binary, octal and decimal suffixes.

Lines are being parsed by finite-state machine. After extracting a proper value with suffix (or no suffix in case of decimal) it is being converted in the second part of the program.

The assembly function is called in a simple main function written in the C programming language. Main's only purpose is calling the firstconst function and passing an argument to that function.

## Setup
Code was written for the Netwide Assembler (NASM), so it is the main requirement for building. To build the project use GNU make on simple makefile from the root directory of this repository.

## Usage
firstconst <ASM_CODE>
