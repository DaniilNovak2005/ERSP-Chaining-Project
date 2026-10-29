//driver_CWE190_Integer_Overflow__char_fscanf_add_12.c
#include "klee/klee.h"

/* KLEE symbolic source for a char input */
char __klee_source(void) {
    char data;

    // Make 'data' symbolic for KLEE exploration
    klee_make_symbolic(&data, sizeof(data), "data");

    /* Optional: constrain to realistic input range (e.g., printable ASCII)
       This models the real program context. Uncomment if desired: */
    //klee_assume(data >= 0x20 && data <= 0x7E);
    

    return data;
}

/* Include the instrumented implementation */
#include "instrumented_CWE190_Integer_Overflow__char_fscanf_add_12_bad.c"

int main(void) {
    CWE190_Integer_Overflow__char_fscanf_add_12_bad();
    return 0;
}
