// driver_CWE124_Buffer_Underwrite__char_alloca_cpy_01_bad.c

// Manual declaration (NO #include <klee/klee.h>)
extern void klee_make_symbolic(void *addr, unsigned long nbytes, const char *name);

void __klee_source(void *ptr, unsigned long size) {
    klee_make_symbolic(ptr, size, "buf");
}

#include "instrumented_CWE124_Buffer_Underwrite__char_alloca_cpy_01_bad.c"

int main(void) {
    CWE124_Buffer_Underwrite__char_alloca_cpy_01_bad();
    return 0;
}