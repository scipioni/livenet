#!/bin/bash

#OVERRIDE DO_DIOSK MODE in LN_CLIENT
 

do_kiosk() {
   ratpoison &
   wmpid=$!
   sleep 2 # Wait until ratpoison starts up.
   PATH=/usr/bin/google-chrome:${PATH}
   PATH=/usr/bin:${PATH}
   #disablea alt left
   xmodmap -e "keycode 64 = "
   xmodmap -e "keycode 204 = "
   #disable from f1 to f10
   xmodmap -e "keycode 67 = "
   xmodmap -e "keycode 68 = "
   xmodmap -e "keycode 69 = "
   xmodmap -e "keycode 70 = "
   #xmodmap -e "keycode 71 = "
   xmodmap -e "keycode 72 = "
   xmodmap -e "keycode 73 = "
   xmodmap -e "keycode 74 = "
   xmodmap -e "keycode 75 = "
   xmodmap -e "keycode 76 = "
   #disable f11 and f12
   xmodmap -e "keycode 95 = "
   xmodmap -e "keycode 96 = "
   #disable ctrl left
   xmodmap -e "keycode 37 = "
   #disable ctrl right
   xmodmap -e "keycode 105 = "
   #disable left shift
   #xmodmap -e "keycode 50 = "
   #disable right shift
   #xmodmap -e "keycode 62 = "

    if [ -f ~/.run ]; then
        exec ~/.run 
    else
        if [ -f ~/.url_to_open ]; then
           URL=$(cat ~/.url_to_open)
        fi
        exec firefox ${URL} --kiosk --no-remote 

    fi

}

export do_kiosk
