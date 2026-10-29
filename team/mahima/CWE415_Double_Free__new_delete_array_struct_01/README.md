# CWE415_Double_Free__new_delete_array_struct_01 Harness

This directory contains my KLEE harness for the Juliet C++ test case  
“CWE415_Double_Free__new_delete_array_struct_01.cpp”

-"instrumented_CWE415_s02_bad.c"
  -Keeps only the "CWE415_Double_Free__new_delete_array_struct_01_bad()" function  
  - The function
    1. Allocates a heap array using new twoIntsStruct[100]
    2. Calls delete[] data once (correct)
    3. Calls delete[] data a second time (double free bug)

-"driver_CWE415_s02_bad.c"  
  -Harness driver with a simple main() that calls the bad function symbolically

I built the harness by doing
clang++-14 -I ~/klee/include -emit-llvm -c -g -O0 driver_CWE415_s02_bad.cpp -o harness_415_s02.bc

LLM Prompt:
"Create an instrumental file and driver file for this Juliet test case:
https://github.com/arichardson/juliet-test-suite-c/blob/master/testcases/CWE415_Double_Free/s02/CWE415_Double_Free__new_delete_array_struct_01.cpp

The instrumented file should contain only the bad() function (CWE415_Double_Free__new_delete_array_struct_01_bad), plus any minimal type definitions and includes needed, with no good() functions or main(). The driver file should define main(), include the instrumented file, and call the bad() function once."


