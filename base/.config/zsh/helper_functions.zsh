function fgrep {
    local sync=""
    if [ "$1" = "--sync" ]; then
        sync="--sync"
        shift 1
    fi

    local qpattern=""
    if [ "$#" -eq 0 ]; then
        qpattern="--query="
    else
        qpattern="--query=$1"
        shift 1
    fi

    if [ "$#" -ne 0 ]; then
        # File List supplied -> search all files
        grep -Hn --color=always "" /dev/null "$@" 2>/dev/null | fzf --no-sort --multi $sync --exact "$qpattern"
    else
        if [ -t 0 ]; then
            # Input is TTY -> Run cat
            cat | fzf --no-sort --multi --sync --exact "$qpattern"
        else
            # Input is not TTY -> get input and don't wait for input to finish (unless sync is given)
            fzf --no-sort --multi $sync --exact "$qpattern"
        fi
    fi

}

function showColorCodes {
    local max=256
    if [ "$1" = "-16" ]; then
        max=16
    elif [ "$1" = "-8" ]; then
        max=8
    fi

    local i=0
    while [ "$i" -lt "$max" ] ; do

        printf "\e[48;5;%sm%3d\e[0m " "$i" "$i"
        local m=$(( ($i - 15) % 6 ))
        if [[ $i -eq 7 || $i -eq 15 || $i -eq 243 || ( $i -gt 15 && $i -lt 232 && $m -eq 0 ) ]]; then
            printf "\n";
        fi
        m=$(( ($i - 15) % 36 ))
        if [[ $i -eq 15 || $i -eq 255 || ($i -gt 15 && $m -eq 0 ) ]]; then
            printf "\n";
        fi

        i=$(($i + 1))
    done
}

