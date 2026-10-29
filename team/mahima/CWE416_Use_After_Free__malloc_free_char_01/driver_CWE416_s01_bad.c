// driver_CWE416_s01_bad.c

#include "klee/klee.h"
#include "instrumented_CWE416_s01_bad.c"

int main(void) {
    int flag;
    klee_make_symbolic(&flag, sizeof(flag), "flag");

    if (flag > 0) {
        CWE416_Use_After_Free__malloc_free_char_01_bad();
    }

    return 0;
}

