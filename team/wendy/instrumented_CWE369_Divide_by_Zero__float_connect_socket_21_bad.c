/* instrumented_CWE369_Divide_by_Zero__float_connect_socket_21_bad.c */
#include <math.h>
#include <assert.h>
#include "klee/klee.h"   

/* declare the driver-provided symbolic source (defined in driver) */
float __klee_source(void);

/* Preserve the vulnerable function name and sink logic */
static int badStatic = 0;

static void badSink(float data)
{
    if (badStatic)
    {
       //Force KLEE to expose near-zero values (positive/negative/+-0).
       klee_assert(fabs(data) > 0.000001f);
        
        /* POTENTIAL FLAW: Possibly divide by zero (sink) */
        int result = (int)(100.0 / data);

        /* Prevent compiler optimization removing the calculation */
        (void)result;
    }
}

void CWE369_Divide_by_Zero__float_connect_socket_21_bad(void)
{
    float data = __klee_source(); /* stub for socket input */
    badStatic = 1;
    badSink(data);
}
