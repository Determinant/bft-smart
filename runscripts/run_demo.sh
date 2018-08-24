#!/bin/bash
rep=({0..7})
if [[ $# -gt 0 ]]; then
    rep=($@)
fi
for i in "${rep[@]}"; do
    echo "starting replica $i"
    exec ./runscripts/smartrun.sh bftsmart.demo.counter.CounterServer "$i" > log"$i" 2>&1 &
done
wait
