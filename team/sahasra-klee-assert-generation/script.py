import os
# import requests
import subprocess
import json
# from dotenv import load_dotenv
from openai import OpenAI
import re

BUFFER_FUNCS = re.compile(
    r"\b("
    r"memcpy|memmove|memset|memcmp|memchr|memccpy|"
    r"wmemcpy|wmemmove|wmemset|"
    r"strcpy|strncpy|strcat|strncat|sprintf|snprintf|"
    r"wcscpy|wcsncpy|wcscat|wcsncat|swprintf|"
    r"read|fread|gets|fgets|recv|recvfrom"
    r")\b"
)

ARRAY_ACCESS = re.compile(r"\b\w+\s*\[\s*\w+\s*\]")
POINTER_ARITH = re.compile(r"\*\s*\(\s*\w+\s*\+\s*\w+\s*\)")
WRONG_SIZE = re.compile(
    r"(memcpy|memmove)\s*\(\s*(\w+)\s*,\s*(\w+)\s*,.*(strlen|wcslen)\(\s*\2\s*\)"
)
INT_UNDERFLOW_DEC = re.compile(r"\b(\w+)\s*--\b|\b(\w+)\s*=\s*\2\s*-\s*1\b")
INT_UNDERFLOW_INDEX = re.compile(r"\[\s*\w+\s*-\s*\w+\s*\]")

# -----------------------------
# CONFIGURATION
# -----------------------------
DEEPSEEK_API_KEY = os.getenv('DEEPSEEK_API_KEY')

client = OpenAI(
    api_key=DEEPSEEK_API_KEY,
    base_url="https://api.deepseek.com"   # adjust if using local or custom endpoint
)

def generate_klee_assert(vuln_type: str, sink_code: str, model="deepseek-chat"):
    """
    Generates klee_assert statements from vulnerability type + sink code.

    Args:
        vuln_type (str): e.g., "buffer overflow", "integer overflow"
        sink_code (str): code snippet where vulnerability may occur
        model (str): DeepSeek model, usually "deepseek-chat"

    Returns:
        str: Generated klee_assert code
    """
    prompt = f"""
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
"""
    
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.2,
    )

    try:
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.2,
        )
        assert_code = response.choices[0].message.content
    except Exception as e:
        print(f"[Error] Failed to generate KLEE assert: {e}")
        assert_code = ""


    print(assert_code)

    return assert_code

# clean code before detecting sinks to avoid false positives
def clean_code(lines: list):
    cleaned_lines = []

    for i, line in enumerate(lines):

        # Remove multi-line block comments
        if '/*' in line:
            line = re.sub(r'/\*.*', '', line)
        if '*/' in line:
            line = re.sub(r'.*\*/', '', line)
            continue  # skip the rest of this line
        line = re.sub(r'/\*.*?\*/', '', line)
        # Remove line comments
        line = re.sub(r'//.*', '', line)
        # Remove string literals
        line = re.sub(r'"(?:\\.|[^"\\])*"', '""', line)
        # Normalize whitespace
        line = re.sub(r'\s+', ' ', line)
        # Strip leading/trailing spaces
        line = line.strip()
        cleaned_lines.append(line)

    return cleaned_lines

# look for patterns based on vuln type: memcpy, wmemset, memmove, strncpy for buffer overread
# integer underflow: any operations being performed: *, -, +, /
# for now, only detect one sink
def detect_sinks(lines: list):
    sinks = []
    
    for i, line in enumerate(lines):
        if BUFFER_FUNCS.search(line):
            sinks.append((i+1, "buffer_copy", line.strip()))
        if WRONG_SIZE.search(line):
            sinks.append((i+1, "wrong_length_copy", line.strip()))
        if ARRAY_ACCESS.search(line):
            sinks.append((i+1, "array_access", line.strip()))
        if POINTER_ARITH.search(line):
            sinks.append((i+1, "pointer_arithmetic", line.strip()))
        if INT_UNDERFLOW_DEC.search(line):
            sinks.append((i+1, "int_underflow_decrement", line.strip()))
        if INT_UNDERFLOW_INDEX.search(line):
            sinks.append((i+1, "int_underflow_index", line.strip()))

    return sinks

def insert_klee_asserts(source_file, sinks_with_asserts, output_file=None):
    """
    Insert generated KLEE assertions before detected sink lines.
    
    Args:
        source_file (str): Path to C/C++ source file.
        sinks_with_asserts (list of tuples):
            Each tuple: (line_number, sink_type, code_line, assert_statements)
            assert_statements: list of strings, e.g. ['klee_assert(i<16);']
        output_file (str): Path to write modified file. If None, overwrite source_file.
    """

    if output_file is None:
        output_file = source_file

    # 1. Read original lines
    with open(source_file, 'r') as f:
        lines = f.readlines()

    # 2. Sort sinks by line number ascending (important for multiple insertions)
    sinks_with_asserts.sort(key=lambda x: x[0])

    # 3. Keep track of line offset after insertions
    offset = 0

    for line_number, sink_type, code_line, assert_statements in sinks_with_asserts:
        index = line_number - 1 + offset  # 0-indexed + previous insertions
        # Insert each assert before the sink line
        for i, stmt in enumerate(assert_statements):
            lines.insert(index + i, stmt + "\n")
        offset += len(assert_statements)

    # 4. Write modified file
    with open(output_file, 'w') as f:
        f.writelines(lines)

if __name__ == "__main__":
    # CWE 126 #1
    file_name = "CWE126_01.c"
    vuln_type = "buffer overread"
    with open(file_name, 'r') as f:
        lines = f.readlines()
    # lines = clean_code(lines)
    # for line in lines:
    #     print(line)
    # sinks = detect_sinks(lines)
    # print(sinks)
    line_number = 19  # lines are 0-indexed, but insert_klee_asserts expects 1-indexed
    sink_code = lines[line_number - 1]  # get actual line

    # # Step 2: generate klee_assert string
    # klee_code = generate_klee_assert(vuln_type, sink_code)
    klee_code = 'hi'

    # Step 3: convert string to list of statements
    # If DeepSeek returns multiple lines, split by newline and strip empty lines
    assert_statements = [stmt.strip() for stmt in klee_code.split("\n") if stmt.strip()]

    # Step 4: format as tuple
    sink_with_assert = [(line_number, vuln_type, sink_code.strip(), assert_statements)]

    # Step 5: insert into file
    insert_klee_asserts(file_name, sink_with_assert)

    # # CWE 126 #2
    # file_name = "CWE126_02.c"
    # vuln_type = "buffer overread"
    # with open(file_name, 'r') as f:
    #     lines = f.readlines()
    # # lines = clean_code(lines)
    # # for line in lines:
    # #     print(line)
    # # sinks = detect_sinks(lines)
    # line_number = 15  # lines are 0-indexed, but insert_klee_asserts expects 1-indexed
    # sink_code = lines[line_number - 1]  # get actual line

    # # Step 2: generate klee_assert string
    # klee_code = generate_klee_assert(vuln_type, sink_code)

    # # Step 3: convert string to list of statements
    # # If DeepSeek returns multiple lines, split by newline and strip empty lines
    # assert_statements = [stmt.strip() for stmt in klee_code.split("\n") if stmt.strip()]

    # # Step 4: format as tuple
    # sink_with_assert = [(line_number, vuln_type, sink_code.strip(), assert_statements)]

    # # Step 5: insert into file
    # insert_klee_asserts(file_name, sink_with_assert)

    # # CWE 191 #1
    # file_name = "CWE191_01.c"
    # vuln_type = "integer underflow"
    # with open(file_name, 'r') as f:
    #     lines = f.readlines()
    # # lines = clean_code(lines)
    # # for line in lines:
    # #     print(line)
    # # sinks = detect_sinks(lines)
    # line_number = 10  # lines are 0-indexed, but insert_klee_asserts expects 1-indexed
    # sink_code = lines[line_number - 1]  # get actual line

    # # Step 2: generate klee_assert string
    # klee_code = generate_klee_assert(vuln_type, sink_code)

    # # Step 3: convert string to list of statements
    # # If DeepSeek returns multiple lines, split by newline and strip empty lines
    # assert_statements = [stmt.strip() for stmt in klee_code.split("\n") if stmt.strip()]

    # # Step 4: format as tuple
    # sink_with_assert = [(line_number, vuln_type, sink_code.strip(), assert_statements)]

    # # Step 5: insert into file
    # insert_klee_asserts(file_name, sink_with_assert)

    # # CWE 191 #2
    # file_name = "CWE191_02.c"
    # vuln_type = "integer underflow"
    # with open(file_name, 'r') as f:
    #     lines = f.readlines()
    # # lines = clean_code(lines)
    # # for line in lines:
    # #     print(line)
    # # sinks = detect_sinks(lines)
    # line_number = 9  # lines are 0-indexed, but insert_klee_asserts expects 1-indexed
    # sink_code = lines[line_number - 1]  # get actual line

    # # Step 2: generate klee_assert string
    # klee_code = generate_klee_assert(vuln_type, sink_code)

    # # Step 3: convert string to list of statements
    # # If DeepSeek returns multiple lines, split by newline and strip empty lines
    # assert_statements = [stmt.strip() for stmt in klee_code.split("\n") if stmt.strip()]

    # # Step 4: format as tuple
    # sink_with_assert = [(line_number, "buffer_copy", sink_code.strip(), assert_statements)]

    # # Step 5: insert into file
    # insert_klee_asserts(file_name, sink_with_assert)