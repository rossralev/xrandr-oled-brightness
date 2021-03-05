#!/bin/bash

FILENAME='lastbrightness.txt'
touch $FILENAME
LEVEL=$(cat $FILENAME)

MONITOR=$(xrandr | grep " connected" | cut -f1 -d " ")

calc() { awk "BEGIN{print $*}"; }

doTheMagic() {
    STEP=$1
    LEVEL=$(expr $LEVEL + $STEP)

    if [ "$LEVEL" -gt 100 ];then 
        LEVEL=100 
    fi

    if [ "$LEVEL" -lt 0 ];then 
        LEVEL=0 
    fi

    v=$( calc "$LEVEL"/100 )

    echo "$LEVEL" > "$FILENAME"
    
    xrandr --output "$MONITOR" --brightness "${v/,/.}"
}

doTheMagic 0

acpi_listen | while IFS= read -r line;
do
     
    if [[ "$line" =~ ^video\/brightnessdown ]]; then
        doTheMagic -5 
    elif [[ "$line" =~ ^video\/brightnessup ]]; then
        doTheMagic 5
    fi

    #xrandr --output "$MONITOR" --brightness "$LEVEL"

done

