#!/bin/bash
#
if [[ -z "$(screen -ls rtorrent-SUFFIX | sed -rn 's/[^\s](.*).rtorrent-SUFFIX(.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/rtorrent-SUFFIX.lock" && -d $HOME/private/rtorrent-SUFFIX ]]
then
	kill -9 "$(echo $(ps x | grep -w rtorrent-SUFFIX | grep -v grep | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS rtorrent-SUFFIX && screen -S rtorrent-SUFFIX -p 0 -X stuff "export TMPDIR=$HOME/.userdocs/tmp; rtorrent -n -o import=$HOME/.rtorrent-SUFFIX.rc^M"
	echo -n "$(screen -ls rtorrent-SUFFIX | sed -rn 's/[^\s](.*).rtorrent-SUFFIX(.*)/\1/p')" > ~/.userdocs/pids/rtorrent-SUFFIX.pid
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> ~/.userdocs/cronjobs/logs/rtorrent-SUFFIX.log 2>&1
    exit
fi
#
if [[ -z "$(screen -ls autodl-SUFFIX | sed -rn 's/[^\s](.*).autodl-SUFFIX(.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/autodl-SUFFIX.lock" && -d $HOME/.autodl-SUFFIX ]]
then
	kill -9 "$(echo $(ps x | grep -w autodl-SUFFIX | grep -v grep | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS autodl-SUFFIX && screen -S autodl-SUFFIX -p 0 -X stuff "export TMPDIR=$HOME/.userdocs/tmp; irssi --home=$HOME/.irssi-SUFFIX/^M"
	screen -S autodl-SUFFIX -p 0 -X stuff '/autodl update^M'
	echo -n "$(screen -ls autodl-SUFFIX | sed -rn 's/[^\s](.*).autodl-SUFFIX(.*)/\1/p')" > ~/.userdocs/pids/autodl-SUFFIX.pid
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> ~/.userdocs/cronjobs/logs/autodl-SUFFIX.log 2>&1
    exit
fi