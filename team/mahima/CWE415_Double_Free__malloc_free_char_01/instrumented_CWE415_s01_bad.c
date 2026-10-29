// instrumented_CWE415_s01_bad.c
//
// Instrumented version of:
//   CWE415_Double_Free__malloc_free_char_01.c

#include <stdlib.h>   // for malloc, free
#include <string.h> 

//logically equivalent to the Juliet bad() function
void CWE415_Double_Free__malloc_free_char_01_bad(void) {
    char *data;

    // Juliet initializes data to NULL first
    data = NULL;

    // Allocate 100 chars
    data = (char *)malloc(100 * sizeof(char));
    if (data == NULL) {
        // Juliet calls exit(-1) on malloc failure but just return to keep things simple for KLEE
        return;
    }

    // FIRST free - correct use
    free(data);

    // SECOND free - double Free bug 
    free(data);
}

