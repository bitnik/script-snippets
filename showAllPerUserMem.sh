#!/bin/sh
#
# print total memory usage in percent of all available users
# but skips the ones with a memory usage of zero
#
# 1st column: user
# 2nd column: memory usage
#
# to sort by memory usage, pipe the output to 'sort -k2 -nr'
#

set -e

for user in $(getent passwd | awk -F ":" '{print $1}' | sort -u)
do

    (top -b -n 1 -u $user | awk -v user=$user -v total=$total 'NR>7 { sum += $10; } END { if (sum > 0.0) print user, sum; }') &
    # don't spawn too many processes in parallel
    sleep 0.05
done
