#!/bin/bash
#
# Part 1: A cron based restarter for a custom instance of rtorrent and autodl.
# Part 2: A cron based auto-patcher for an installation of autodl to a custom instance using the userdocs script.
#
#
# The suffix is set here to be used throughout this cronscript.
# Please set the path to your www root here.
wwwurl="$HOME/www/$(whoami).$(hostname -f)/public_html"
#
# The restart job for your custom rtorrentinstallation.
if [[ -z "$(screen -ls rtorrent | sed -rn 's/[^\s](.*).rtorrent[\t](.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/rtorrent.lock" && -d "$HOME/private/rtorrent" ]]; then
	kill -9 "$(echo $(ps x | grep -w 'rtorrent\s-*' | grep -v grep | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS "rtorrent" && screen -S "rtorrent" -p 0 -X stuff "rtorrent^M"
	echo -n "$(screen -ls rtorrent | sed -rn 's/[^\s](.*).rtorrent[\t](.*)/\1/p')" > "$HOME/.userdocs/pids/rtorrent.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/rtorrent.log" 2>&1
    exit
fi
#
# The restart job for your custom autodl installation.
if [[ -z "$(screen -ls autodl | sed -rn 's/[^\s](.*).autodl[\t](.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/autodl.lock" && -d "$HOME/.autodl" ]]; then
	kill -9 "$(echo $(ps x | grep -w 'autodl$' | grep -v grep | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS "autodl" && screen -S "autodl" -p 0 -X stuff "irssi/^M"
	screen -S "autodl" -p 0 -X stuff '/autodl update^M'
	echo -n "$(screen -ls autodl | sed -rn 's/[^\s](.*).autodl[\t](.*)/\1/p')" > "$HOME/.userdocs/pids/autodl.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/autodl.log" 2>&1
    exit
fi
#
# Some checks to see what the current host settings are hard coded to. If the program updated it will be set to 127.0.0.1 otherwise it will be 10.0.0.1
[[ -f "$HOME/.irssi/scripts/AutodlIrssi/GuiServer.pm" ]] && autodlfix="$(sed -rn "s#(.*)'(.*)';#\2#p" $HOME/.irssi/scripts/AutodlIrssi/GuiServer.pm)"
[[ -f "$wwwurl/rutorrent/plugins/autodl-irssi/getConf.php" ]] && rutorrentfix="$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $wwwurl/rutorrent/plugins/autodl-irssi/getConf.php)"
#
# Autodl host patch
[[ "$autodlfix" = '127.0.0.1' ]] && sed -i "s|'127.0.0.1';|'10.0.0.1';|g" "$HOME/.irssi/scripts/AutodlIrssi/GuiServer.pm" && updated="1"
#
# Autodl Rutorrent host patch
[[ "$rutorrentfix" = '127.0.0.1' ]] && sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent/plugins/autodl-irssi/getConf.php" && updated="1"
#
[[ "$updated" -eq "1" ]] && screen -S "autodl-$suffix" -p 0 -X stuff '/run autorun/autodl-irssi.pl^M' && updated="0"