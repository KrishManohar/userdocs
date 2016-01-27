#!/bin/bash
#
############################
##### Basic Info Start #####
############################
#
# Script Author: userdocs
#
# Script Contributors: 
#
# Bash Command for easy reference:
#
# wget -qO ~/install.monoapps https://git.io/vzyZ4 && bash ~/install.monoapps
#
# The GPLv3 License (GNU)
#
# Copyright (c) 2016 userdocs
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
############################
###### Basic Info End ######
############################
#
############################
#### Script Notes Start ####
############################
#
## See readme.md
#
############################
##### Script Notes End #####
############################
#
############################
## Version History Starts ##
############################
#
if [[ ! -z "$1" && "$1" = 'changelog' ]]
then
    echo
    #
    # put your version changes in the single quotes and then uncomment the line.
    #
    #echo 'v0.1.0 - My changes go here'
    #echo 'v0.0.9 - My changes go here'
    #echo 'v0.0.8 - My changes go here'
    #echo 'v0.0.7 - My changes go here'
    #echo 'v0.0.6 - My changes go here'
    #echo 'v0.0.5 - My changes go here'
    #echo 'v0.0.4 - My changes go here'
    #echo 'v0.0.3 - My changes go here'
    echo 'v0.0.2 - beta release'
    echo 'v0.0.1 - Updated templated'
    #
    echo
    exit
fi
#
############################
### Version History Ends ###
############################
#
############################
###### Variable Start ######
############################
#
# Script Version number is set here.
scriptversion="0.0.2"
#
# Script name goes here. Please prefix with install.
scriptname="install.monoapps"
#
# Author name goes here.
scriptauthor="userdocs"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="https://git.io/vzyZ4"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Mono/scripts/install.monoapps.sh"
#
# This will generate a 20 character random passsword for use with your applications.
apppass="$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)"
# This will generate a random port for the script between the range 10001 to 32001 to use with applications. You can ignore this unless needed.
appport="$(shuf -i 10001-32001 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(netstat -ln | grep ':'"$appport"'' | grep -c 'LISTEN')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
# Script user's http www URL in the format http://username.server.feralhosting.com/
# http="http://$(hostname -f)/$(whoami)/"
# Script user's https www url in the format https://server.feralhosting.com/username/
# https="https://$(hostname -f)/$(whoami)/"
#
# feralwww - sets the full path to the default public_html directory if it exists.
# [[ -d ~/www/"$(whoami)"."$(hostname -f)"/public_html ]] && feralwww="$HOME/www/$(whoami).$(hostname -f)/public_html/"
# rtorrentdata - sets the full path to the rtorrent data directory if it exists.
# [[ -d ~/private/rtorrent/data ]] && rtorrentdata="$HOME/private/rtorrent/data"
# delugedata - sets the full path to the deluge data directory if it exists.
# [[ -d ~/private/deluge/data ]] && delugedata="$HOME/private/deluge/data"
# transmissiondata - sets the full path to the transmission data directory if it exists.
# [[ -d ~/private/transmission/data ]] && transmissiondata="$HOME/private/transmission/data"
#
# Bug reporting variables.
gitissue="https://github.com/userdocs/userdocs/issues/new"
#
############################
## Custom Variables Start ##
############################
#
sqlite3url="https://www.sqlite.org/$(date +"%Y")/$(curl -s https://www.sqlite.org/download.html | egrep -om 1 'sqlite-autoconf-(.*).tar.gz')"
sqlite3v="$(curl -s https://www.sqlite.org/download.html | egrep -om 1 'sqlite-autoconf-(.*).tar.gz' | sed -rn 's/sqlite-autoconf-(.*).tar.gz/\1/p')"
#
libtoolurl="http://ftpmirror.gnu.org/libtool/$(curl -s http://ftp.heanet.ie/mirrors/gnu/libtool/ | egrep -o 'libtool-[^"]*\.tar.xz' | sort -V | tail -1)"
libtoolv="$(curl -s http://ftp.heanet.ie/mirrors/gnu/libtool/ | egrep -o 'libtool-[^"]*\.tar.xz' | sort -V | tail -1 | sed -rn 's/libtool-(.*).tar.xz/\1/p')"
#
monourl="http://download.mono-project.com/sources/mono/$(curl -s http://download.mono-project.com/sources/mono/ | egrep -o 'mono-[^"]*\.tar\.bz2' | tail -1)"
monovfull="$(curl -s http://download.mono-project.com/sources/mono/ | egrep -o 'mono-[^"]*\.tar\.bz2' | tail -1 | sed -rn 's/mono-(.*).tar.bz2/\1/p')"
monovshort="$(curl -s http://download.mono-project.com/sources/mono/ | egrep -o 'mono-[^"]*\.tar\.bz2' | tail -1 | sed -rn 's/mono-(.*).tar.bz2/\1/p' | awk -F'.' '{ print $1 "." $2 "." $3 }')"
#
sonarrurl="http://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz"
sonarrv="$(curl -s https://github.com/Sonarr/Sonarr/releases | grep -o '/Sonarr/Sonarr/archive/.*\.zip' | sort -V | tail -1 | sed -rn 's|/Sonarr/Sonarr/archive/v(.*).zip|\1|p')"
#
genericproxyapache="https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/proxypass/apache/generic.conf"
genericproxynginx="https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/proxypass/nginx/generic.conf"
#
embyurl="$(curl -sL https://api.github.com/repos/MediaBrowser/Emby/releases/latest | grep -P 'browser(.*)Emby.Mono.zip' | cut -d\" -f4)"
embyv="$(curl -sL https://api.github.com/repos/MediaBrowser/Emby/releases/latest | sed -rn 's/(.*)"tag_name": "(.*)",/\2/p')"
#
embyappporthttp="$(shuf -i 10001-32001 -n 1)"
while [[ "$(netstat -ln | grep ':'"$embyappporthttp"'' | grep -c 'LISTEN')" -ge "1" ]]; do embyappporthttp="$(shuf -i 10001-32001 -n 1)"; done
embyappporthttps="$(shuf -i 10001-32001 -n 1)"
while [[ "$(netstat -ln | grep ':'"$embyappporthttps"'' | grep -c 'LISTEN')" -ge "1" ]]; do embyappporthttps="$(shuf -i 10001-32001 -n 1)"; done
#
embyconfig="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Emby/configs/system.xml"
#
jacketturl="$(curl -sL https://api.github.com/repos/Jackett/Jackett/releases/latest | grep -P 'browser(.*)Jackett.Binaries.Mono.tar.gz' | cut -d\" -f4)"
jackettv="$(curl -sL https://api.github.com/repos/Jackett/Jackett/releases/latest | sed -rn 's/(.*)"tag_name": "v(.*)",/\2/p')"
#
############################
### Custom Variables End ###
############################
#
# Disables the built in script updater permanently by setting this variable to 0.
updaterenabled="1"
#
############################
####### Variable End #######
############################
#
############################
###### Function Start ######
############################
#
showMenu () {
    #
    echo "1) Install or update mono"
    echo "2) Install or update Sonarr"
    echo "3) Install or update Jackett"
    echo "4) Install or update Emby"
    echo "5) Exit"
    #
    echo
}
#
cronjobadd () {
    # adding jobs to cron: Set the variable tmpcron to a randomly generated temporary file.
    tmpcron="$(mktemp)"
    # Check if the job exists already by grepping whatever is between ^$
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/myjobname.cronjob$')" == "0" ]]
    then
        # sometimes the cronjob will be to run a custom script generated by the installer, located in the directory ~/.cronjobs
        mkdir -p ~/.userdocs/cronjobs/logs
        echo "Appending application to crontab."; echo
        crontab -l 2> /dev/null > "$tmpcron"
        echo '* * * * * bash -l ~/.userdocs/cronjobs/myjobname.cronjob' >> "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        echo "This cronjob is already in crontab"; echo
    fi
}
#
cronjobremove () {
    tmpcron="$(mktemp)"
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/myjobname.cronjob$')" == "1" ]]
    then
        crontab -l 2> /dev/null > "$tmpcron"
        sed -i '/^\* \* \* \* \* bash -l ~\/.cronjobs\/myjobname.cronjob$/d' "$tmpcron"
        sed -i '/^$/d' "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        :
    fi
}
#
prerequisites () {
    mkdir -p ~/bin
    mkdir -p ~/.userdocs/{versions,cronjobs,credentials,logs,pids}
    [[ $(echo "$PATH" | grep -oc ~/bin) -eq "0" ]] && export PATH=~/bin:"$PATH"
    echo 'This is a folder generated by the userdocs installation scripts that you may have used to house important infomration or components of the script.' > ~/.userdocs/readme.txt
}
#
libtoolsetup () {
    prerequisites
    #
    [[ -f ~/bin/libtool ]] && libtoolcheck1="ON" || libtoolcheck1="NO"
    [[ -f ~/.userdocs/versions/libtool.version ]] && libtoolcheck2="ON" || libtoolcheck2="NO"
    [[ "$(cat ~/.userdocs/versions/libtool.version 2> /dev/null)" = "$libtoolv" ]] && libtoolcheck3="ON" || libtoolcheck3="NO"
    #
    if [[ "$libtoolcheck1" != 'ON' || "$libtoolcheck2" != 'ON' || "$libtoolcheck3" != 'ON' ]]
    then
        echo "Installing libtool which is required by mono"; echo
        #
        wget -qO ~/libtool.tar.gz $libtoolurl
        tar xf ~/libtool.tar.gz && cd ~/libtool-$libtoolv
        ./configure --prefix=$HOME > ~/.userdocs/logs/libtool.log 2>&1
        make >> ~/.userdocs/logs/libtool.log 2>&1
        make install >> ~/.userdocs/logs/libtool.log 2>&1
        cd && rm -rf libtool{-$libtoolv,.tar.gz}
        #
        echo -n "$libtoolv" > ~/.userdocs/versions/libtool.version
    else
        echo "Libtool is already installed and the latest version."; echo
    fi
}
#
sqlite3setup () {
    prerequisites
    #
    [[ -f ~/bin/sqlite3 ]] && sqlite3check1="ON" || sqlite3check1="NO"
    [[ -f ~/.userdocs/versions/sqlite3.version ]] && sqlite3check2="ON" || sqlite3check2="NO"
    [[ "$(cat ~/.userdocs/versions/sqlite3.version 2> /dev/null)" = "$sqlite3v" ]] && sqlite3check3="ON" || sqlite3check3="NO"
    #
    if [[ "$sqlite3check1" != 'ON' || "$sqlite3check2" != 'ON' || "$sqlite3check3" != 'ON' ]]
    then
        echo "Installing Sqlite3 which is required by Emby"; echo
        wget -qO ~/sqlite.tar.gz "$sqlite3url"
        tar xf ~/sqlite.tar.gz
        cd ~/sqlite-autoconf-"$sqlite3v"
        ./configure --prefix=$HOME > ~/.userdocs/logs/sqlite3.log 2>&1
        make >> ~/.userdocs/logs/sqlite3.log 2>&1
        make install >> ~/.userdocs/logs/sqlite3.log 2>&1
        cd && rm -rf sqlite{-autoconf-"$sqlite3v",.tar.gz}
        echo -n "$sqlite3v" > ~/.userdocs/versions/sqlite3.version
    else
        echo "Sqlite3 is already installed and the latest version."; echo
    fi
}
#
proxypassgeneric () {
    if [[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]]
    then
        if [[ -f ~/.config/NzbDrone/config.xml ]]
        then
            wget -qO ~/.apache2/conf.d/"$appname".conf "$genericproxyapache"
            sed -i 's|generic|'"$appname"'|g' ~/.apache2/conf.d/"$appname".conf
            sed -i 's|PORT|'"$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' ~/.config/NzbDrone/config.xml)"'|g' ~/.apache2/conf.d/"$appname".conf
            /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
            echo "The Apache proxypass was updated"; echo
        else
            wget -qO ~/.apache2/conf.d/"$appname".conf "$genericproxyapache"
            sed -i 's|generic|'"$appname"'|g' ~/.apache2/conf.d/"$appname".conf
            sed -i 's|PORT|'"$appport"'|g' ~/.apache2/conf.d/"$appname".conf
            /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
            echo "The Apache proxypass was installed"; echo
        fi
        #
        if [[ -d ~/.nginx ]]
        then
            if [[ -f ~/.config/NzbDrone/config.xml ]]
            then
                wget -qO ~/.nginx/conf.d/000-default-server.d/"$appname".conf $genericproxynginx
                sed -i 's|generic|'"$appname"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                sed -i 's|username|'"$(whoami)"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                sed -i 's|PORT|'"$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' ~/.config/NzbDrone/config.xml)"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                echo "The nginx proxypass was updated"; echo
            else
                wget -qO ~/.nginx/conf.d/000-default-server.d/"$appname".conf $genericproxynginx
                sed -i 's|generic|'"$appname"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                sed -i 's|username|'"$(whoami)"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                sed -i 's|username|'"$(whoami)"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                sed -i 's|PORT|'"$appport"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
                /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                echo "The nginx proxypass was installed"; echo
            fi
        fi
    fi
}
#
sonarrhosturl () {
    if [[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]]
    then
        echo -e "https://$(hostname -f)/$(whoami)/sonarr/settings/general"; echo
    else
        if [[ -f ~/.config/NzbDrone/config.xml ]]
        then
            echo -e "http://$(hostname -f):$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' ~/.config/NzbDrone/config.xml)/$(whoami)/sonarr/settings/general"; echo
        else
            echo -e "http://$(hostname -f):$appport/$(whoami)/sonarr/settings/general"; echo
        fi
    fi    
}
#
sonarrrestart () {
    #
    kill -9 "$(screen -ls sonarr | sed -rn 's/[^\s](.*).sonarr(.*)/\1/p')" > /dev/null 2>&1
    #
    screen -wipe > /dev/null 2>&1
    #
    if [[ -z "$(screen -ls sonarr | sed -rn 's/[^\s](.*).sonarr(.*)/\1/p')" ]]
    then
        screen -dmS sonarr ~/bin/mono --debug ~/.sonarr/NzbDrone.exe
        echo "Sonarr was restarted"; echo
    fi
    #
}
#
embyexportenv () {
    [[ $(echo "$LD_LIBRARY_PATH" | grep -oc ~/lib) -eq "0" ]] && export LD_LIBRARY_PATH=~/lib:"$LD_LIBRARY_PATH"
    [[ $(echo "$PKG_CONFIG_PATH" | grep -oc ~/lib/pkgconfig) -eq "0" ]] && export PKG_CONFIG_PATH=~/lib/pkgconfig:"$PKG_CONFIG_PATH"
    [[ $(cat ~/.bashrc | grep -oc 'export LD_LIBRARY_PATH=~/lib:$LD_LIBRARY_PATH') -eq "0" ]] && echo 'export LD_LIBRARY_PATH=~/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
    [[ $(cat ~/.bashrc | grep -oc 'export PKG_CONFIG_PATH=~/lib/pkgconfig:$PKG_CONFIG_PATH') -eq "0" ]] && echo 'export PKG_CONFIG_PATH=~/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
}
#
############################
####### Function End #######
############################
#
############################
#### Script Help Starts ####
############################
#
if [[ ! -z "$1" && "$1" = 'help' ]]
then
    echo
    echo -e "\033[32m""Script help and usage instructions:""\e[0m"
    echo
    #
    ###################################
    ##### Custom Help Info Starts #####
    ###################################
    #
    echo -e "Put your help instructions or script guidance here"
    #
    ###################################
    ###### Custom Help Info Ends ######
    ###################################
    #
    echo
    exit
fi
#
############################
##### Script Help Ends #####
############################
#
############################
#### Script Info Starts ####
############################
#
# Use this to show a user script information when they use the info option with the script.
if [[ ! -z "$1" && "$1" = 'info' ]]
then
    echo
    echo -e "\033[32m""Script Details:""\e[0m"
    echo
    echo -e "Script version: $scriptversion"
    echo
    echo -e "Script Author: $scriptauthor"
    echo
    echo -e "Script Contributors: $contributors"
    echo
    echo -e "\033[32m""Script options:""\e[0m"
    echo
    echo -e "\033[36mhelp\e[0m = See the help section for this script."
    echo
    echo -e "Example usage: \033[36m$scriptname help\e[0m"
    echo
    echo -e "\033[36mchangelog\e[0m = See the version history and change log of this script."
    echo
    echo -e "Example usage: \033[36m$scriptname changelog\e[0m"
    echo
    echo -e "\033[36minfo\e[0m = Show the script information and usage instructions."
    echo
    echo -e "Example usage: \033[36m$scriptname info\e[0m"
    echo
    echo -e "\033[31mImportant note:\e[0m Options \033[36mqr\e[0m and \033[36mnu\e[0m are interchangeable and usable together."
    echo
    echo -e "For example: \033[36m$scriptname qr nu\e[0m or \033[36m$scriptname nu qr\e[0m will both work"
    echo
    echo -e "\033[36mqr\e[0m = Quick Run - use this to bypass the default update prompts and run the main script directly."
    echo
    echo -e "Example usage: \033[36m$scriptname qr\e[0m"
    echo
    echo -e "\033[36mnu\e[0m = No Update - disable the built in updater. Useful for testing new features or debugging."
    echo
    echo -e "Example usage: \033[36m$scriptname nu\e[0m"
    echo
    echo -e "\033[32mBash Commands:\e[0m"
    echo
    echo -e "\033[36m""$gitiocommand""\e[0m"
    echo
    echo -e "\033[36m""~/bin/$scriptname""\e[0m"
    echo
    echo -e "\033[36m""$scriptname""\e[0m"
    echo
    echo -e "\033[32m""Bug Reporting:""\e[0m"
    echo
    echo -e "You should create an issue directly on github using your github account."
    echo
    echo -e "\033[36m""$gitissue""\e[0m"
    echo
    echo -e "\033[33m""All bug reports are welcomed and very much appreciated, as they benefit all users.""\033[32m"
    #
    echo
    exit
fi
#
############################
##### Script Info Ends #####
############################
#
############################
#### Self Updater Start ####
############################
#
# Checks for the positional parameters $1 and $2 to be reset if the script is updated.
[[ ! -z "$1" && "$1" != 'qr' ]] || [[ ! -z "$2" && "$2" != 'qr' ]] && echo -en "$1\n$2" > ~/.passparams
# Quick Run option part 1: If qr is used it will create this file. Then if the script also updates, which would reset the option, it will then find this file and set it back.
[[ ! -z "$1" && "$1" = 'qr' ]] || [[ ! -z "$2" && "$2" = 'qr' ]] && echo -n '' > ~/.quickrun
# No Update option: This disables the updater features if the script option "nu" was used when running the script.
if [[ ! -z "$1" && "$1" = 'nu' ]] || [[ ! -z "$2" && "$2" = 'nu' ]]; then
    scriptversion="$scriptversion-nu"
    echo -e "\nThe Updater has been temporarily disabled\n"
else
    # Check to see if the variable "updaterenabled" is set to 1. If it is set to 0 the script will bypass the built in updater regardless of the options used.
    if [[ "$updaterenabled" -eq "1" ]]; then
        [[ ! -d ~/bin ]] && mkdir -p ~/bin
        [[ ! -f ~/bin/"$scriptname" ]] && wget -qO ~/bin/"$scriptname" "$scripturl"
        wget -qO ~/.000"$scriptname" "$scripturl"
        if [[ "$(sha256sum ~/.000"$scriptname" | awk '{print $1}')" != "$(sha256sum ~/bin/"$scriptname" | awk '{print $1}')" ]]; then
            echo -e "#!/bin/bash\nwget -qO ~/bin/$scriptname $scripturl\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.111"$scriptname" && bash ~/.111"$scriptname"; exit
        else
            if [[ -z "$(pgrep -fu "$(whoami)" "bash $HOME/bin/$scriptname")" && "$(pgrep -fu "$(whoami)" "bash $HOME/bin/$scriptname")" -ne "$$" ]]; then
                echo -e "#!/bin/bash\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.222"$scriptname" && bash ~/.222"$scriptname"; exit
            fi
        fi
        cd && rm -f .{000,111,222}"$scriptname" && chmod -f 700 ~/bin/"$scriptname"
        echo
    else
        scriptversion="$scriptversion-DEV"
        echo -e "\nThe Updater has been disabled\n"
    fi
fi
# Quick Run option part 2: If quick run was set and the updater section completes this will enable quick run again then remove the file.
[[ -f ~/.quickrun ]] && updatestatus="y"; rm -f ~/.quickrun
# resets the positional parameters $1 and $2 post update.
[[ -f ~/.passparams ]] && set "$1" "$(sed -n '1p' ~/.passparams)" && set "$2" "$(sed -n '2p' ~/.passparams)"; rm -f ~/.passparams
#
############################
##### Self Updater End #####
############################
#
############################
## Positional Param Start ##
############################
#
if [[ ! -z "$1" && "$1" = "example" ]]
then
    echo
    #
    # Edit below this line
    #
    echo "Add your custom positional parameters in this section."
    #
    if [[ -n "$2" ]]
    then
        echo "You used $scriptname $1 $2 when calling this example"
    fi
    #
    # Edit above this line
    #
    echo
    exit
fi
#
############################
### Positional Param End ###
############################
#
############################
#### Core Script Starts ####
############################
#
if [[ "$updatestatus" = "y" ]]
then
    :
else
    echo -e "Hello $(whoami), you have the latest version of the" "\033[36m""$scriptname""\e[0m" "script. This script version is:" "\033[31m""$scriptversion""\e[0m"
    echo
    read -ep "The script has been updated, enter [y] to continue or [q] to exit: " -i "y" updatestatus
    echo
fi
#
if [[ "$updatestatus" =~ ^[Yy]$ ]]
then
#
############################
#### User Script Starts ####
############################
#
while [ 1 ]
do
    showMenu
    read -e CHOICE
    echo
    case "$CHOICE" in
        "1")
            prerequisites
            #
            libtoolsetup
            #
            [[ -f ~/bin/mono ]] && monocheck1="ON" || monocheck1="NO"
            [[ -f ~/.userdocs/versions/mono.version ]] && monocheck2="ON" || monocheck2="NO"
            [[ "$(cat ~/.userdocs/versions/mono.version 2> /dev/null)" = "$monovfull" ]] && monocheck3="ON" || monocheck3="NO"
            #
            if [[ "$monocheck1" != 'ON' || "$monocheck2" != 'ON' || "$monocheck3" != 'ON' ]] 
            then
                echo "Installing mono. This will take a long time. Put the kettle on."; echo
                #
                wget -qO ~/mono.tar.bz2 "$monourl"
                tar xf ~/mono.tar.bz2 && cd ~/mono-"$monovshort"
                ./autogen.sh --prefix="$HOME" > ~/.userdocs/logs/mono.log 2>&1
                make get-monolite-latest >> ~/.userdocs/logs/mono.log 2>&1
                make >> ~/.userdocs/logs/mono.log 2>&1 && make install >> ~/.userdocs/logs/mono.log 2>&1
                cd && rm -rf mono{-"$monovshort",.tar.gz}
                #
                echo -n "$monovfull" > ~/.userdocs/versions/mono.version
            else
                echo "Mono is already and installed and the latest version"; echo
                exit
            fi
            ;;
        "2")
            prerequisites
            #
            appname="sonarr"
            #
            [[ -f ~/.sonarr/NzbDrone.exe ]] && sonarrcheck1="ON" || sonarrcheck1="NO"
            [[ -f ~/.userdocs/versions/sonarr.version ]] && sonarrcheck2="ON" || sonarrcheck2="NO"
            [[ "$(cat ~/.userdocs/versions/sonarr.version 2> /dev/null)" = "$sonarrv" ]] && sonarrcheck3="ON" || sonarrcheck3="NO"
            #
            if [[ "$sonarrcheck1" != 'ON' || "$sonarrcheck2" != 'ON' || "$sonarrcheck3" != 'ON' ]] 
            then
                [[ -f ~/.sonarr/NzbDrone.exe ]] && echo "Updating Sonarr"; echo || echo "Installing Sonarr"; echo
                #
                wget -qO ~/NzbDrone.tar.gz "$sonarrurl" > ~/.userdocs/logs/sonarr.log 2>&1
                tar xf ~/NzbDrone.tar.gz >> ~/.userdocs/logs/sonarr.log 2>&1
                cp -rf ~/NzbDrone ~/.sonarr >> ~/.userdocs/logs/sonarr.log 2>&1
                rm -rf NzbDrone{,.tar.gz} >> ~/.userdocs/logs/sonarr.log 2>&1
                #
                if [[ ! -f ~/.config/NzbDrone/config.xml ]]
                then
                    mkdir -p ~/.config/NzbDrone >> ~/.userdocs/logs/sonarr.log 2>&1
                    wget -qO ~/.config/NzbDrone/config.xml http://git.io/vcCvh >> ~/.userdocs/logs/sonarr.log 2>&1
                    sed -i 's|<Port>8989</Port>|<Port>'"$appport"'</Port>|g' ~/.config/NzbDrone/config.xml >> ~/.userdocs/logs/sonarr.log 2>&1
                    sed -i 's|<UrlBase></UrlBase>|<UrlBase>/'"$(whoami)"'/sonarr</UrlBase>|g' ~/.config/NzbDrone/config.xml >> ~/.userdocs/logs/sonarr.log 2>&1
                fi
                #
                proxypasssonarr
                #
                sonarrrestart
                #
                sonarrhosturl
                #
                echo -n "$sonarrv" > ~/.userdocs/versions/sonarr.version
            else
                [[ -f ~/.config/NzbDrone/config.xml ]] && proxypasssonarr
                #
                sonarrrestart
                #
                [[ -f ~/.config/NzbDrone/config.xml ]] && sonarrhosturl
                #
                echo "Sonarr is already and installed and the latest version"; echo
                exit
            fi
            ;;
        "3")
            prerequisites
            #
            appname="jackett"
            ;;
        "4")
            prerequisites
            #
            sqlite3setup
            #
            appname="emby"
            #
            [[ -f ~/.emby/MediaBrowser.Server.Mono.exe ]] && embycheck1="ON" || embycheck1="NO"
            [[ -f ~/.userdocs/versions/emby.version ]] && embycheck2="ON" || embycheck2="NO"
            [[ "$(cat ~/.userdocs/versions/emby.version 2> /dev/null)" = "$embyv" ]] && embycheck3="ON" || embycheck3="NO"
            #
            if [[ "$embycheck1" != 'ON' || "$embycheck2" != 'ON' || "$embycheck3" != 'ON' ]] 
            then
                echo "Installing emby"; echo
                mkdir -p ~/.emby/ProgramData-Server/config
                wget -qO ~/.emby/ProgramData-Server/config/system.xml "$embyconfig"
                #
                sed -i 's|<PublicPort>8096</PublicPort>|<PublicPort>'"$embyappporthttp"'</PublicPort>|g' ~/.emby/ProgramData-Server/config/system.xml
                sed -i 's|<PublicHttpsPort>8920</PublicHttpsPort>|<PublicHttpsPort>'"$embyappporthttps"'</PublicHttpsPort>|g' ~/.emby/ProgramData-Server/config/system.xml
                sed -i 's|<HttpServerPortNumber>8096</HttpServerPortNumber>|<HttpServerPortNumber>'"$embyappporthttp"'</HttpServerPortNumber>|g' ~/.emby/ProgramData-Server/config/system.xml
                sed -i 's|<HttpsPortNumber>8920</HttpsPortNumber>|<HttpsPortNumber>'"$embyappporthttps"'</HttpsPortNumber>|g' ~/.emby/ProgramData-Server/config/system.xml
                #
                wget -qO ~/emby.zip $embyurl
                unzip -qo ~/emby.zip -d ~/.emby
                rm -f ~/emby.zip
                #
                embyexportenv
                #
                echo "http:/$(whoami).$(hostname -f):$embyappporthttp"; echo
                #
                echo -n "$embyv" > ~/.userdocs/versions/emby.version
                #
                screen -dmS emby ~/bin/mono ~/.emby/MediaBrowser.Server.Mono.exe
            else
                echo "Emby is already and installed and the latest version"; echo
                exit
            fi
            ;;
        "4")
            echo "You chose to quit the script."
            echo
            exit
            ;;
    esac
done
#
############################
##### User Script End  #####
############################
#
else
    echo -e "You chose to exit after updating the scripts."
    echo
    cd && bash
    exit
fi
#
############################
##### Core Script Ends #####
############################
#
