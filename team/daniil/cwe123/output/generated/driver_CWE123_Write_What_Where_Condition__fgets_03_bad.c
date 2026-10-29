// driver_CWE123_Write_What_Where_Condition__fgets_03_bad.c

extern void klee_make_symbolic(void *addr, unsigned long nbytes, const char *name);

typedef struct _linkedList {
struct _linkedList *next;
struct _linkedList *prev;
} linkedList;

typedef struct _badStruct {
linkedList list;
} badStruct;

void __klee_source(void *ptr) {
klee_make_symbolic(ptr, sizeof(badStruct), "data");
}

#include "instrumented_CWE123_Write_What_Where_Condition__fgets_03_bad.c"

int main(void) {
CWE123_Write_What_Where_Condition__fgets_03_bad();
return 0;
}