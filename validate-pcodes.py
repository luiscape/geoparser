"""
Validate a CSV file of place codes (p-codes) to ensure that every entry has a parent.

Expected CSV rows:

name - printable name of the location
pcode - p-code identifier for the location
parent - p-code identifier for the location's parent (empty for a country)
admlevel - hierarchical level (not used)

Started by David Megginson, 2014-10-16
"""

import csv
import sys

pcodes_seen = {}

entries_missing_parents = []

reader = csv.DictReader(sys.stdin)

for entry in reader:
    """
    First pass - filter out every row whose parent we've already seen
    """
    pcode = entry['pcode']
    parent_pcode = entry['parent']
    if parent_pcode and not pcodes_seen.get(parent_pcode, False):
        entries_missing_parents.append(entry)
    pcodes_seen[pcode] = pcode

for entry in entries_missing_parents:
    """
    Second pass - go back and see if we can resolve any more parents
    (If not, then print a message for each one)
    """
    parent_pcode = entry['parent']
    if not pcodes_seen.get(parent_pcode, False):
        print "Parent p-code " + parent_pcode + " missing for " + entry['name'] + " (" + entry['pcode'] + ")"

# end
