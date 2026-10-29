# CWE415_Double_Free__malloc_free_char_01 Harness

This directory contains my KLEE harness for the Juliet test case  
"CWE415_Double_Free__malloc_free_char_01.c"

-"instrumented_CWE415_s01_bad.c"
  -Keeps only the "CWE415_Double_Free__malloc_free_char_01_bad" function  
  - The function:
    1. Allocates a char * buffer with malloc(100)
    2. Calls free(data) once (correct)
    3. Calls free(data) a second time (double free bug)

-"driver_CWE415_s01_bad.c"  
  -Harness driver with a simple main() that calls the bad function symbolically

I built the harness by doing
clang-14 -I ~/klee/include -emit-llvm -c -g -O0 driver_CWE415_s01_bad.c -o harness_415_s01.bc

LLM Prompt:
"Create an instrumental file and driver file for this Juliet test case:
https://github.com/arichardson/juliet-test-suite-c/blob/master/testcases/CWE415_Double_Free/s01/CWE415_Double_Free__malloc_free_char_01.c

The instrumented file should contain only the bad() function (CWE415_Double_Free__malloc_free_char_01_bad), plus any minimal includes needed, and no good() functions or main(). The driver file should define main(), include the instrumented file, and call the bad() function once."


