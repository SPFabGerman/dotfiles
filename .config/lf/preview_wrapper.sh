#!/bin/sh

stty size

export USETRUECOLOR=1

~/scripts/previewer.sh "$1"

