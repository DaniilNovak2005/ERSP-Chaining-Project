// driver_CWE190_Integer_Overflow__int_rand_add_45_bad.c
#include "klee/klee.h"
#include <limits.h>
#include <assert.h>

/* Provide the symbolic source used by the instrumented bad function */
int __klee_source(void)
{
    int data;
    klee_make_symbolic(&data, sizeof(data), "data");

    return data;
}

/* Include the instrumented implementation */
#include "instrumented_CWE190_Integer_Overflow__int_rand_add_45_bad.c"

int main(void)
{
    CWE190_Integer_Overflow__int_rand_add_45_bad();
    return 0;
}
