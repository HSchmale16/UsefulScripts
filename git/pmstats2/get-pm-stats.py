#!/usr/bin/env python
# get-pmstats.py
# Henry J Schmale
# November 25, 2017
# 
# Calculates the additions and deletions per day within a git repository
# by parsing out the git log. It opens the log itself.
# Produces output as a CSV

import subprocess
from datetime import datetime

changes_by_date = {}
git_log = subprocess.Popen(
    'git log --numstat --pretty="%at"',
    stdout=subprocess.PIPE,
    shell=True)

date = None
day_changes = [0, 0]
for line in git_log.stdout:
    args = line.rstrip().split()
    if len(args) == 1:
        old_date = date
        date = datetime.fromtimestamp(int(args[0]))
        if day_changes != [0, 0] and date.date() != old_date.date():
            changes_by_date[str(date.date())] = day_changes
            day_changes = [0, 0]
    elif len(args) >= 3:
        day_changes = [sum(x) for x in zip(day_changes, map(int, args[0:2]))]

print('date,ins,del')
for key,vals in changes_by_date.items():
    print(','.join(map(str, [key, vals[0], vals[1]])))
