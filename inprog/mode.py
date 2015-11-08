#!/usr/bin/env python
# Calculates the mode of a list, an attempt at python

import sys

class Counter(dict):
    def __missing__(self, key):
        return 0

c = Counter()

for line in sys.stdin:
    n = int(line)
    c[n] += 1

maxval = 0
for key in c:
    if c[key] > maxval:
        maxval = c[key]

for key in c:
    if c[key] >= maxval:
        print str(key)
