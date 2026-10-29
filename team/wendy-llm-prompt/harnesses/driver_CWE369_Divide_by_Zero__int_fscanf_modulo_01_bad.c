#include "klee/klee.h"

int __klee_source_CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad(void) {
    int data;
    klee_make_symbolic(&data, sizeof(data), "data");
    return data;
}

#include "instrumented_CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad.c"

int main(void) {
    CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad();
    return 0;
}
