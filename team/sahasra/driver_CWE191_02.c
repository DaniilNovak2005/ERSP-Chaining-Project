#include "instrumented_CWE191_02.c"

char __klee_source(void) {
    char data;
    data = ' ';
    klee_make_symbolic(&data, sizeof(data), "data");
    return data;
}

int main(int argc, char * argv[])
{
    CWE191_Integer_Underflow__char_fscanf_sub_01_bad();
    return 0;
}

