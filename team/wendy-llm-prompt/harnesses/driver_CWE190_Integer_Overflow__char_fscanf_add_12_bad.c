#include "klee/klee.h"

char __klee_source_CWE190_Integer_Overflow__char_fscanf_add_12_bad(void) {
    char data;
    klee_make_symbolic(&data, sizeof(data), "data");
    return data;
}

#include "instrumented_CWE190_Integer_Overflow__char_fscanf_add_12_bad.c"

int main(void) {
    CWE190_Integer_Overflow__char_fscanf_add_12_bad();
    return 0;
}
