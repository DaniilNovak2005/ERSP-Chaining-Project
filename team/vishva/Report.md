# CodeQL Assignment Report

## 1. Setup & Baseline (Task 1)
To get started, I compiled the Juliet test case (`CWE121...01.c`) into a CodeQL database. I used a manual `gcc` command to keep it simple since I didn't have a Makefile set up for just these specific files.

**Database Creation:**
```bash
codeql database create juliet-db --language=cpp --overwrite \
  --command="gcc -c -I . io.c CWE121_Stack_Based_Buffer_Overflow__char_type_overrun_memcpy_01.c"
```
Sanity Check: I ran the standard CodeQL query suite to make sure the database was actually working correctly.

```
codeql database analyze juliet-db codeql/cpp-queries \
  --format=sarif-latest --output=results.sarif

```
## Custom Query:
For the first version of my custom query, I used the starter code provided in the assignment. I ran into a small issue where the starter code used outdated CodeQL methods (like Taint Tracking Config) that conflicted with the latest version of the CLI. 
I had to update the imports to use the new DataFlow and Taint Tracking.

```
codeql database analyze ~/week_1_lab/juliet-db \
  queries/ersp-oob-memcpy-length.ql \
  --format=sarif-latest \
  --output=v1.sarif
```

The V1 query was pretty noisy because it treated every function parameter as a potential source of bad data, which isn't realistic for actual security bugs.

## Refinements:

1. Source Constraint: I switched the source to only look for command line arguments, the user. This ignores internal function-to-function calls and only flags data actually coming from the user.
2. Sink should only be memcpy length. I only care if the size is tainted, because that is what causes the overflow.
3. Sanitizer: I added a check for min(). If data passes through this, do not flag it as a vulnerability.

## Results:

v1 and v2 had findings of length 0! At first, getting 0 results for both queries seemed wrong, but after manually looking at the source code, I realized this is actually the correct behavior. The code uses sizeof which is a
a compile-time constant. It isn't a variable, it isn't a parameter, and it certainly doesn't come from argv.

## Conclusion:
Because the bad length is hardcoded by the compiler, there is no data flow for my query to track. The Taint Tracking query correctly ignored it because no user input ever touches that length argument. 





