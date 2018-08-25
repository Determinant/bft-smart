#!/bin/bash
rep=({0..15})
if [[ $# -gt 0 ]]; then
    rep=($@)
fi
rm -f config/currentView
for i in "${rep[@]}"; do
    echo "starting replica $i"
    exec ./runscripts/smartrun.sh bftsmart.demo.counter.CounterServer "$i" > log"$i" 2>&1 &
done
wait
