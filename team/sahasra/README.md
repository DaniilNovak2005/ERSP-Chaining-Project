# LLM-Assisted Symbolic Execution Harness Generation

## How to Build and Run Example
```bash
clang -emit-llvm -c -g driver_CWE191_02.c -o CWE191.bc
klee CWE191.bc
```

## CWE126: Buffer Overread
These testcases are trying to allocate values larger than the size of the object/buffer. To check for this using KLEE, the buffer contents are made symbolic. 

## CWE191: Integer Underflow
A user input char is used in operations such as multiplication and subtraction. If the operation results in a value that is less than CHAR_MIN, then there is an integer underflow. We check for this using a klee_assert() statement.
