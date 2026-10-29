#include "std_testcase.h"

char __klee_source(void);

void CWE191_Integer_Underflow__char_fscanf_sub_01_bad()
{
    char data = __klee_source();
    {
        /* POTENTIAL FLAW: Subtracting 1 from data could cause an underflow */
        char result = data - 1;
        klee_assert((result >= CHAR_MIN));
    }
}
