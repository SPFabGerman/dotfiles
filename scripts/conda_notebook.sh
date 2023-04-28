#!/bin/sh

# A Simple Wrapper, to start a jupyter Notebook inside a new Browser extension

source ~/build/anaconda3/bin/activate

if [ "$@" ]; then
	# Also Display Tree View, if a file was directly started
	sleep 0.1;
	firefox -P Scripts "http://localhost:8888/"
fi &

jupyter notebook --browser="firefox -P Scripts %s" "$@"

