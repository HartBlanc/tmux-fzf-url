import sys
from os.path import isfile, join

possible_paths = set()

for line in sys.stdin:
    line_words = line.split()
    possible_paths = possible_paths.union({
        ' '.join(line_words[i: j]) for i in range(len(line_words)) for j in range(i + 1, len(line_words) + 1)
    })

paths = [s for s in possible_paths if isfile(join(sys.argv[1],s))]
print("\n".join(paths))
