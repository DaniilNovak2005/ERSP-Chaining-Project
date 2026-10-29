# LLM-Assisted KLEE Harness Generation

This repository contains the source code and build instructions for generating KLEE harnesses for two Juliet Test Suite vulnerabilities.


LLM Prompt: Given Instrumented File, Write me driver so that I can create a harness. 

---

## CWE121: Stack-Based Buffer Overflow

This harness finds a bug where a symbolic integer is used to access a stack array without a proper bounds check.

* **Source Code:** `driver_cwe121.c`, `instrumented_cwe121.c`
* **Harness Method:** The `driver_cwe121.c` file defines `main()` and includes `instrumented_cwe121.c`. The instrumented file was modified to remove `printLine` calls, and the driver provides a symbolic integer via a stub function.

### Build Command

```bash
clang-13 -emit-llvm -c -g -O0 \
  -I ../../../ \
  -I ~/klee/include \
  driver_cwe121.c \
  -o harness.bc \
  -target x86_64-unknown-linux-gnu

Run KLEE: klee harness.bc


Expected error: KLEE: ERROR: .../instrumented_cwe121.c:27: memory error: out of bound pointer

```
----------------------------------------------------------------------------------------------------------------------------------------

## CWE122: Heap-Based Buffer Overflow
This harness finds a hard-coded bug where memmove is called with an incorrect sizeof value, causing it to write data past the end of an allocated heap buffer.

Source Code: driver_cwe122.c, instrumented_cwe122.c

Harness Method: This case was more complex.

The instrumented_cwe122.c file was modified to remove all printLine calls.

The driver_cwe122.c file defines main() and includes the instrumented file.

```bash

clang-13 -emit-llvm -c -g -O0 \
  -I ../../../ \
  -I ~/klee/include \
  driver_cwe122.c \
  -o harness.bc \
  -target x86_64-unknown-linux-gnu

  ```

Problem: KLEE does not find the error, my guess is because it might be fixing the error on its own?

I asked an LLM to help me and it gave me commands to fix this:

~/klee/build/bin/klee --disable-opt --libc=none harness.bc
--libc=none: Stops KLEE from linking its own safe C library, which would "fix" the buggy memmove.
--disable-opt: Stops KLEE's internal optimizer from replacing the memmove call before analysis even begins.


Fix: (Help of Shafi)

 klee_assume(structCharVoid != NULL);
 klee_assert(sizeof(*structCharVoid) <= sizeof(structCharVoid->charFirst));

Then Run KLEE and you get an ASSERTION.err

This error means KLEE executed the hard-coded path and saw the memmove function attempt to write data outside the bounds of the malloc'd heap buffer, which is a critical heap-based buffer overflow.
