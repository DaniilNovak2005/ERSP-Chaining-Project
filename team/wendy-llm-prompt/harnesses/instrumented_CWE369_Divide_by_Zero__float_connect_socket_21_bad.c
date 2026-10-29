#include <assert.h>

float __klee_source_CWE369_Divide_by_Zero__float_connect_socket_21_bad(void);

static int badStatic = 0;

static void badSink(float data)
{
    if(badStatic)
    {
        /* ASSERTION LOCATION: ensure data != 0.0 before division */
        klee_assert(data != 0.0);
        int result = (int)(100.0 / data);
        (void)result;
    }
}

void CWE369_Divide_by_Zero__float_connect_socket_21_bad()
{
    float data = __klee_source_CWE369_Divide_by_Zero__float_connect_socket_21_bad();
    badStatic = 1;
    badSink(data);
}
