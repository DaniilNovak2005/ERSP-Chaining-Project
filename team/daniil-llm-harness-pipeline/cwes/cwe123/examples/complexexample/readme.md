## Example build & run

clang -emit-llvm -c complex_data_structure_symbolic_driver.c -g -o complex_data_structure_symbolic_driver.bc

klee complex_data_structure_symbolic_driver.bc