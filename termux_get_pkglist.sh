#!/bin/bash

for pkg in $(apt-cache pkgnames | sort); do printf "$pkg - $(apt-cache show $pkg | grep -m 1 "Description:"  | cut -c 14-)\n"; done >> pkglist.txt
