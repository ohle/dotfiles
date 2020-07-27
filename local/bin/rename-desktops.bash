#!/bin/bash

function area() {
    local w=$(xwininfo -id "$1" | awk '/Width:/ { print $2 }')
    local h=$(xwininfo -id "$1" | awk '/Height:/ { print $2 }')
    echo $(( h * w ))
}

function xprop_strip() {
    tmp=$(echo -e "${1}" | sed -e 's/^[[:space:]]*"//')
    echo -e "${tmp}" | sed -e 's/"[[:space:]]*$//'
}

function title() {
    tmp=$(xprop -id "$1" WM_NAME | cut -d= -f2)
    xprop_strip "${tmp}"
}

function class() {
    tmp=$(xprop -id "$1" WM_CLASS | cut -d= -f2)
    tmp=$(echo -e "${tmp}" | sed -e 's/^.*,//')
    xprop_strip "${tmp}"
}

function biggestwindow() {
    max=0
    windows=$(bspc query -N -n .window -d $1)
    if [ $? -ne 0 ]
    then
        echo ""
        return
    fi
    for window in $windows
    do
        A=$(area $window)
        if [[ A -gt max ]]
        then
            max=A
            maxId=$window
        fi
    done
    echo $maxId
}

function rename() {
    bspc desktop "$1" --rename "$2"
}


function kitty_rename() {
    local title=$(title "$1")
    local termhost=$(echo "${title}" | sed -e "s/^\w\+@\(\w\+\): .*/\1/")
    local path=$(echo "${title}" | sed -e "s/^$USER@\w\+: //")
    if [ "$termost" = "$HOST" ]
    then
        echo "$path"
    else
        echo "$host"
    fi
}

function scan_and_rename() {
    for desktop in $(bspc query -D)
    do
        window=$(biggestwindow $desktop)
        if [ -n "$window" ]
        then
            case $(class $window) in
                "jetbrains-idea-ce")
                    rename $desktop "%{T3}  %{T-}$(title $window | awk -F ' – ' '{ print $2 }' | sed -e 's/^\[//' | sed -e 's/\]$//' )%{T-}"
                    ;;
                "Code")
                    rename $desktop "%{T3}  %{T-}$(title $window | awk -F ' - ' '{ print $2 }')%{T-}"
                    ;;
                "Firefox")
                    rename $desktop "%{T3} %{T-}"
                    ;;
                "Chromium")
                    rename $desktop "%{T3} %{T-}"
                    ;;
                "Microsoft Teams - Preview")
                    rename $desktop "%{T3} %{T-}"
                    ;;
                "kitty")
                    rename "$desktop" "%{T3} %{T-} $(kitty_rename $window)"
                    ;;
                "Spotify")
                    rename "$desktop" "%{T3}%{T-}"
                    ;;
                *)
                    rename "$desktop" $(title $window)
                    ;;
            esac
        fi
    done
}

bspc subscribe monitor_add monitor_remove monitor_swap desktop_add desktop_remove desktop_swap desktop_transfer node | \
    while read -r line; do	# trigger on any bspwm event
        scan_and_rename
    done
