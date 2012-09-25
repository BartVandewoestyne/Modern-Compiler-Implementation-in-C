#!/bin/bash

for file in ../testcases/*.tig
do
  ./lextest $file
done
