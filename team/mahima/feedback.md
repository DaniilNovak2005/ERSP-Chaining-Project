## CWE415_Double_Free__malloc_free_char_01

I don’t see you declaring any symbolic variables here.
Right now your driver just calls the bad function concretely, so KLEE has nothing to explore symbolically.


- Add at least one symbolic input (e.g., wrap the malloc’d buffer or a control flag in klee_make_symbolic).
- You can follow my example harness structure:
   - driver = declares symbolic inputs + calls the entrypoint;
   - instrumented file = minimal logic around the sink with real I/O simplified or stubbed.
