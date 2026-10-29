
# Writing a Custom CodeQL Query (C/C++)

Please submit your findings creating a folder in this repo containing:
- A **CodeQL query pack**:
  - `qlpack.yml`
  - `queries/<rule-name>.ql`
  - `README.md` (how to run + what it detects)
- Output artifacts:
  - `baseline.sarif` (running standard queries)
  - `v1.sarif` (your custom query v1)
  - `v2.sarif` (refined query)
- A short report:
  - `REPORT.md` (1–2 pages equivalent)

---

## Target selection
- **Juliet Test Suite (C/C++)**

---

# Part A — Tutorial (Step-by-step)

## A1) Create a CodeQL database

### Option 1: Make-based build
```bash
codeql database create db-<project> \
  --language=cpp \
  --command="make -j"
```

### Option 2: CMake-based build
```bash
codeql database create db-<project> \
  --language=cpp \
  --command="cmake -S . -B build && cmake --build build -j"
```

### Sanity check: run standard queries
```bash
codeql database analyze db-<project> codeql/cpp-queries \
  --format=sarif-latest --output=baseline.sarif
```

---

## A2) Create a custom CodeQL pack

Create this structure:
```text
codeql-custom/
  qlpack.yml
  README.md
  queries/
    ersp-oob-memcpy-length.ql
```

### `qlpack.yml`
```yml
name: ersp/custom-cpp-queries
version: 0.0.1
dependencies:
  codeql/cpp-all: "*"
```

---

## A3) Starter query (v1): tainted `memcpy` length

Create: `queries/ersp-oob-memcpy-length.ql`

```ql
/**
 * @name Potential OOB via tainted memcpy length
 * @description Flags memcpy calls where the length argument is tainted.
 *              This is a starter query; refine it with better sources/sanitizers and bounds reasoning.
 * @kind problem
 * @problem.severity warning
 * @id ersp/cpp/oob-memcpy-tainted-length
 * @tags security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-120
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

class MemcpyCall extends FunctionCall {
  MemcpyCall() {
    this.getTarget().hasName("memcpy") and
    this.getNumArguments() >= 3
  }

  Expr getDest() { result = this.getArgument(0) }
  Expr getSrc()  { result = this.getArgument(1) }
  Expr getLen()  { result = this.getArgument(2) }
}

class MemcpyLenTaintConfig extends TaintTracking::Configuration {
  MemcpyLenTaintConfig() { this = "MemcpyLenTaintConfig" }

  override predicate isSource(DataFlow::Node src) {
    // Generic “untrusted” sources from CodeQL’s standard modeling.
    // Refine this for your project.
    src instanceof FlowSources::UntrustedFlowSource
  }

  override predicate isSink(DataFlow::Node snk) {
    exists(MemcpyCall c |
      snk.asExpr() = c.getLen()
    )
  }

  // Placeholder sanitizer example; refine with real sanitizers/bounds patterns.
  override predicate isSanitizer(DataFlow::Node n) {
    exists(FunctionCall fc |
      fc = n.asExpr().(FunctionCall) and
      fc.getTarget().hasName("min")
    )
  }
}

from MemcpyLenTaintConfig cfg, DataFlow::PathNode src, DataFlow::PathNode snk, MemcpyCall c
where
  cfg.hasFlowPath(src, snk) and
  snk.getNode().asExpr() = c.getLen()
select
  c,
  "memcpy length argument may be influenced by untrusted input (taint flow).",
  src, snk
```

---

## A4) Run your custom query

From inside `codeql-custom/`:
```bash
codeql database analyze ../db-<project> \
  queries/ersp-oob-memcpy-length.ql \
  --format=sarif-latest \
  --output=v1.sarif
```

If you want to analyze all queries in the folder:
```bash
codeql pack install
codeql database analyze ../db-<project> queries/ \
  --format=sarif-latest --output=v1_all.sarif
```

---

## A5) Validate and refine (required)

Your first query will likely report too much. Refinement is the core of this assignment.

### Pick at least **3** refinement steps
1. **Improve sources**: add project-relevant sources (examples: `argv`, `read`, `fread`, `recv`, parsing functions).
2. **Constrain sinks**: only report when destination is likely a fixed-size buffer (stack arrays / struct fields / known-size allocations).
3. **Add sanitizers**: recognize checks like `if (len <= dest_size)` patterns.
4. **Reduce noise**: ignore constant length arguments or `sizeof(dest)`-derived lengths.
5. **Add a second query** (stretch): e.g., `strcpy`/`strcat` usage, `memmove`, `snprintf` misuse, integer overflow in allocation size.

Produce a refined query `v2` and run it:
```bash
codeql database analyze ../db-<project> \
  queries/ersp-oob-memcpy-length.ql \
  --format=sarif-latest \
  --output=v2.sarif
```

---

# Part B — Assignment Tasks

## Task 1 — Baseline (Setup + sanity)
1. Create a CodeQL database for your target.
2. Run standard CodeQL queries and confirm you get results.
3. Record all commands and environment notes.

**Deliverable:**
- `baseline.sarif`
- Commands in `README.md` under “Reproducibility”

---

## Task 2 — Custom Query v1 (must run)
1. Create a CodeQL pack (`qlpack.yml`).
2. Implement a query that detects a security-relevant pattern.
3. Run it and export SARIF.

**Deliverable:**
- `queries/<your-rule>.ql`
- `v1.sarif`

---

## Task 3 — Refinement v2 (precision pass)
Refine your query to reduce at least one class of false positives.

Minimum requirement:
- Provide a **before/after** summary:
  - v1 findings count vs v2 findings count
  - 2–3 example findings that improved (removed or became more targeted)

**Deliverable:**
- `v2.sarif`
- “Refinement Notes” section in `README.md`

---

## Task 4 — Short report (1–2 pages)
Include:
- Rule intent: what pattern you detect
- Mapping to CWE(s)
- Source/Sink/Sanitizer design decisions
- Validation approach (why at least some findings are plausible)
- Limitations and next steps

**Deliverable:**
- `REPORT.md`

---

# Recommended naming conventions
- Folder: `<your_name>_codeql-custom/`
