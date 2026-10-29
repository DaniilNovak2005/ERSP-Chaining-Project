# Custom CodeQL Query: Use After Free

## Overview

This repository contains a custom CodeQL query designed to detect (CWE-416) vulnerabilities.

The query tracks memory that has been deallocated via `free`, `delete`, or `delete[]` and flags it if it is then used as an argument in a print statement.

## Directory Structure

- `qlpack.yml`: CodeQL package definition.
- `queries/`: Contains the `.ql` source file.
- `baseline.sarif`: Results from standard CodeQL queries.
- `v2.sarif`: Results from the refined custom query.

## Reproducibility

```bash
python3 juliet.py -g -m
```

```bash
codeql database create dbersp --language=cpp --command="make . all"
```

```bash
codeql database analyze dbersp ../codeql-custom --format=sarif-latest --output=v2.sarif --rerun
```

# OLD

# LLM-Assisted Fuzzing and Symbolic Execution Harness Generation

## Daniil Novak

## Example build

for each cwe, go to output/generated, and run the build.sh file. Then run the run_klee.sh file.

## Python usage

### readandprint.py

Input the target directory as an arg:
python3 readandprint.py <TARGET DIRECTORY>

### createfiles.py

Input the file to read from (NOTE, this may be buggy and require some manual edits.).

## Info

I will elaborate further later, but essentially I tried to make the LLM understand and directly work with my environment.
