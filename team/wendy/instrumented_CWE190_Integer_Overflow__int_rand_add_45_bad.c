// instrumented_CWE190_Integer_Overflow__int_rand_add_45_bad.c
#include <limits.h>
#include "klee/klee.h"

/* declare the driver-provided symbolic source */
int __klee_source(void);

static int CWE190_Integer_Overflow__int_rand_add_45_badData;

static void badSink()
{
    int data = CWE190_Integer_Overflow__int_rand_add_45_badData;

    /* Safety property for CWE-190:
       Adding 1 to data must not overflow.
       True safety condition:
           data < INT_MAX
       KLEE will try to violate this.
    */
    klee_assert(data < INT_MAX);

    /* SINK: the actual vulnerable operation */
    int result = data + 1;

    (void)result;
}

void CWE190_Integer_Overflow__int_rand_add_45_bad()
{
    int data = 0;
    data = __klee_source();
    CWE190_Integer_Overflow__int_rand_add_45_badData = data;
    badSink();
}
