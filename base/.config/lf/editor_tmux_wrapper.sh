#!/bin/sh

$EDITOR "$1"
lf -remote "send $id _tmux_edit_stop"

