#!/bin/bash
n="$(grep 'system.servers.num = ' config/system.config | sed 's/.*= \(.*\)$/\1/g')"
rep=($(seq 0 $(( n - 1 ))))
class="$1"
shift 1
rm -f config/currentView
for i in "${rep[@]}"; do
    echo "starting replica $i"
    exec ./runscripts/smartrun.sh "$class" "$i" "$@" > log"$i" 2>&1 &
done
wait
