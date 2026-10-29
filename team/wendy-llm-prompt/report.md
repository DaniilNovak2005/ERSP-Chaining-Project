## LLM Prompt Harnesses Generation

One of the biggest takeaways from this task is how much the quality of the output depends on how the LLM is guided. When the prompt clearly breaks down the task into small, concrete steps, the model performs noticeably better and becomes far more consistent. I saw this directly while building a prompt that generates KLEE drivers and instrumentation files.

At first, the model tended to include extra functions, mix in safe code paths, or keep helper functions that weren’t relevant. To fix that, I refined my prompt to explicitly tell the model to:

- identify which functions are actually vulnerable,
- completely ignore any safe functions or ones that already have checks,
- skip all “good” variants or wrappers,
- and only generate drivers and instrumentation for the vulnerable parts.

Once I added these rules, the LLM started behaving exactly how I wanted.

---

## How I Tested the Final Prompt

After finalizing the prompt, I tested it across different kinds of inputs to see if it could stay consistent:

- **Passing only the vulnerable function with no commented hints like “POTENTIAL FLAW”**  
  The model still detected the vulnerable sink and made the correct variables symbolic.

- **Passing the entire Juliet test case (excluding main) with no comments**  
  Even with a lot of surrounding code and no comment-based hints, the model had to rely on the logic itself, and it correctly isolated the vulnerable section while ignoring everything else.

- **Renaming every function so nothing said “good” or “bad”**  
  This helped confirm it wasn’t relying on naming conventions, and it still performed correctly.

Across all of these tests, the generated drivers and instrumented files were minimal, accurate, and structurally consistent. The model also reliably made the right variables symbolic, even in more complex situations.

---

## Performance

- **The model was more consistent than expected with a well-structured prompt.**  
  After the final refinements, it produced nearly identical layouts across very different inputs.

- **Removing comments and renaming everything didn’t confuse it.**  
  It didn’t rely on labels or keywords—it actually analyzed the code.

- **All generated outputs compiled and ran with KLEE without issues.**  
  The results across all four test cases were almost identical in structure and in the KLEE output.

To put it briefly: the model consistently identified the correct vulnerable logic, produced clean drivers and instrumentation files, made the appropriate symbolic variables, avoided unnecessary helper functions, and compiled and ran cleanly under KLEE.

---

## Main Takeaway

A key lesson from this whole process is that the way you guide the LLM has a huge impact on how good the output is. When the instructions are broken into clear steps and the expectations are specific, the model can produce reliable and accurate results even for something technical like symbolic execution. The LLM did not automatically know how to build the right driver or the right instrumentation on its own. It needed structure, limits on what it could do, and a clear process to follow. Once those things were in place, it stayed consistent across different inputs and test cases.
