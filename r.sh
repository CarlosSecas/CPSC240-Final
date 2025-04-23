#!/bin/bash

# Name: Carlos Secas
# CWID: 886088269
# Class: 240-09 Section 09
# Email: carlosJsecas@gmail.com
# Today's date : 4/23/2025
# Final Program

# Delete unnecessary files
rm -f *.o
rm -f *.out

echo "Assembling analyzer.asm..."
nasm -f elf64 -l analyzer.lis -o analyzer.o analyzer.asm

echo "Compile the source file main.cpp"
g++ -m64 -Wall -std=c++2a -c main.cpp -o main.o

echo "Linking object files to final.out..."
g++ -m64 -no-pie -std=c++2a -o final.out main.o analyzer.o

echo "Setting execute permissions for final.out..."
chmod +x final.out

echo "Executing the program..."
./final.out

echo "This bash script will now terminate."