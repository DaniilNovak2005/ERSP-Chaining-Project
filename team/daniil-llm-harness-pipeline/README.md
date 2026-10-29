# ERSP Test Pipeline for CWE123/CWE124

## Workflow

1. Install requirements.txt.
2. Make sure clang-13 and llvm-13 are installed, this is required for execution.
3. Configure config.json to your liking, (Note container is not implemented currently).
4. Set env DEEPSEEK_API_KEY=sk-xxxxxx
5. Run py main.py <Path to config.json> <Total API Call limit>
6. Go to cwes/cwexxx/output/generated
7. Results are most likely generated, but you can run build.sh and then run_klee.sh to generate new ones.

## Script overview

### Initial Execution

My driver script, main.py, uses the openai module to call the deepseek API and record its responses. I use a configurable json file to allow for different prompts and settings to be used. Once settings are finished, you can run main.py. The main.py script will go through each folder in ./cwes. 

### Core loop initialization
For each CWE, it will start the core harness generation loop. It will first read every subfile of the cwe123 folder other than the output. It compiles this in an understandable format (FE path -> file contents -> path ...) for the LLM to read. Then it will call the llm with the first prompt to describe the task + rules, as well as the code. 

### Response Handling
After the llm responds, the script will run both build and run_klee.sh. As of right now, there are no extended checks beyond making sure both scripts do not exit with an error code. If symbolic execution is successful, the script moves on. If it is not, then the LLM is called again. It is given the initial prompt, as well as a copy of its response and the errors produced along with a few hints. This loop is continued until the limit is reached or success.

## Results
Currently, CWE124 is completley handled by the LLM. The main error, out of bounds pointer, occurs due to the program attempting to access memory that is before the provided limit for the buffer. The LLM is able to replicate this error in its KLEE run. As of now, CWE123 is unhandled due to its complex nature as well as how it uses real time connections and extensive library usage. 

## Challenges + Solutions
### LLM giving malformed input
A simple check + sanitizing function was able to remedy this issue.
### LLM including klee library, which lead to clang issues.
I had to manually remove this line from every response, and it worked fine.
### LLM unable to symbolically execute more complex CWEs like CWE124.
No solution yet, but I am going to attempt to feed in more complex examples.

