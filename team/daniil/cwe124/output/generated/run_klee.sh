#!/bin/bash
set -e

# POSIX + uClibc only. Compatible with SNAP KLEE.
KLEE_OPTS="--posix-runtime --libc=uclibc"


klee $KLEE_OPTS harness_ncpy_03.bc
mv klee-last klee-ncpy_03

klee $KLEE_OPTS harness_cpy_01.bc
mv klee-last klee-cpy_01