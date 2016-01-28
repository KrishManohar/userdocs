#!/bin/bash
#
if [[ -z "$(screen -ls APPNAME | sed -rn 's/[^\s](.*).APPNAME(.*)/\1/p')" ]]
then
    screen -dmS APPNAME ~/bin/mono --debug PATH
    echo "APPNAME was restarted"; echo
fi
