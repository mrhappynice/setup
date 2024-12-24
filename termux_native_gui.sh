#!/bin/bash
set -e

pkg update
pkg upgrade

pkg install x11-repo
pkg install xfce4 tigervnc

vncserver -localhost

vncserver -kill :1

echo "xfce4-session &" > ~/.vnc/xstartup

chmod +x ~/.vnc/xstartup

pkg install firefox

echo "If you have low res issue, open Firefox and hit F11 to full screen then exit."
echo " "

echo "Run to start VNC Server: vncserver -localhost"
echo "Connect with VNC app to the local address on port 5901: 127.0.0.1:5901"
echo "Stop with: vncserver -kill :1"
