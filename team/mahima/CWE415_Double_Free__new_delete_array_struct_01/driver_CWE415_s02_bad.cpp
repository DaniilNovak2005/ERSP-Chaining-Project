// driver_CWE415_s02_bad.cpp

#include "klee/klee.h"
#include "instrumented_CWE415_s02_bad.cpp"

int main() {
    int flag;
    klee_make_symbolic(&flag, sizeof(flag), "flag");

    if (flag > 0) {
        CWE415_Double_Free__new_delete_array_struct_01_bad();
    }

    return 0;
}

