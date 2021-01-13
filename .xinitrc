#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xsetroot -cursor_name left_ptr &
numlockx &

lxqt-policykit-agent &

xset s off -dpms

~/.screenlayout/two_screens.sh

# Needed to ensure the tablet only maps to the IPS monitor, instead of both screens at once
xsetwacom --set "HUION Huion Tablet stylus" MapToOutput HEAD-1

# Custom tablet stylus button settings
# Eraser
xsetwacom --set "HUION Huion Tablet stylus" "Button" "2" "key e "
# Right click popup
xsetwacom --set "HUION Huion Tablet stylus" "Button" "3" "button 3 "

# Pan canvas
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "1" "key +space"
# Zoom canvas
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "2" "key +ctrl +space "
# Rotate canvas
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "3" "key +shift +space "
# Change brush size
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "8" "key +shift "
# Undo
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "9" "key +ctrl z -ctrl "
# Redo
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "10" "key +ctrl +shift z -shift -ctrl "
# Horizontal flip
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "11" "key M"
# Reset canvas rotation
xsetwacom --set "HUION Huion Tablet Pad pad" "Button" "12" "key 5 "

exec i3
