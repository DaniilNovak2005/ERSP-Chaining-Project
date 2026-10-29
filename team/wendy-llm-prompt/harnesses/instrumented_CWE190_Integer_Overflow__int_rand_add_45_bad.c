#include <limits.h> 
#include <assert.h>

int __klee_source_CWE190_Integer_Overflow__int_rand_add_45_bad(void);

void CWE190_Integer_Overflow__int_rand_add_45_bad()
{
    int data = __klee_source_CWE190_Integer_Overflow__int_rand_add_45_bad();

    /* ASSERTION LOCATION: ensure data != INT_MAX before addition */
    klee_assert(data != INT_MAX);
    int result = data + 1;
    (void)result;
}
