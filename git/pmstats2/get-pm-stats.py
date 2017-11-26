#!/usr/bin/env python
# get-pmstats.py
# Henry J Schmale
# November 25, 2017
# 
# Calculates the additions and deletions per day within a git repository
# by parsing out the git log. It opens the log itself.
# Produces output as a CSV
#
# This segments out certain file wildcards

import subprocess
from datetime import datetime
from fnmatch import fnmatch

def chomp_int(val):
    try:
        return int(val)
    except ValueError:
        return 0

def make_fn_matcher(args):
    return lambda x: fnmatch(''.join(map(str, args[2:])), x)

def print_results(changes_by_date):
    print('date,ins,del')
    for key,vals in changes_by_date.items():
        print(','.join(map(str, [key, vals[0], vals[1]])))

EXCLUDED_WILDCARDS = ['*.eps', '*.CSV', '*jquery*']

changes_by_date = {}
git_log = subprocess.Popen(
    'git log --numstat --pretty="%at"',
    stdout=subprocess.PIPE,
    shell=True)

date = None
day_changes = [0, 0]
for line in git_log.stdout:
    args = line.decode('utf8').rstrip().split()
    if len(args) == 1:
        old_date = date
        date = datetime.fromtimestamp(int(args[0]))
        if day_changes != [0, 0] and date.date() != old_date.date():
            changes_by_date[str(date.date())] = day_changes
            day_changes = [0, 0]
    elif len(args) >= 3:
        # Don't count changesets for excluded file types
        if True in map(make_fn_matcher(args), EXCLUDED_WILDCARDS):
            continue
        day_changes = [sum(x) for x in zip(day_changes, map(chomp_int, args[0:2]))]
print_results(changes_by_date)

