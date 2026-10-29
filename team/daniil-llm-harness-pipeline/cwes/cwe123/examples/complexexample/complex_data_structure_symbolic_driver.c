#include "klee/klee.h"
#include "instrumented_complex_data_structure.c"

int main(void) {
    RequestFrame frame;

    /* Step 1: create separate symbolic variables */
    int sym_index;
    int sym_length;
    int sym_buffer[10];

    klee_make_symbolic(&sym_index,  sizeof(sym_index),  "index");
    klee_make_symbolic(&sym_length, sizeof(sym_length), "length");
    klee_make_symbolic(sym_buffer,  sizeof(sym_buffer), "buffer");

    /* Step 2: bind symbolic vars into the struct */
    frame.index  = sym_index;
    frame.length = sym_length;
    for (int i = 0; i < 10; ++i) {
        frame.buffer[i] = sym_buffer[i];
    }

    /* Step 3: bind struct to a pointer and call the sink */
    RequestFrame *frame_ptr = &frame;
    complex_data_structure_sink(frame_ptr);

    return 0;
}
