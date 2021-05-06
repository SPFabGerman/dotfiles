#!/bin/sh

lf -remote "send $id set nopreview"
lf -remote "send $id set ratios 1:2"
$EDITOR "$1"
lf -remote "send $id set preview"
lf -remote "send $id set ratios 1:2:2"

