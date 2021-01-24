#!/bin/sh
# A Selection of Programms that can be selected and started with dmenu

SEL=(dmenu_run firefox thunderbird libreoffice typora telegram-desktop discord zoom mumble st firefoxYoutubeDL code)

for ele in "${SEL[@]}"; do
	echo "$ele"
done | dmenu -i -p "Run:" -l 5 | stdin_run

