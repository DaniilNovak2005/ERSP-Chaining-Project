/* driver_CWE369_Divide_by_Zero__float_connect_socket_21_bad.c */
#include "klee/klee.h"

/* Produce a symbolic float to replace the socket input */
float __klee_source(void) {
    float data;
    klee_make_symbolic(&data, sizeof(data), "data"); // make 'data' symbolic
    klee_assume(data >= -1000.0f && data <= 1000.0f);  // realistic context

    return data;
}

/* Include the instrumented file */
#include "instrumented_CWE369_Divide_by_Zero__float_connect_socket_21_bad.c"

int main(void) {
    CWE369_Divide_by_Zero__float_connect_socket_21_bad();
    return 0;
}

