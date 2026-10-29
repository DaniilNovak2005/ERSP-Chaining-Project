/* * This driver is simple because the bug is hard-coded.
 
We just need a main() function to call _bad().*/

// We need this for printLine()
#include "testcasesupport/std_testcase.h"
#include "klee/klee.h"
// Pull in the code we want to test
// (This is the file you were just looking at)
#include "instrumented_CWE122_Heap_Based_Buffer_Overflow__char_type_overrun_memmove_02.c"

// Our new main function that KLEE will run
int main(int argc, char *argv[]) {

   

    //printLine("Calling bad()...");

    // Just call the bad function directly
    CWE122_Heap_Based_Buffer_Overflow__char_type_overrun_memmove_02_bad();

    //printLine("Finished bad().");
    return 0;
}

