
#include "std_testcase.h"

char __klee_source(void);

void CWE191_Integer_Underflow__char_fscanf_multiply_01_bad()
{
    char data;
    data = __klee_source();
    if(data < 0) 
    {
        /* POTENTIAL FLAW: if (data * 2) < CHAR_MIN, this will underflow */
        char result = data * 2;
        klee_assert(!(data < 0) || (result >= CHAR_MIN));
    }
}
