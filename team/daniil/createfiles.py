import os 
import sys 

SYMBOL = "✶"

commands = []

def sanitize(filecontent):
    contentlines = filecontent.split('\n')
    for i in range(len(contentlines)):
        if '`' in contentlines[i]:
            contentlines[i] = '\n'
    sep = '\n'
    newcontent = sep.join(contentlines)
    return newcontent

with open(sys.argv[1]) as fp:
    commands = (fp.read()).split("✶")

i = 0
while i < len(commands):
    filepath = commands[i].strip()
    i += 1
    try:
        with open(filepath, 'w') as fp:
            content = commands[i].strip()
            fp.write(sanitize(content))
    i += 1

