
## Week 1: Objectives

By the end of Week 1, you should be able to:

- Explain (briefly) what static analysis is and why it’s useful for vulnerability research (and why false positives happen).
- Install CodeQL CLI and verify it runs locally.
- Build a CodeQL database for a small C/C++ target (Juliet).
- Run at least one existing CodeQL C/C++ security query and view results in SARIF.
- Identify one vulnerability pattern you want to target with a custom query in Week 2 (e.g., unsafe string copy, suspicious `memcpy` length, allocation size overflow).

---

## Week 1: Resources (self-learning)

### CodeQL fundamentals
- CodeQL documentation: “Getting started with CodeQL” and “CodeQL for C/C++”
- “CodeQL query language” basics (predicates, classes, `select`)
- Standard C/C++ query packs: `codeql/cpp-queries` and `codeql/cpp-all`

### Practical references (learn by reading)
- Browse existing queries in the CodeQL C/C++ query suite (look for patterns you recognize: `memcpy`, `strcpy`, `malloc`, taint tracking).
- Focus on how queries define:
  - What they match (AST patterns)
  - What they report (the `select`)
  - Any flow reasoning (dataflow/taint tracking)

### Output & results
- SARIF format basics (how to open/view; understand file, line, message, and rule id).
- Optional: GitHub code scanning SARIF upload (only if you already know how).

### Minimal commands you should know
- `codeql version`
- `codeql database create ...`
- `codeql database analyze ... --format=sarif-latest --output=...`

---

If you want a concrete starting point for Week 1, use Juliet as the target and aim to get:
1. A successful database build, and  
2. A SARIF file from running standard queries.
