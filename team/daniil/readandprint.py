import os
import sys
content = ""
with os.scandir(sys.argv[1]) as items:
    for item in items:
        if not item.is_file():
            continue
        with open(item.path) as fp:
            try:
                test = fp.read()
                print(os.path.abspath(item.path))
                print(test)
                content += os.path.abspath(item.path) + "\n"
                content += test + "\n"
            except:
                pass

with open(sys.argv[2], 'w') as fp:
    fp.write(content)