#include <klee/klee.h> // For KLEE functions
void CWE121_Stack_Based_Buffer_Overflow__CWE129_large_01_bad();
/* * This is our stub. KLEE will see this and
 * make the 'x' variable symbolic.
 */
int __klee_get_symbolic_int() {
    int x;
    klee_make_symbolic(&x, sizeof(x), "symbolic_input_int");
    return x;
}



/* * This is the new main entry point for KLEE.
 */
int main(int argc, char *argv[]) {

    /* Call the vulnerable function */
    CWE121_Stack_Based_Buffer_Overflow__CWE129_large_01_bad();

    return 0;
}
