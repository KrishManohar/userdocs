#!/usr/bin/env bash
#
appname=""
apppath=""
screencommand=""
#
# Lets make some required directories. This solution works best alongside these folders for tmp files, logs and more.
mkdir -p ~/.userdocs/{versions,cronjobs/logs,logins,logs,pids,tmp}
#
# If the readme is not present this will create a readme file for the ~/.userdocs directory so that someone can understand why this folder exists. Otherwise do nothing.
[[ ! -f ~/.userdocs/readme.txt ]] && echo 'This is a folder generated by the userdocs installation scripts that you may have used to house important information or components of the script.' > ~/.userdocs/readme.txt
#
# This check will see if $appname is running. If not then it will remove the cronjob lock file and kill and wipe all related screens.
if [[ "$(ps -xU $(whoami) | grep -Ecw "$apppath$")" -eq '0' ]]; then
    kill -9 $(ps -xU $(whoami) | grep -Ew "$apppath$" | awk '{print $1}') $(screen -ls | grep -Ew "$appname\s" | awk '{print $1}' | cut -d \. -f 1) > /dev/null 2>&1
    screen -wipe > /dev/null 2>&1
    rm -f "$HOME/.userdocs/tmp/$appname.lock"
fi
#
# The below if section is the restart job for your $appname installation. This will only manage the default installation.
#
# This is our check to see if the required processes is running. This match is very specific and will only match the default installation processes and not other instances. Otherwise do nothing.
if [[ "$(ps -xU $(whoami) | grep -Ecw "$apppath$")" -ne '1' && -d "$HOME/.$appname" && ! -f "$HOME/.userdocs/tmp/$appname.lock" ]]; then
    #
    # Create this file so that the cronjob will skipped if it is restarting the processes and attempts to run again.
    touch "$HOME/.userdocs/tmp/$appname.lock"
    #
    # Kill the matching processes pid's and then kill command below will provide.
    kill -9 $(ps -xU $(whoami) | grep -Ew "$apppath$" | awk '{print $1}') $(screen -ls | grep -Ew "$appname\s" | awk '{print $1}' | cut -d \. -f 1) > /dev/null 2>&1
    #
    # Wipe away dead matching screen processes so as not to provide false positives to the main check.
    screen -wipe > /dev/null 2>&1
    #
    # Create the new screen process in the background and then send it a command.
    screen -dmS "$appname" && screen -S "$appname" -p 0 -X stuff "export TMPDIR=$HOME/.userdocs/tmp; $screencommand^M"
    #
    # Echo the pids of the running processes to a file ~/.userdocs/pids/$appname.pid
    echo -n $(ps -xU $(whoami) | grep -Ew "$apppath$" | awk '{print $1}') $(screen -ls | grep -Ew "$appname\s" | awk '{print $1}' | cut -d \. -f 1) > "$HOME/.userdocs/pids/$appname.pid"
    #
    # Echo the time and date this cronjob was run to the ~/.userdocs/cronjobs/logs/$appname.log
    echo "Restarted at: $(date +"%H:%M on the %d.%m.%y")" >> "$HOME/.userdocs/cronjobs/logs/$appname.log" 2>&1
    #
    # Remove the lock file this cron job created so that the job can run again if required.
    [[ -f "$HOME/.userdocs/tmp/$appname.lock" ]] && rm -f "$HOME/.userdocs/tmp/$appname.lock"
    #
fi
#