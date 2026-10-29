#include "klee/klee.h"

float __klee_source_CWE369_Divide_by_Zero__float_connect_socket_21_bad(void) {
    float data;
    klee_make_symbolic(&data, sizeof(data), "data");
    return data;
}

#include "instrumented_CWE369_Divide_by_Zero__float_connect_socket_21_bad.c"

int main(void) {
    CWE369_Divide_by_Zero__float_connect_socket_21_bad();
    return 0;
}
