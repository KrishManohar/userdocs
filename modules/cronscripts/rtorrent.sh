#!/usr/bin/env bash
#
# Install command: curl -sL https://git.io/vxyKo --create-dir -o ~/.userdocs/cronjobs/rtorrent.cronjob
#
# Crontab command: * * * * * bash -l ~/.userdocs/cronjobs/rtorrent.cronjob >> ~/.userdocs/cronjobs/logs/rtorrent.log 2>&1
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
#### Part 1: A cron based restarter for the default instance of rtorrent installed via the manager and or Autodl installed via the Feral Wiki.
###
## The below if section is the restart job for your default rtorrent installation. This will only manage the default installation.
#
# This is our check to see if the 3 required processes ares running. This match is very specific and will only match the default installation processes and not other instances. Otherwise do nothing.
if [[ "$(ps -xU $(whoami) | grep -Ev 'screen (.*) rtorrent' | grep -Ecw "rtorrent$")" -ne '3' && -d "$HOME/private/rtorrent" && ! -f "$HOME/.userdocs/tmp/rtorrent.lock" ]]; then
    #
    # Create this file so that the cronjob will skipped if it is restarting the processes and attempts to run again.
    touch "$HOME/.userdocs/tmp/rtorrent.lock"
    #
    # Kill the matching processes pid's and then kill command below will provide.
    kill -9 $(echo $(ps -xU $(whoami) | grep -Ew "rtorrent$" | awk '{print $1}')) > /dev/null 2>&1
    #
    # Wipe away dead matching screen processes so as not to provide false positives to the main check.
    screen -wipe > /dev/null 2>&1
    #
    # Remove the rtorrent lock file if present since we know the required processes are not running and this file only will prevent a restart.
    [[ -f "$HOME/private/rtorrent/work/rtorrent.lock" ]] && rm -f "$HOME/private/rtorrent/work/rtorrent.lock"
    #
    # Create the new screen process in the background and then send it a command.
    screen -dmS "rtorrent" && screen -S "rtorrent" -p 0 -X stuff "rtorrent^M"
    #
    # Echo the 3 pids of the running processes to a file ~/.userdocs/pids/rtorrent.pid
    echo -n "$(echo $(ps -xU $(whoami) | grep -Ev 'screen (.*) rtorrent' | grep -Ew "rtorrent$" | awk '{print $1}'))" > "$HOME/.userdocs/pids/rtorrent.pid"
    #
    # Echo the time and date this cronjob was run to the ~/.userdocs/cronjobs/logs/rtorrent.log
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/rtorrent.log" 2>&1
    #
    # Remove the lock file this cron job created so that the job can run again if required.
    [[ -f "$HOME/.userdocs/tmp/rtorrent.lock" ]] && rm -f "$HOME/.userdocs/tmp/rtorrent.lock"
    #
fi
#
### The restart job for your autodl installation. This will only manage the default installation.
##
# This is our check to see if the 3 required processes ares running. This match is very specific and will only match the default installation processes and not other instances. Otherwise do nothing.
if [[ "$(ps -xU $(whoami) | grep -Ev 'screen (.*) autodl' | grep -Ecw '(autodl$|irssi$)')" -ne '2' && -d "$HOME/.autodl" && -d "$HOME/.irssi" && ! -f "$HOME/.userdocs/tmp/autodl.lock" ]]; then
    #
    # Create this file so that the cronjob will skipped if it is restarting the processes and attempts to run again.
    touch "$HOME/.userdocs/tmp/autodl.lock"
    #
    # Kill the matching processes pid's and then kill command below will provide.
    kill -9 $(echo $(ps -xU $(whoami) | grep -Ew "(autodl$|irssi$)" | awk '{print $1}')) > /dev/null 2>&1
    #
    # Wipe away dead matching screen processes so as not to provide false positives to the main check.
    screen -wipe > /dev/null 2>&1
    #
    # Create the new screen process in the background and then send it a command.
    screen -dmS "autodl" && screen -S "autodl" -p 0 -X stuff "irssi^M"
    #
    # Tell Autodl to update itself by sending a command to the matching screen process.
    screen -S "autodl" -p 0 -X stuff '/autodl update^M'
    #
    # Echo the 2 pids of the running processes to a file ~/.userdocs/pids/rtorrent.pid
    echo -n "$(echo $(ps -xU $(whoami) | grep -Ev 'screen (.*) autodl' | grep -Ew '(autodl$|irssi$)' | awk '{print $1}'))" > "$HOME/.userdocs/pids/autodl.pid"
    #
    # Echo the time and date this cronjob was run to the ~/.userdocs/cronjobs/logs/rtorrent.log
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/autodl.log" 2>&1
    #
    # Remove the lock file this cron job created so that the job can run again if required.
    [[ -f "$HOME/.userdocs/tmp/autodl.lock" ]] && rm -f "$HOME/.userdocs/tmp/autodl.lock"
    #
fi
#
### Part 2: A cron based auto-patcher for the default installation of autodl.
##
# Some checks to see what the current host settings are hard coded to in two files. If the program updated it will be set to 127.0.0.1 and we will patch it later otherwise it will be 10.0.0.1 and we will do nothing.
[[ -f "$HOME/.irssi/scripts/AutodlIrssi/GuiServer.pm" ]] && autodlfix="$(sed -rn "s#(.*)'(.*)';#\2#p" $HOME/.irssi/scripts/AutodlIrssi/GuiServer.pm)"
[[ -f "$wwwurl/rutorrent/plugins/autodl-irssi/getConf.php" ]] && rutorrentfix="$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $wwwurl/rutorrent/plugins/autodl-irssi/getConf.php)"
#
# Autodl host patch to change 127.0.0.1 to 10.0.0.1 if the previous checks return 127.0.0.1. Otherwise do nothing.
[[ "$autodlfix" = '127.0.0.1' ]] && sed -i "s|'127.0.0.1';|'10.0.0.1';|g" "$HOME/.irssi/scripts/AutodlIrssi/GuiServer.pm" && updated="1"
#
# Autodl Rutorrent host patch to change 127.0.0.1 to 10.0.0.1 if the previous checks return 127.0.0.1. Otherwise do nothing.
[[ "$rutorrentfix" = '127.0.0.1' ]] && sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent/plugins/autodl-irssi/getConf.php"
#
# If Autodl is patched updated is set to 1. If it is 1 this command will send a reload command to the matching autodl screen so the patch takes effect.
[[ "$updated" -eq "1" ]] && screen -S "autodl" -p 0 -X stuff '/run autorun/autodl-irssi.pl^M' && updated="0"
#
exit
