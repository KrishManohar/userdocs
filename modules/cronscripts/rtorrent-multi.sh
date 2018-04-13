#!/usr/bin/env bash
#
# Part 1: A cron based restarter for a custom instance of rtorrent and autodl.
#
# Part 2: A cron based auto-patcher for an installation of autodl to a custom instance using the userdocs script.
#
# The suffix is set here to be used throughout this cronscript.
suffix="SUFFIX"
#
# Please set the path to your www root here.
wwwurl="$HOME/www/$(whoami).$(hostname -f)/public_html"
#
# Lets make some required directories. This solution works best alongside these folders for tmp files, logs and more.
mkdir -p ~/.userdocs/{versions,cronjobs/logs,logins,logs,pids,tmp}
#
# If the readme is not present this will create a readme file for the ~/.userdocs directory so that someone can understand why this folder exists. Otherwise do nothing.
[[ ! -f ~/.userdocs/readme.txt ]] && echo 'This is a folder generated by the userdocs installation scripts that you may have used to house important information or components of the script.' > ~/.userdocs/readme.txt
#
##
###
#### Part 1: A cron based restarter for custom instance of rtorrent installed via the manager and or Autodl installed via this script.
###
## The below if section is the restart job for your custom rtorrent installation. This will only manage you custom installation.
#
# This is our check to see if the 3 required processes ares running. This match is very specific and will only match the default installation processes and not other instances. Otherwise do nothing.
if [[ "$(ps -xU $(whoami) | grep -Ev "screen (.*) rtorrent-$suffix" | grep -Ecw "rtorrent-$suffix(\.rc)?$" | awk '{print $1}')" -ne '3' && -d "$HOME/private/rtorrent-$suffix" && ! -f "$HOME/.userdocs/tmp/rtorrent-$suffix.lock" ]]; then
    #
    # Create this file so that the cronjob will skipped if it is restarting the processes and attempts to run again.
    touch "$HOME/.userdocs/tmp/rtorrent.lock-$suffix"
    #
    # Kill the matching processes pid's and then kill command below will provide.
    kill -9 $(echo $(ps -xU $(whoami) | grep -Ew "rtorrent-$suffix(\.rc)?$" | awk '{print $1}')) > /dev/null 2>&1
    #
    # Remove the rtorrent lock file if present since we know the required processes are not running and this file only will prevent a restart.
    screen -wipe > /dev/null 2>&1
    #
    # Create the new screen process in the background and then send it a command.
    [[ -f "$HOME/private/rtorrent/work/rtorrent-$suffix.lock" ]] && rm -f "$HOME/private/rtorrent/work/rtorrent-$suffix.lock"
    #
    # Echo the 3 pids of the running processes to a file ~/.userdocs/pids/rtorrent-SUFFIX.pid
    screen -dmS "rtorrent-$suffix" && screen -S "rtorrent-$suffix" -p 0 -X stuff "rtorrent -n -o import=$HOME/.rtorrent-$suffix.rc^M"
    #
    # Echo the time and date this cronjob was run to the ~/.userdocs/cronjobs/logs/rtorrent-SUFFIX.log
    echo -n "$(echo $(ps -xU $(whoami) | grep -Ev "screen (.*) rtorrent-$suffix" | grep -Ew "rtorrent-$suffix(\.rc)?$" | awk '{print $1}'))" > "$HOME/.userdocs/pids/rtorrent-$suffix.pid"
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/rtorrent-$suffix.log" 2>&1
    #
    # Remove the lock file this cron job created so that the job can run again if required.
    [[ -f "$HOME/.userdocs/tmp/rtorrent-$suffix.lock" ]] && rm -f "$HOME/.userdocs/tmp/rtorrent-$suffix.lock"
    #
fi
#
##
### The restart job for your autodl installation. This will only manage your custom installation.
##
# This is our check to see if the 3 required processes ares running. This match is very specific and will only match custom installation processes and not other instances. Otherwise do nothing.
if [[ "$(ps -xU $(whoami) | grep -Ev "screen (.*) autodl-$suffix" | grep -Ecw "(autodl-$suffix$|irssi-$suffix/$)")" -ne '2' && -d "$HOME/.autodl-$suffix" && -d "$HOME/.irssi-$suffix" && ! -f "$HOME/.userdocs/tmp/autodl-$suffix.lock" ]]; then
    #
    # Create this file so that the cronjob will skipped if it is restarting the processes and attempts to run again.
    touch "$HOME/.userdocs/tmp/autodl-$suffix.lock"
    #
    # Kill the matching processes pid's and then kill command below will provide.
    kill -9 $(echo $(ps -xU $(whoami) | grep -Ew "(autodl-$suffix$|irssi-$suffix/$)" | awk '{print $1}')) > /dev/null 2>&1
    #
    # Wipe away dead matching screen processes so as not to provide false positives to the main check.
    screen -wipe > /dev/null 2>&1
    #
    # Create the new screen process in the background and then send it a command.
    screen -dmS "autodl-$suffix" && screen -S "autodl-$suffix" -p 0 -X stuff "irssi --home=$HOME/.irssi-$suffix/^M"
    #
    # Tell Autodl to update itself by sending a command to the matching screen process.
    screen -S "autodl-$suffix" -p 0 -X stuff '/autodl update^M'
    #
    # Echo the 2 pids of the running processes to a file ~/.userdocs/pids/autodl-SUFFIX.pid
    echo -n "$(echo $(ps -xU $(whoami) | grep -Ev 'screen (.*) autodl' | grep -Ew "(autodl-$suffix$|irssi-$suffix/$)" | awk '{print $1}'))" > "$HOME/.userdocs/pids/autodl-$suffix.pid"
    #
    # Echo the time and date this cronjob was run to the ~/.userdocs/cronjobs/logs/autodl-SUFFIX.log
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/autodl-$suffix.log" 2>&1
    #
    # Remove the lock file this cron job created so that the job can run again if required.
    [[ -f "$HOME/.userdocs/tmp/autodl-$suffix.lock" ]] && rm -f "$HOME/.userdocs/tmp/autodl-$suffix.lock"
    #
fi
#
##
### Part 2: A cron based auto-patcher for an installation of autodl to a custom instance using the userdocs script.
##
# Some checks to see what the current host settings are hard coded to in two files. If the program updated it will be set to 127.0.0.1 and we will patch it later otherwise it will be 10.0.0.1 and we will do nothing.
[[ -f "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm" ]] && autodlfix="$(sed -rn "s#(.*)'(.*)';#\2#p" $HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm)"
[[ -f "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" ]] && rutorrentfix="$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php)"
#
# Autodl host patch to change 127.0.0.1 to 10.0.0.1 if the previous checks return 127.0.0.1. Otherwise do nothing.
[[ "$autodlfix" = '127.0.0.1' ]] && sed -i "s|'127.0.0.1';|'10.0.0.1';|g" "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm" && updated="1"
#
# Autodl Rutorrent host patch to change 127.0.0.1 to 10.0.0.1 if the previous checks return 127.0.0.1. Otherwise do nothing.
[[ "$rutorrentfix" = '127.0.0.1' ]] && sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
#
# Check to see what the hard coded home directory is set to.
[[ -f "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm" ]] && autodlhome="$(sed -n 's#\(.*\)return File::Spec->catfile(getHomeDir(), "\(.*\)");#\2#p' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm")"
#
# This edit set the Autodl home directory, required for a non standard installation.
[[ "$autodlhome" == '.autodl' ]] && sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm" && updated="1"
#
# This edit sets the path to the autodl.cfg that the rutorrent plugin will use and edit, required for a non standard installation.
if [[ -f "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" ]]; then
    if [[ "$(cat "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php" | grep -wc "'/.autodl-$suffix/autodl.cfg'")" -eq "0" ]]; then
        sed -i "s|'/.autodl/autodl.cfg'|'/.autodl-$suffix/autodl.cfg'|g" "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
    fi
fi
#
# If Autodl is patched updated is set to 1. If it is 1 this command will send a reload command to the matching autodl screen so the patch takes effect and then reset this variable.
[[ "$updated" -eq "1" ]] && screen -S "autodl-$suffix" -p 0 -X stuff '/run autorun/autodl-irssi.pl^M' && updated="0"