#include <limits.h>
#include <assert.h>

char __klee_source_CWE190_Integer_Overflow__char_fscanf_add_12_bad(void);

void CWE190_Integer_Overflow__char_fscanf_add_12_bad()
{
    /* symbolic input replacing fscanf */
    char data = __klee_source_CWE190_Integer_Overflow__char_fscanf_add_12_bad();

    /* ASSERTION LOCATION: ensure data < CHAR_MAX before addition */
    klee_assert(data < CHAR_MAX);
    char result = data + 1;
    (void)result;
}
