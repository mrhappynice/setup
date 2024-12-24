#!/bin/bash
set -e

pkg update -y && pkg upgrade -y

pkg install x11-repo
pkg install xfce4

pkg install mesa-zink virglrenderer-mesa-zink vulkan-loader-android

MESA_NO_ERROR=1 MESA_GL_VERSION_OVERRIDE=4.3COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 GALLIUM_DRIVER=zink ZINK_DESCRIPTORS=lazy virgl_test_server --use-egl-surfaceless --use-gles &

export DISPLAY=:0

startxfce4 &

echo "To run graphical applications with hardware acceleration, use the following environment variables:"
echo "GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.0 application_name"

echo ""
echo "Connect using X11 app"
