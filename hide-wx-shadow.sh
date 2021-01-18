#!/bin/bash
#
#   To hide the shadow of wechat in wine.
#
#   Dependencies: wmctrl, xdotool
#
#   Syntax:
#
#       (in foreground) $ ./hide-wx-shadow.sh
#       (in background) $ ((./hide-wx-shadow.sh &) &)
#

shopt -s lastpipe

while true; do

    # hide the shadow of wechat main window
    wlist1=$(
        wmctrl -l -G -p -x | \
            grep wechat.exe | \
            head -n 1 | \
            awk --non-decimal-data '{printf("0x%x", $1 + 8)}' \
    )

    # hide the shadow of image preview
    wlist2=""
    wmctrl -l -G -p -x | \
        grep wechat.exe | \
        grep "Image Preview" | \
        while read x; do
            w1=$(echo $x | awk --non-decimal-data '{printf("0x%x", $1 + 4)}')
            w2=$(echo $x | awk --non-decimal-data '{printf("0x%x", $1 + 6)}')
            wlist2="$wlist2 $w1 $w2"
        done

    # hide the shadow of video player
    wlist3=""
    wmctrl -l -G -p -x | \
        grep wechat.exe | \
        grep "WeChat" | \
        tail -n +2 | \
        while read x; do
            w1=$(echo $x | awk --non-decimal-data '{printf("0x%x", $1 + 2)}')
            w2=$(echo $x | awk --non-decimal-data '{printf("0x%x", $1)}')
            wlist3="$wlist3 $w1 $w2"
        done

    for x in $wlist1 $wlist2 $wlist3; do 
        xdotool windowunmap $x > /dev/null 2>&1
    done

    sleep 5

done

exit 0
