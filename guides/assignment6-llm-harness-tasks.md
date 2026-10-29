## Daniil – LLM-assisted driver generator (complex data structures)

**Goal:**  
Use an LLM to generate KLEE drivers for complex data structures.

**This week:**

- Start from the `RequestFrame` PoC ([`complex-data-structure-poc/`](complex-data-structure-poc/)).
- Write a script that:
  - Takes a small JSON spec (data structure shape, sink function name).
  - Calls the LLM to generate a KLEE driver
- Check that the generated driver compiles and runs under KLEE.

---

## Shasra – Automatic assertion insertion at sinks

**Goal:**  
Insert vulnerability-specific `klee_assert` calls automatically at sink locations.

**This week:**
Write a script that:
  - Locates the sink line (e.g., `value = frame->buffer[idx];`).
  - Calls the LLM with the vuln type (e.g., `OOB_READ`) and a code snippet.
  - Gets back a single `klee_assert(...)` (e.g., `idx >= 0 && idx < frame->length && frame->length <= 10`).
  - Inserts the assert just before the sink and writes an updated instrumented file.

---

## Wendy – LLM-generated driver and instrumentation (manual assertion)

**Goal:**  
Use an LLM to generate both a KLEE driver and an instrumented file, but add the assertion manually (no LLM-generated `klee_assert` yet).

**This week:**

Use an LLM to:
  - Generate an instrumented version of the function that exposes the sink.
  - Generate a KLEE driver that:
    - Creates symbolic variables.
    - Calls the instrumented function.
- Manually add a single `klee_assert(...)` at the sink in the instrumented file.
- Make sure the generated driver + instrumented file compile and run under KLEE.

---

## Vishva & Mahima – Simple end-to-end KLEE pipeline

**Goal:**  
Build and run a minimal KLEE example end-to-end via a script.

**This week:**

- Create the driver and instrumented files manually.
- Write a script that:
  - Compiles the driver + function to LLVM bitcode (`clang -emit-llvm -c`).
  - Runs KLEE on the bitcode and reports where results are stored.
- Focus on a reliable **build + KLEE run** for this fixed example (no LLM integration yet).
