# Assignment 6: Insert vulnerability-specific klee_assert calls automatically at sink locations.
## Summary
I tried to automate finding the sink line. Then I prompted the LLM with the vulnerability type and the sink line and asked it to generate a klee_assert statement. Then, I insert the generate klee_assert statement one line before the sink.

**What's working so far:**
The correct sink location is included within all of the detected sinks. My code to insert the generated klee_assert statement works. 

**Blockers/Challenges:**
I had trouble finding an approach to automate the sink detection. My implementation as of now detects many false positives. Currently, I am using python's re.search to find matches of common functions that could be a potential sink location. I am confused on whether this could be the correct approach with some improvements, or if I need to look in a completely different direction. 
I also haven't tested if the prompt is effective yet.

## Step 1: Finding sink line
Create a regular expression object that matches dangerous buffer-related functions for my vulnerabilites (Buffer Overread, Integer Underflow).
**Example from code:**
```bash
BUFFER_FUNCS = re.compile(
    r"\b("
    r"memcpy|memmove|memset|memcmp|memchr|memccpy|"
    r"wmemcpy|wmemmove|wmemset|"
    r"strcpy|strncpy|strcat|strncat|sprintf|snprintf|"
    r"wcscpy|wcsncpy|wcscat|wcsncat|swprintf|"
    r"read|fread|gets|fgets|recv|recvfrom"
    r")\b"
)
```

**Run:**
```bash
line = "memcpy(dest, data, wcslen(dest)*sizeof(wchar_t));"
if BUFFER_FUNCS.search(line):
    sinks.append((i+1, "buffer_copy", line.strip()))
if WRONG_SIZE.search(line):
    sinks.append((i+1, "wrong_length_copy", line.strip()))
```

**Output:** In the format [line number, sink type, exact code]
```bash
[(1, 'buffer_copy', 'memcpy(dest, data, wcslen(dest)*sizeof(wchar_t));'), (1, 'wrong_length_copy', 'memcpy(dest, data, wcslen(dest)*sizeof(wchar_t));')]
```

**Current Issues:**
I am currently detecting too many false positives (code that includes the expressions, but is not a sink) for sink locations using this method. A differnt method might be more suitable to find true sink locations. For now, my code manually assigns the line containing the sink.

## Step 2:
Calls the LLM with the vuln type (such as buffer overread) and a code snippet containing the line with the sink. The LLM may output multiple possible klee_assert statements, but for now, we only consider the first statement. After testing this, I will finalize an approach.
**The LLM prompt:**
You are an expert in symbolic execution and KLEE.

Given the vulnerability type and the sink code, infer a useful
klee_assert(...) constraint that would force KLEE to detect or prevent
the vulnerability.

Return ONLY code, no explanation.

Vulnerability type:
{vuln_type}

Sink code:
{sink_code}

Output format (one per line):
klee_assert(...);
klee_assert(...);
...

**Note:** I have not tested this part of the code yet, so I am not sure if the prompt is sufficient.

## Step 3:
Insert the assert statement just before the sink and writes an updated instrumented file. My current code inserts the generated statement one line before the line with the sink. 

**Potential Issues:** My code doesn't include nice formatting or indentation, which may cause the code to become hard to read over time.
