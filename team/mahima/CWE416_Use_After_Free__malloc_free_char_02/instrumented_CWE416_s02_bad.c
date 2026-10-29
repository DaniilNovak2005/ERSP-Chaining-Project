// instrumented_CWE416_s02_bad.c
//
// Instrumented version of CWE416_Use_After_Free__malloc_free_char_02.c

#include <stdlib.h>  // malloc, free
#include <string.h>  // strcpy

// Stub this function and make sure it actually dereferences the pointer so that KLEE will detect a use-after-free on the freed memory.
static void printLine(char *str) {
    if (!str) return;

    // Force a read from the memory pointed to by str
    // If str points to freed memory, KLEE will flag an invalid read
    volatile char c = str[0];
    (void)c;
}

// This is logically equivalent to the Juliet bad() function for this test case
void CWE416_Use_After_Free__malloc_free_char_02_bad(void) {
    char *data;

    data = NULL;

    // Allocate 100 chars on the heap
    data = (char *)malloc(100 * sizeof(char));
    if (data == NULL) {
        // Juliet would call exit(-1) but just return to make it simpler
        return;
    }

    // Initialize the buffer similarly to the original.
    strcpy(data, "A String");

    // Free the allocated memory.
    free(data);

    // Use-after-free: data has been freed but is still used
    printLine(data);
}
