rm -rf klee-test-results

echo "----------------------------------------"

# --- 1. COMPILE ---
echo "Compiling C files to LLVM bitcode..."

# Compiling the driver
clang-13 -emit-llvm -c -g -O0   -I /home/vishva/klee/include   driverCWE121.c   -o driverCWE121.bc

# Compiling the instrumented file
clang-13 -emit-llvm -c -g -O0   -I /home/vishva/klee/include   instLargeNum.c   -o instLargeNum.bc

# Check if compilation failed
if [ $? -ne 0 ]; then
  echo "Compilation failed!"
  exit 1
fi

echo "Individual .bc files created."

# --- 2. LINK ---
echo "Linking .bc files together..."
llvm-link-13 driverCWE121.bc instLargeNum.bc -o harness.bc

if [ $? -ne 0 ]; then
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
echo "Results are stored in: $(pwd)/klee-test-results"
