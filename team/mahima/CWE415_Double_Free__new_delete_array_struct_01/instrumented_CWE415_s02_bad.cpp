// instrumented_CWE415_s02_bad.cpp
//
// Instrumented version of CWE415_Double_Free__new_delete_array_struct_01.cpp

#include <cstddef>  

struct twoIntsStruct {
    int intOne;
    int intTwo;
};

// logically equivalent to the Juliet bad() function
void CWE415_Double_Free__new_delete_array_struct_01_bad() {
    twoIntsStruct * data;

    // Initialize pointer
    data = nullptr;

    // Allocate array of 100 twoIntsStruct objects on the heap
    data = new twoIntsStruct[100];

    // FIRST delete[] - correct
    delete [] data;

    // SECOND delete[] on the same pointer - this is the double free bug
    delete [] data;
}
