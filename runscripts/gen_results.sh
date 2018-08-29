#!/bin/bash
attrs=('Consensus Msg'
'LC Msg'
'VM Msg'
'Forward Msg'
'SM Msg'
'MAC bytes'
'Sig'
'Sig bytes'
)
for attr in "${attrs[@]}"; do
    let res=0
    for f in "$@"; do
        inc=$(grep "$attr:" "$f" | sed 's/.*: \(.*\)$/\1/g')
        let res+=inc
    done
    echo "$attr: $res"
done
