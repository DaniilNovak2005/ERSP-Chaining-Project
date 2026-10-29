# LLM Prompt Creation For Harness Generation

## What I Tried To Do
My goal was to create a prompt for the LLM that can generate a driver and an instrumented version of any C function I give it. The idea is that it should work no matter what vulnerability shows up in the code.

## What Is Working So Far
After a lot of trial and error, the prompt is now working well for the two vulnerability types I focused on. I tested it in a few different ways: giving it only the bad function with no comments, giving it the full test case with no comments, and giving it everything with the function names removed so the LLM could not guess where the vulnerability was. In all of those situations, the prompt still produced the right driver and instrumentation. I haven’t tried it yet on vulnerabilities that need more complex data structures like linked lists. From what you mentioned, I know that making those symbolic is a bit harder, so that might be a challenge when I get to it.

## What Is Blocking Or Confusing Me
Right now, I feel like I understand the task well and don’t have anything blocking me.
