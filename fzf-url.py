import sys
from os.path import isfile

all_substrings = set()

for line in sys.stdin: 
    all_substrings = all_substrings.union({
        line[i: j] for i in range(len(line)) for j in range(i + 1, len(line) + 1)
    })

paths = sorted([s for s in all_substrings if isfile(s)])
print("\n".join(paths))
