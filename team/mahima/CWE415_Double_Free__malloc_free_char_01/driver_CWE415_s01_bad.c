// driver_CWE415_s01_bad.c

#include "klee/klee.h"
#include "instrumented_CWE415_s01_bad.c"

int main(void) {
    int flag;

    // Make 'flag' symbolic so KLEE explores both branches.
    klee_make_symbolic(&flag, sizeof(flag), "flag");

    // KLEE will explore:
    //  flag <= 0 : no call, no bug
    //  flag > 0  : bad() called, double free occurs
    if (flag > 0) {
        CWE415_Double_Free__malloc_free_char_01_bad();
    }

    return 0;
}

