// driver_CWE124_Buffer_Underwrite__char_alloca_ncpy_03_bad.c

// DO NOT include <klee/klee.h>; declare manually for compatibility.
extern void klee_make_symbolic(void *addr, unsigned long nbytes, const char *name);

void __klee_source(void *ptr, unsigned long size) {
    klee_make_symbolic(ptr, size, "buf");
}

#include "instrumented_CWE124_Buffer_Underwrite__char_alloca_ncpy_03_bad.c"

int main(void) {
    CWE124_Buffer_Underwrite__char_alloca_ncpy_03_bad();
    return 0;
}