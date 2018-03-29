#!/bin/bash
#
if [[ -z "$(screen -ls APPNAME | sed -rn 's/[^\s](.*).APPNAME(.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/APPNAME.lock" ]]
then
    # screen command
	echo -n "$(screen -ls APPNAME | sed -rn 's/[^\s](.*).APPNAME(.*)/\1/p')" > ~/.userdocs/pids/APPNAME.pid
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> ~/.userdocs/cronjobs/logs/APPNAME.log 2>&1
    exit
fi
