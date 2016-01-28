#!/bin/bash
#
if [[ -z "$(screen -ls APPNAME | sed -rn 's/[^\s](.*).APPNAME(.*)/\1/p')" ]]
then
    screen -dmS APPNAME ~/bin/mono --debug PATH
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> ~/.userdocs/cronjobs/logs/APPNAME.log 2>&1
    exit
fi
