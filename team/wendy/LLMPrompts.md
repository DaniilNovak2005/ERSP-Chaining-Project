# **LLM Prompts Used to Generate the Drivers & Instrumented Files**

Below is a list of the prompts I used when asking for code generation, explanations, or fixes related to the KLEE harnesses.

---

## **CWE-190: Integer Overflow**

### **1. Test Case: `CWE190_Integer_Overflow__int_rand_add_45_bad.c`**

**Prompts:**
- “can you help me create a KLEE driver and instrumented file for the CWE190 int_rand_add_45 test case?”
- “please show me where to put klee_assert and klee_assume for this integer overflow example.”
- “why is my harness not triggering an overflow? what should I assert right before the sink?”
- “make sure my driver and instrumentation follow my mentor’s instructions (klee_assume then klee_assert right before the addition).”
- “please explain why klee_assume is needed and check my implementation for this test case.”

---

### **2. Test Case: `CWE190_Integer_Overflow__char_fscanf_add_12.c`**

**Prompts:**
- “here is my driver and instrumentation file, please make sure it is correct according to my mentor’s instructions.”
- “what does klee_make_symbolic(&data, sizeof(data), ‘data’) do? can you explain this more?”
- “can you check if I placed the assertion correctly before the sink in the char_fscanf test case?”
- “please verify that my use of klee_source(), klee_assume, and klee_assert for this test case is correct.”

---

## **CWE-369: Divide By Zero**

### **3. Test Case: `CWE369_Divide_by_Zero__float_connect_socket_21_bad.c`**

**Prompts:**
- “here is my divide-by-zero test case. can you help me write the driver and instrumented file for KLEE?”
- “why is KLEE concretizing the float to zero? how should I write the preconditions?”
- “please check whether my klee_assume and klee_assert around the division sink are correct.”
- “can you explain why KLEE fails the assertion immediately? and how to encode the safety property for divide-by-zero?”
- “here is my code for the divide-by-zero float case — is it following my mentor’s pattern?”

---

### **4. Test Case: `CWE369_Divide_by_Zero__int_fscanf_modulo_01_bad.c`**

**Prompts:**
- “I need help instrumenting the modulo test case using klee_assert for divide-by-zero.”
- “show me where to place klee_assume to make the sink reachable in the modulo_01_bad test.”
- “can you generate the correct KLEE harness (driver + instrumented file) for the int modulo divide-by-zero example?”
- “please confirm that my harness follows the correct pattern: symbolic input → precondition assume → assertion → modulo sink.”

---
