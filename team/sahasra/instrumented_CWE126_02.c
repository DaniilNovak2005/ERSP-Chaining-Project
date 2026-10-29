#include "std_testcase.h"

#include <wchar.h>

wchar_t * __klee_source(void);

void CWE126_Buffer_Overread__wchar_t_alloca_loop_01_bad()
{
    wchar_t * data;
    data = __klee_source();
    {
        size_t i, destLen;
        wchar_t dest[100];
        wmemset(dest, L'C', 100-1);
        dest[100-1] = L'\0'; 
        destLen = wcslen(dest);
        /* POTENTIAL FLAW: using length of the dest where data could be smaller than dest causing buffer overread */
        for (i = 0; i < destLen; i++)
        {
            dest[i] = data[i];
        }
        dest[100-1] = L'\0';
        printWLine(dest);
    }
}