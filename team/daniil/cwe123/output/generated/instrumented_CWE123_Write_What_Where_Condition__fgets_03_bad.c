// instrumented_CWE123_Write_What_Where_Condition__fgets_03_bad.c

/* Use declarations already defined in driver */
void __klee_source(void *ptr);

/* Import struct types without redefining them */
extern linkedList dummy_ll;
extern badStruct dummy_bs;

/* Globals */
static linkedList *linkedListPrev, *linkedListNext;

void CWE123_Write_What_Where_Condition__fgets_03_bad()
{
badStruct data;
static linkedList head = { &head, &head };

data.list.next = head.next;
data.list.prev = head.prev;
head.next = &data.list;
head.prev = &data.list;

__klee_source(&data);

linkedListPrev = data.list.prev;
linkedListNext = data.list.next;
linkedListPrev->next = linkedListNext;
linkedListNext->prev = linkedListPrev;


}