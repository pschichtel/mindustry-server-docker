#!/usr/bin/env bash

wrapper_args=()
if [ $# -gt 0 ]
then
    for arg in "$@"
    do
        commands+="$arg"$'\n'
    done
    wrapper_args+=(-i "$commands")
fi

tcp-wrapper "${wrapper_args[@]}" -- java -jar server.jar

