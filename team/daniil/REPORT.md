# CodeQl query writing

# 1. Baseline creation

First, I created the makefile for the CWE directory using the juliet.py file in the master directory.

```bash
python3 juliet.py -g -m
```

Then I created the CodeQL db using the generated makefile, whilst cwd was the CWE directory.

```bash
codeql database create dbersp --language=cpp --command="make . all"
```

Finally, I entered the parent testcases directory, and ran my queries.

```bash
codeql database analyze dbersp ../codeql-custom --format=sarif-latest --output=v2.sarif --rerun
```

# 2. Evaluation and Refinement

I first tried to evaluate the vulnerabilities by setting the malloc string creation as the source function, and using tainted flow to select all print functions that used the data before the free function was called. This led to way too many results being found and marked wrongly.

After rerunning it, the findings count decreased from 10k+ to 250.

For example in file CWE416_Use_After_Free\_\_malloc_free_char_01.c,
I previously had 3 finding which detected every free memory call (Inefficient and wrong), after refining the data flow, I was able to pinpoint only one call to printLine after free had been called.

In another file, CWE416_Use_After_Free\_\_new_delete_array_char_12.cpp,
I was not catching the error in the v1 query, as I had not anticipated the delete[] array method. After reworking it, I was able to pinpoint the source of the error and the line that misused the freed data.

## 3. Results

The rule that I created was to flag any print call using the argument of a free/delete/delete[] function. This was to model the use after free condition of CWE 416. In the juliet-db, the example functions are easy to identify and characterize, which allowed me to use a very simple pattern and data flow to get close to baseline performance.

I chose to ignore the Sanitizer function, as it was irrelevant in my CWE(My CWE's good source never called the print function at all). For the sources, I initially chose the malloc function, but switched to the free function after not finding results. This is to simply find any Data Flow existant to a print function, which would be the vulnerability. The sink was any function with the string "print" in it.

To validate my findings, I searched up 10 of the baseline results in v2, and was able to find each one of them. My v2 was also more efficient in finding some of the more obfuscated vulnerabilities, and was able to detect at least one for each file in the CWE directory. Although, there were some excessive calls and false flags.

The current limitations is that my approach may not be able to detect other uses of freed data outside of print statements. I believe the next step is to introduce more sinks into the query, so that it can give more accurate results.
