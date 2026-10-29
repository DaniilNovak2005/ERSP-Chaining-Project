#include "klee/klee.h"

typedef struct {
    int index;   
    int length;  
    int buffer[10];
} RequestFrame;

void complex_data_structure_sink(RequestFrame *frame) {
    if (!frame) {
        return;
    }

    int idx = frame->index;

    int value = frame->buffer[idx];   //potential OOB read

}
