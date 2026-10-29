#include "instrumented_CWE126_01.c"

wchar_t * __klee_source(void) {

    wchar_t * dataBadBuffer = (wchar_t *)ALLOCA(50*sizeof(wchar_t));
    klee_make_symbolic(dataBadBuffer, 50 * sizeof(wchar_t), "dataBadBuffer");
    dataBadBuffer[50-1] = L'\0'; /* null terminate */
    return dataBadBuffer;
}


int main(int argc, char * argv[])
{
    /* seed randomness */
    srand( (unsigned)time(NULL) );
    CWE126_Buffer_Overread__wchar_t_alloca_memcpy_01_bad();
    return 0;
}

