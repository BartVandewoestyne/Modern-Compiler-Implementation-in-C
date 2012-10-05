#!/bin/bash
#
# Script that runs the parser on all testcases.
#
# Note:
#   Make sure you first compiled the project so that you have an a.out file!

for file in ../testcases/book/*.tig ../testcases/compilable/*.tig
do
  echo -n "Compiling ${file}... "
  ./a.out $file 2>&1
done
