// instrumented_CWE124_Buffer_Underwrite__char_alloca_ncpy_03_bad.c

#include <string.h>
#include <stdio.h>
#include <alloca.h>

void __klee_source(void *ptr, unsigned long size);

void CWE124_Buffer_Underwrite__char_alloca_ncpy_03_bad()
{
    char *data;
    char *dataBuffer = (char *)alloca(100);
    memset(dataBuffer, 'A', 99);
    dataBuffer[99] = '\0';

    data = dataBuffer - 8;

    char source[100];
    memset(source, 'C', 99);
    source[99] = '\0';

    __klee_source(source, sizeof(source));

    strncpy(data, source, 99);
    data[99] = '\0';

    puts(data);
}