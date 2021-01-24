#!/bin/sh

# Gets and displays the tags for the current monitor

source ~/.config/polybar/polybar_desktop_symbols.sh


MONNR=$(polybar -m | grep "$MONITOR" | awk '{print $2}' | xargs dwmq mon)

TAGS=$(dwmq montags $MONNR)
OCCTAGS=$(dwmq occ)

for ((i = 0; i < 9; i++)); do
	CURTAG="${TAGS:$i:1}"
	CUROCCTAG="${OCCTAGS:$i:1}"

	SYMBOL=""
	AFTERTEXT=""
	WID=$(dwmq masterwin $i)
	if [ "$?" -eq 0 ]; then
		SYMBOL="$(getSymbol $WID)"
		AFTERTEXT="%{T6} %{T5}$(($i + 1))%{T6}%{O-1} %{T1}"
	fi

	if [ -z "$SYMBOL" ]; then
		AFTERTEXT="%{T1} "
		if [ "$CURTAG" = "1" ]; then
			SYMBOL=${TAGUSE[$i]}
		elif [ "$CUROCCTAG" = "1" ]; then
			SYMBOL=${TAGOCC[$i]}
		else
			SYMBOL=${TAGNORM[$i]}
		fi
	fi

	if [ "$CURTAG" = "1" ]; then
		echo -n "%{A1:dwmc viewex $i:}%{R} %{T4}${SYMBOL}${AFTERTEXT}%{R}%{A}"
	else
		echo -n "%{A1:dwmc viewex $i:} %{T4}${SYMBOL}${AFTERTEXT}%{A}"
	fi
done

# Display Layout
echo " $(dwmq monlayout $MONNR)"

