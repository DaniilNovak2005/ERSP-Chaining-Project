# LLM-Generated KLEE Harnesses for Symbolic Execution

This repository contains a set of instrumented test cases and drivers for exploring two vulnerability classes using KLEE symbolic execution: **Integer Overflow (CWE-190)** and **Divide-By-Zero (CWE-369)**.

Each test includes:

- a driver file that provides symbolic input to KLEE, and  
- an instrumented Juliet test case where `klee_assume` and `klee_assert` encode the safety property we want KLEE to violate.

---

## Included Test Cases

### **Integer Overflow — CWE-190**

#### 1. `CWE190_Integer_Overflow__int_rand_add_45_bad.c`
**Vulnerability:** A random integer is incremented by 1. If the initial value is `INT_MAX`, the addition overflows.

#### 2. `CWE190_Integer_Overflow__char_fscanf_add_12.c`
**Vulnerability:** A char read from stdin is incremented. If it's at `CHAR_MAX`, adding 1 wraps around.

---

### **Divide By Zero — CWE-369**

#### 3. `CWE369_Divide_by_Zero__float_connect_socket_21_bad.c`
**Vulnerability:** A float is read from a simulated socket. If the value is zero or near-zero, `100.0 / data` becomes unsafe.

#### 4. `CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad.c`
**Vulnerability:** An integer from stdin is used as a divisor in a modulo operation. If it's zero, the modulo crashes.

---

## How to Build and Run

### 1. Compile to LLVM bitcode

```bash
clang -I /usr/lib/klee/include -emit-llvm -c -g -O0 driver_<test>.c -o harness.bc
```

**Example build command:**

Replace <test> with the appropriate driver filename (e.g., driver_CWE190_Integer_Overflow__int_rand_add_45_bad.c).

### 2. Run with KLEE

```bash
klee harness.bc
```


