typeset -U path
path=(/home/palpinter/.local/bin $path)
path=(/home/palpinter/Fejlesztés/Android/tools $path)
path=(/home/palpinter/Fejlesztés/Android/platform-tools $path)

XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share

JAVA_HOME=/usr/lib/jvm/java-8-openjdk/
ANDROID_HOME=/home/palpinter/Fejlesztés/Android

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
