#!/bin/bash
#
# Part 1: A cron based restarter for a custom instance of rtorrent and autodl.
# Part 2: A cron based auto-patcher for an installation of autodl to a custom instance using the userdocs script.
#
#
# The suffix is set here to be used throughout this cronscript.
suffix="SUFFIX"
#
# Please set the path to your www root here.
wwwurl="$HOME/www/$(whoami).$(hostname -f)/public_html"
#
# The restart job for your custom rtorrentinstallation.
if [[ -z "$(screen -ls rtorrent-$suffix | sed -rn 's/[^\s](.*).rtorrent-'"$suffix"'(.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/rtorrent-$suffix.lock" && -d "$HOME/private/rtorrent-$suffix" ]]; then
	kill -9 "$(echo $(ps x | grep -w rtorrent-$suffix | grep -v grep | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS "rtorrent-$suffix" && screen -S "rtorrent-$suffix" -p 0 -X stuff "export TMPDIR=$HOME/.userdocs/tmp; rtorrent -n -o import=$HOME/.rtorrent-$suffix.rc^M"
	echo -n "$(screen -ls rtorrent-$suffix | sed -rn 's/[^\s](.*).rtorrent-'"$suffix"'(.*)/\1/p')" > "$HOME/.userdocs/pids/rtorrent-$suffix.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/rtorrent-$suffix.log" 2>&1
    exit
fi
#
# The restart job for your custom autodl installation.
if [[ -z "$(screen -ls autodl-$suffix | sed -rn 's/[^\s](.*).autodl-'"$suffix"'(.*)/\1/p')" && ! -f "$HOME/.userdocs/tmp/autodl-$suffix.lock" && -d "$HOME/.autodl-$suffix" ]]; then
	kill -9 "$(echo $(ps x | grep -w autodl-$suffix | grep -v grep | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS "autodl-$suffix" && screen -S autodl-$suffix -p 0 -X stuff "export TMPDIR=$HOME/.userdocs/tmp; irssi --home=$HOME/.irssi-$suffix/^M"
	screen -S autodl-$suffix -p 0 -X stuff '/autodl update^M'
	echo -n "$(screen -ls autodl-$suffix | sed -rn 's/[^\s](.*).autodl-$suffix(.*)/\1/p')" > "$HOME/.userdocs/pids/autodl-$suffix.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/autodl-$suffix.log" 2>&1
    exit
fi
#
# Some checks to see what the current host settings are hard coded to. If the program updated it will be set to 127.0.0.1 otherwise it will be 10.0.0.1
[[ -f "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm" ]] && autodlfix="$(sed -rn "s#(.*)'(.*)';#\2#p" $HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm)"
[[ -f "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" ]] && rutorrentfix="$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php)"
#
# Autodl host patch
[[ "$autodlfix" = '127.0.0.1' ]] && sed -i "s|'127.0.0.1';|'10.0.0.1';|g" "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm"
#
# Autodl Rutorrent host patch
[[ "$rutorrentfix" = '127.0.0.1' ]] && sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
#
# Check to see what the hard coded home directory is set to.
[[ -f "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm" ]] && autodlhome="$(sed -n 's#\(.*\)return File::Spec->catfile(getHomeDir(), "\(.*\)");#\2#p' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm")"
#
# This edit set the Autodl home directory, required for a non standard installation.
[[ "$autodlhome" == '.autodl' ]] && sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm" && screen -S autodl-$suffix -p 0 -X stuff '/run autorun/autodl-irssi.pl^M'
#
# This edit sets the path to the autodl.cfg that the rutorrent plugin will use and edit, required for a non standard installation.
[[ "$(cat "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" | grep -wc "'/.autodl-$suffix/autodl.cfg'")" -eq "0" ]] && sed -i "s|'/.autodl/autodl.cfg'|'/.autodl-$suffix/autodl.cfg'|g" "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
