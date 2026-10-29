# LLM-Assisted Fuzzing and Symbolic Execution Harness Generation

## Using klee_assert for Vulnerability-Specific Checks
Purpose: When your instrumented test files have no branches or weak constraints, KLEE will choose a trivial model (e.g., data = 0) and explore a single path with no errors.

Fix: encode the exact safety property you want KLEE to violate using `klee_assert(...)`, and provide minimal path context with `klee_assume(...)`.

Core Pattern:
- Make inputs symbolic with `klee_make_symbolic`.
- Add minimal `klee_assume(...)` preconditions to model the real context.
- Insert a vulnerability-specific `klee_assert(...)` immediately before the sink.
- Run KLEE; a failing input will produce `ASSERTION.err`.

```
/* skeleton near the vulnerable sink */

klee_make_symbolic(&x, sizeof(x), "x");
/* minimal preconditions */
klee_assume(/* context that makes the sink reachable */);

/* the safety property for THIS CWE */
klee_assert(/* property that must hold if the code is safe */);

/* vulnerable instruction (sink) */
SINK();
```

#### Quick Templates:

CWE-121/122: OOB Write
```
klee_assume(0 <= idx && idx < N + 8);  // context window
klee_assert(idx < N);                  // must stay within bounds
buf[idx] = 0x41;                       // sink

```
CWE-127: OOB Read:
```
klee_assume(0 <= idx && idx < N + 8);
klee_assert(idx < N);
(void)buf[idx];                        // sink
```

CWE-369: Divide by Zero
```
klee_assert(den != 0);
z = x / den;                           // sink
```
CWE-416: Use-After-Free (model state as assumptions)
```
klee_assume(ptr_freed);                // from modeled control flow
klee_assert(!ptr_freed);               // must not use after free
use(*p);                               // sink

```


