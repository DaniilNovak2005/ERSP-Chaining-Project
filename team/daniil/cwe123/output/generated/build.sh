#!/bin/bash
set -e

clang -emit-llvm -c -g -O0 driver_CWE123_Write_What_Where_Condition__fgets_03_bad.c -o harness_fgets_03.bc

clang -emit-llvm -c -g -O0 driver_CWE123_Write_What_Where_Condition__connect_socket_01_bad.c -o harness_connect_socket_01.bc