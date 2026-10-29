## The LLM Prompt For Harness Generation:

You are an expert in symbolic execution, program analysis, and KLEE driver generation.

I will give you one or more C functions from any codebase.

Your job is to analyze them and produce **two outputs only for functions that contain actual vulnerabilities**:

1. A correct **KLEE driver**
2. A correct **instrumented version** of the vulnerable function

The code I provide may come from any C program, not a benchmark.

Assume nothing about naming conventions.

---

## **PHASE 0 — Identify which functions matter**

You MUST perform vulnerability triage on all functions I provide:

### Vulnerable

A function is vulnerable if its logic contains a dangerous sink such as:

- use-after-free  
- double free  
- null pointer dereference  
- uninitialized variable usage  
- off-by-one or out-of-bounds access  
- integer underflow or overflow  
- divide-by-zero  
- any condition causing undefined behavior based on input

### Not vulnerable

A function must be ignored if it:

- contains complete safety checks  
- is a helper/utility  
- sanitizes or validates inputs  
- is a wrapper around the real logic  
- implements a safe version of an operation  
- is structurally irrelevant to the vulnerability

Before generating code, internally classify each function as:

(A) Vulnerable  
(B) Not vulnerable

**Only category (A) functions appear in the output.**

All category (B) functions must be fully ignored.

---

# **TASK 1 — Create a complete KLEE driver**

The driver must follow all rules below:

### (A) Allowed includes

Only:

```c
#include "klee/klee.h"
```
No other headers.

### (B) Allowed operations  
You may NOT simulate:  
- stdin, scanf, fscanf, fgets  
- files  
- sockets  
- randomness  
- environment variables  
- printing of any kind  

### (C) Symbolic Input  
Any variable originally influenced by external input must become a symbolic variable:

```c
klee_make_symbolic(&var, sizeof(var), "var");
```


_**Critical: Symbolic variable type MUST match the true type**_
---------------------------------------------------------------

You must preserve the original data type exactly.

For example:

### Do NOT convert everything into int.

 \_\_klee\_source\_\<funcname>() MUST return the correct type matching the original variable's type. Do not make it return int unless the original variable truly is an int.

### Do NOT convert everything into int.

### (D) Driver structure (required)

For each vulnerable function:

1.  Create \_\_klee\_source\_\<funcname>() that returns a symbolic value of the correct type for that function's inputs (e.g., uint64\_t, size\_t, int16\_t, char, etc.) **do not always return int.**
    
2.  Include the instrumented file you generate.
    
3.  Call the vulnerable function in main().
    
4.  Nothing else.
    

**TASK 2 — Create the instrumented function**
=============================================

Follow these strict rules:

### (A) Only include the vulnerable function

Remove or stub:

*   safe functions
    
*   wrappers
    
*   input/output
    
*   printing
    
*   logging
    
*   unrelated branches
    
*   helper or utility functions
    
*   ALL includes (except required ones — see next rule)
    

(B) **Automatically add required headers**
------------------------------------------

If the vulnerable function uses:

*   standard library functions (e.g., pow, strlen, malloc, free, abs)
    
*   standard constants (e.g., INT\_MIN, SIZE\_MAX)
    
*   math routines (e.g., sqrt, log, exp)
    
*   type definitions (uint32\_t, size\_t, etc.)
    

You MUST automatically add the correct header(s) **ONLY to the instrumented file.**

### Rules:

*   Only add **headers actually needed**.
    
*   Never add extra or unused headers.
    
*   Never add headers to the **driver** only to the instrumented file.
    

(C) Replace user input with:
-------------------------

```c
type var = __klee_source_(); 
```

Type must match exactly.

(D) Simplify the function
-------------------------

Remove code unrelated to vulnerability logic.

(E) Insert **ONE comment only** before the vulnerable sink:
-----------------------------------------------------------

Example:

```c
/* ASSERTION LOCATION: ensure ptr != NULL before dereference */   `
```

Do NOT include actual klee\_assert.

Training Examples
-----------------

Here are examples of vulnerability types along with their correct KLEE drivers and instrumented implementations in JSON format:

**After this prompt, I will provide the source code for analysis.**
===================================================================

