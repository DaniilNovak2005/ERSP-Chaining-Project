#include "klee/klee.h"

int __klee_source_CWE190_Integer_Overflow__int_rand_add_45_bad(void) {
    int data;
    klee_make_symbolic(&data, sizeof(data), "data");
    return data;
}

#include "instrumented_CWE190_Integer_Overflow__int_rand_add_45_bad.c"

int main(void) {
    CWE190_Integer_Overflow__int_rand_add_45_bad();
    return 0;
}
