#include <assert.h>

int __klee_source_CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad(void);

void CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad()
{
    int data = __klee_source_CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad();

    /* ASSERTION LOCATION: ensure data != 0 before modulo */
    klee_assert(data != 0);
    int result = 100 % data;
    (void)result;
}
