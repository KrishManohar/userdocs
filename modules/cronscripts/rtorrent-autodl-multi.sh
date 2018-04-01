#!/bin/bash
#
# Part 1: A cron based restarter for a custom instance of rtorrent and autodl.
# Part 2: A cron based auto-patcher for an installation of autodl to a custom instance using the userdocs script.
#
#
# The suffix is set here to be used throughout this cronscript.
suffix="222aB"
#
# Please set the path to your www root here.
wwwurl="$HOME/www/$(whoami).$(hostname -f)/public_html"
#
# The restart job for your custom rtorrent installation.
#
# Kill dead rtorrent screens as they might linger and cause later checks to give a false positive. Otherwise do nothing.
[[ "$(screen -ls rtorrent-$suffix | sed -rn 's/[^\s](.*).rtorrent-'"$suffix"'[\t](.*)[\t](.*)/\3/p')" == '(Dead ???)' ]] && screen -wipe > /dev/null 2>&1
# Check to see if all 3 required services are running. If not then kill the remaining, delete the lock file if present so the script can then restart the programs.
if [[ "$(ps x | grep -Ecw "rtorrent-$suffix(\.rc)?$" | awk '{print $1}')" -ne '3' && -f "$HOME/private/rtorrent-$suffix/work/rtorrent.lock" ]]; then
    kill -9 "$(echo $(ps x | grep -Ew "rtorrent-$suffix(\.rc)?$" | awk '{print $1}'))" > /dev/null 2>&1
    [[ -f "$HOME/private/rtorrent-$suffix/work/rtorrent.lock" ]] && rm -f "$HOME/private/rtorrent-$suffix/work/rtorrent.lock"
fi
#
if [[ "$(ps x | grep -Ecw "rtorrent-$suffix(\.rc)?$" | awk '{print $1}')" -ne '3' && ! -f "$HOME/private/rtorrent-$suffix/work/rtorrent.lock" && -d "$HOME/private/rtorrent-$suffix" ]]; then
	kill -9 "$(echo $(ps x | grep -Ew "rtorrent-$suffix(\.rc)?$" | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS "rtorrent-$suffix" && screen -S "rtorrent-$suffix" -p 0 -X stuff "rtorrent -n -o import=$HOME/.rtorrent-$suffix.rc^M"
	echo -n "$(echo $(ps x | grep -Ew "rtorrent$" | awk '{print $1}'))" > "$HOME/.userdocs/pids/rtorrent-$suffix.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/rtorrent-$suffix.log" 2>&1
    exit
fi
#
# The restart job for your custom autodl installation.
#
# Kill dead autodl screens as they might linger and cause later checks to give a false positive. Otherwise do nothing.
[[ "$(screen -ls autodl-$suffix | sed -rn 's/[^\s](.*).autodl-'"$suffix"'[\t](.*)[\t](.*)/\3/p')" == '(Dead ???)' ]] && screen -wipe > /dev/null 2>&1
# Check to see if all 2 required services are running. If not then kill the remaining so the script can then restart the programs.
if [[ "$(ps x | grep -Ecw "(autodl$|irssi$)" | awk '{print $1}')" -ne '2' ]]; then
    kill -9 "$(echo $(ps x | grep -Ew "(autodl$|irssi$)" | awk '{print $1}'))" > /dev/null 2>&1
fi
#
if [[ "$(ps x | grep -Ecw "(autodl-$suffix$|irssi-$suffix/$)" | awk '{print $1}')" -ne '2' && ! -f "$HOME/.userdocs/tmp/autodl-$suffix.lock" && -d "$HOME/.autodl-$suffix" ]]; then
	kill -9 "$(echo $(ps x | grep -Ew "(autodl-$suffix$|irssi-$suffix/$)" | awk '{print $1}'))" > /dev/null 2>&1
	screen -wipe > /dev/null 2>&1
    screen -dmS "autodl-$suffix" && screen -S "autodl-$suffix" -p 0 -X stuff "irssi --home=$HOME/.irssi-$suffix/^M"
	screen -S "autodl-$suffix" -p 0 -X stuff '/autodl update^M'
	"$(echo $(ps x | grep -Ew "(autodl-$suffix$|irssi-$suffix/$)" | awk '{print $1}'))" > "$HOME/.userdocs/pids/autodl-$suffix.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/autodl-$suffix.log" 2>&1
    exit
fi
#
# Some checks to see what the current host settings are hard coded to. If the program updated it will be set to 127.0.0.1 otherwise it will be 10.0.0.1
[[ -f "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm" ]] && autodlfix="$(sed -rn "s#(.*)'(.*)';#\2#p" $HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm)"
[[ -f "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" ]] && rutorrentfix="$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php)"
#
# Autodl host patch
[[ "$autodlfix" = '127.0.0.1' ]] && sed -i "s|'127.0.0.1';|'10.0.0.1';|g" "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm" && updated="1"
#
# Autodl Rutorrent host patch
[[ "$rutorrentfix" = '127.0.0.1' ]] && sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" && updated="1"
#
# Check to see what the hard coded home directory is set to.
[[ -f "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm" ]] && autodlhome="$(sed -n 's#\(.*\)return File::Spec->catfile(getHomeDir(), "\(.*\)");#\2#p' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm")"
#
# This edit set the Autodl home directory, required for a non standard installation.
[[ "$autodlhome" == '.autodl' ]] && sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm" && updated="1"
#
# This edit sets the path to the autodl.cfg that the rutorrent plugin will use and edit, required for a non standard installation.
[[ "$(cat "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" | grep -wc "'/.autodl-$suffix/autodl.cfg'")" -eq "0" ]] && sed -i "s|'/.autodl/autodl.cfg'|'/.autodl-$suffix/autodl.cfg'|g" "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
#
[[ "$updated" -eq "1" ]] && screen -S "autodl-$suffix" -p 0 -X stuff '/run autorun/autodl-irssi.pl^M' && updated="0"