#!/bin/sh
DIR="$1"
shift 1
g++ -MM -MG "$@" | sed -E 's#^(.*\.o: *)src/(.*/)?(.*\.cpp)#build/\2\1src/\2\3#' | sed -E 's#^(.*\.o: *)RL-Shared/(.*/)?(.*\.cpp)#build/\2\1RL-Shared/\2\3#'
