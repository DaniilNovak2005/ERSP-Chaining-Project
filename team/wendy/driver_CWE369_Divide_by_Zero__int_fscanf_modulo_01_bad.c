#include "klee/klee.h"
#include <assert.h>

// Provide the symbolic input
int __klee_source(void) {
    int x;
    klee_make_symbolic(&x, sizeof(x), "data");
    return x;
}

#include "instrumented_CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad.c"

int main() {
    CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad();
    return 0;
}
