#!/bin/bash
set -e

# No klee headers required — standard clang IR generation.

clang -emit-llvm -c -g -O0 \
    driver_CWE124_Buffer_Underwrite__char_alloca_ncpy_03_bad.c \
    -o harness_ncpy_03.bc

clang -emit-llvm -c -g -O0 \
    driver_CWE124_Buffer_Underwrite__char_alloca_cpy_01_bad.c \
    -o harness_cpy_01.bc