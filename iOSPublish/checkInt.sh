#!/bin/bash
# Auth:bell@greedlab.com

if [[ $1 != *[!0-9]* ]]; then
    echo "'$1' is strictly numeric"
else
    echo "'$1' has a non-digit somewhere in it"
fi
