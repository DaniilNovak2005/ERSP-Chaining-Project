#!/bin/bash
set -e

klee harness_fgets_03.bc
mv klee-last klee-fgets_03

klee harness_connect_socket_01.bc
mv klee-last klee-connect_socket_01