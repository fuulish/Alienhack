#!/bin/bash
DIR="$1"
shift 1
RULE=$(g++ -MM -MG "$@" | sed -E 's#^(.*\.o:*)(.*/)?(.*\.cpp)#\2\1\2\3#')
DEPS=
for fname in $(echo "$RULE" | tr -d '\n'  | cut -d':' -f2 | sed s/'\\'//g); do
        f=$(basename $fname)

        for parts in $(echo $fname | sed s/'\.\.\/'/' '/g); do
                grepme=$parts
        done

        DEPS="$DEPS $(find . -name $f | sed s/'\.\/'//g | grep $grepme)"
done
TGT=$(echo "$RULE" | tr -d '\n' | cut -d':' -f1 | sed s/'\s'/''/g)
echo "$TGT: $DEPS"
