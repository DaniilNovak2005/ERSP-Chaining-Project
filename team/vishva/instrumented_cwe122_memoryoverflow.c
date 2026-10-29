#include <klee/klee.h> // <-- 1. Include the KLEE header
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>

// --- Definitions to make code runnable ---
// Provide a stub for SRC_STR, making it long enough
// so the bug is clearly the destination overflow.
static char global_src_str[128];
#define SRC_STR global_src_str




typedef struct _charVoid
{
    char charFirst[16];
    void * voidSecond;
    void * voidThird;
} charVoid;

#ifndef OMITBAD

void CWE122_Heap_Based_Buffer_Overflow__char_type_overrun_memmove_02_bad()
{
    if(1)
    {
        {
            // Initialize source string
            memset(global_src_str, 'A', 127);
            global_src_str[127] = '\0';

            charVoid * structCharVoid = (charVoid *)malloc(sizeof(charVoid));

            // <-- 2. Use klee_assume() to model preconditions
            // We assume malloc was successful to explore the buggy path.
            klee_assume(structCharVoid != NULL);

            structCharVoid->voidSecond = (void *)SRC_STR;
            //printLine((char *)structCharVoid->voidSecond);

            /* FLAW: Use the sizeof(*structCharVoid) which will overwrite the pointer y */

            // <-- 3. Add klee_assert() right before the sink
            //
            // This assertion encodes the safety property of memmove:
            // The copy size must be <= the destination buffer size.
            //
            // KLEE will check:
            // Is sizeof(*structCharVoid) (e.g., 32) <= sizeof(structCharVoid->charFirst) (16)?
            // This is FALSE, so KLEE will report an error on this line.

            klee_assert(sizeof(*structCharVoid) <= sizeof(structCharVoid->charFirst));



            // SINK (The vulnerable operation)
            memmove(structCharVoid->charFirst, SRC_STR, sizeof(*structCharVoid));

            structCharVoid->charFirst[(sizeof(structCharVoid->charFirst)/sizeof(char))-1] = '\0';
            //printLine((char *)structCharVoid->charFirst);
            //printLine((char *)structCharVoid->voidSecond);

            // Good practice: free memory
            free(structCharVoid);
        }
    }
}
#endif
