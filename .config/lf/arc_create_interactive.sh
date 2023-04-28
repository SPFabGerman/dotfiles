#!/bin/bash

# Arguments are the files to compress

read -p "Archive Name: " AN

arc -folder-safe=false archive "$AN" "$@"

if [[ "$?" -ne 0 ]]; then
    read -p "[Press Enter to close]" T
fi

