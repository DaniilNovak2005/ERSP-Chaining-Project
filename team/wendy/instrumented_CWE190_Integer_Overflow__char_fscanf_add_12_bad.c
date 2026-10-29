#include <limits.h>
#include <assert.h>
#include "klee/klee.h"

/* Symbolic source provided by the driver */
char __klee_source(void);

void CWE190_Integer_Overflow__char_fscanf_add_12_bad(void) {
    // Get symbolic input instead of reading from console
    char data = __klee_source();

    /* Safety property for CWE-190:
       Normally, adding 1 to data should not overflow. 
       If data == CHAR_MAX, result will wrap around, violating the safety property. */
    klee_assert(data < CHAR_MAX);

    /* BAD SINK: adding 1 may overflow */
    char result = data + 1;

    /* prevent compiler optimization of unused variable */
    (void)result;
}
