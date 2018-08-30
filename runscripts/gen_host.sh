#!/bin/bash
f="nodes.txt"
awk '{ split($1, a, ":"); split(a[3], b, ";"); print a[1], a[2], b[1]; }' nodes.txt > config/hosts.config
