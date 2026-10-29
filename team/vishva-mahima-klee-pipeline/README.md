## CWE121/CWE129: Stack Overflow (Automated Build Script)

This harness finds a bug where a symbolic integer is used to access a stack array. It uses a reusable script to automate the entire compile-link-run pipeline, making it adaptable for future tests.

Source Code: driver.c, instrumentedLargeNum.c

Harness Method: Harness is built from two separate .c files that are compiled independently and then linked together.

driverCWE121.c: Defines main() and the __klee_get_symbolic_int() stub. It includes only the _bad function.

instLargeNum.c: Defines the vulnerable _bad function.

Both files were modified to remove all dependencies on testcasesupport/std_testcase.h (e.g., OMITBAD, printLine), creating a clean, self-contained test.

## Challenges & Solutions


We had a bunch of compile issues:

Challenge: Initial clang errors like cannot specify -o when generating multiple output files and -emit-llvm cannot be used when linking.

Solution: We adopted a two-step process: first, compile each .c file into its own bitcode (.bc) file using clang -c, then link the .bc files together using llvm-link.

Challenge: The initial C code included testcasesupport/std_testcase.h, leading to persistent file not found errors.

Solution: We refactored the C code to remove all dependencies (like OMITBAD and printLine). This completely eliminated the need for complex -I ../../ include paths.

Challenge: The Invalid record error.

Solution: We identified a version mismatch between clang-13 (our compiler) and the generic llvm-link (our linker). Using the version-specific llvm-link-13 ensured the bitcode was compatible and finally fixed the error.

## Build Script (run_klee.sh)

This reusable script automates the entire process. It can be copied to other test directories and modified with new filenames.

Used an LLM to help me make this script:
Prompt: Given this driver and instrumented file, create a script to automate the KLEE build process. We had to edit a lot of things to match filenames and fix compile commands.
```
# --- 0. CLEAN UP ---
echo "Cleaning up old files..."
rm -f harness.bc driverCWE121.bc instLargeNum.bc
rm -rf klee-test-results

echo "----------------------------------------"

# --- 1. COMPILE ---
echo "Compiling C files to LLVM bitcode..."

# Compiling the driver
clang-13 -emit-llvm -c -g -O0 \
  -I /home/vishva/klee/include \
  driverCWE121.c \
  -o driverCWE121.bc

# Compiling the instrumented file
clang-13 -emit-llvm -c -g -O0 \
  -I /home/vishva/klee/include \
  instLargeNum.c \
  -o instLargeNum.bc

# Check if compilation failed
if [ \$? -ne 0 ]; then
  echo "Compilation failed!"
  exit 1
fi

echo "Individual .bc files created."

# --- 2. LINK ---
echo "Linking .bc files together..."
llvm-link-13 driverCWE121.bc instLargeNum.bc -o harness.bc

if [ \$? -ne 0 ]; then
  echo "Linking failed!"
  exit 1
fi

echo "Linking successful: harness.bc created."
echo "----------------------------------------"

# --- 3. RUN KLEE ---
echo "Running KLEE..."
klee --output-dir=klee-test-results harness.bc

# --- 4. REPORT ---
echo "----------------------------------------"
echo "KLEE run finished."
echo "Results are stored in: \$(pwd)/klee-test-results"

```

Script Explanation

Clean Up: Removes old results and any intermediate (.bc) files.

Compile: Uses clang-13 -c to compile driverCWE121.c and instLargeNum.c into their own bitcode files (driverCWE121.bc and instLargeNum.bc).

Link: Uses the version-specific llvm-link-13 to link the two intermediate bitcode files into a single harness.bc.

Run KLEE: Executes KLEE on the final harness.bc and stores the output in klee-test-results.

Expected Error: KLEE: ERROR: instLargeNum.c:22: memory error: out of bound pointer
