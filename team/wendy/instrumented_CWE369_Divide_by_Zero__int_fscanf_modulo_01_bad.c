/* instrumented_CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad.c */
#include <stdio.h>

/* declare the driver-provided symbolic source (implemented in driver) */
int __klee_source(void);

/* Preserve the original function name and sink logic, but replace fscanf */
void CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad()
{
    int data;
    /* Initialize data */
    data = -1;

    /* STUB: replace fscanf(stdin, "%d", &data); with symbolic source */
    data = __klee_source();

    /*QUESTION: Why dont we have to provide a klee_assert() here despite the lack of branches? Can KLEE automatically
    detect dbz vulnerability via modulo? */
    /* POTENTIAL FLAW: Possibly divide by zero (modulo) */
    int result = 100 % data;
}
