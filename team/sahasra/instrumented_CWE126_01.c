#include "std_testcase.h"

#include <wchar.h>

wchar_t * __klee_source(void);

void CWE126_Buffer_Overread__wchar_t_alloca_memcpy_01_bad()
{
    wchar_t * data;
    data = __klee_source();
    {
        wchar_t dest[100];
        wmemset(dest, L'C', 100-1);
        dest[100-1] = L'\0'; 
        /* POTENTIAL FLAW: using memcpy with the length of the dest where data could be smaller than dest causing buffer overread */
        memcpy(dest, data, wcslen(dest)*sizeof(wchar_t));
        dest[100-1] = L'\0';
        printWLine(dest);
    }
}
