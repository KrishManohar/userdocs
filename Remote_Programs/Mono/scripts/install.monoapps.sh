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
    echo 'v1.0.3 - Radarr added - pre release - script tweaks'
    echo 'v1.0.1 - i think i fixed something'
    echo 'v1.0.0 - a functional install/updater/removal script for mono/sonarr/jackett/emby on feral and whatbox with proxypass where applicable'
    echo 'v0.0.7 - beta 2 feature complete release and functional on both feral and whatbox'
    echo 'v0.0.5 - beta release'
    echo 'v0.0.2 - alpha release'
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
scriptversion="1.0.3"
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
# This will take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
[[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]] && while [[ "$(netstat -ln | grep ':'"$appport"'' | grep -c 'LISTEN')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
appname=""
#
# Bug reporting variables.
gitissue="https://github.com/userdocs/userdocs/issues/new"
#
############################
## Custom Variables Start ##
############################
#
cmakeurl="https://cmake.org/files/v3.7/cmake-3.7.0-Linux-x86_64.tar.gz"
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
genericproxyapache="https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/proxypass/apache/generic.conf"
genericproxynginx="https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/proxypass/nginx/generic.conf"
#
sonarrurl="http://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz"
sonarrv="$(curl -s https://github.com/Sonarr/Sonarr/releases | grep -o '/Sonarr/Sonarr/archive/.*\.zip' | sort -V | tail -1 | sed -rn 's|/Sonarr/Sonarr/archive/v(.*).zip|\1|p')"
sonarrconfig="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Sonarr/configs/config.xml"
#
radarrurl="https://github.com/Radarr/Radarr/releases/download/v0.2.0.654/Radarr.develop.0.2.0.654.linux.tar.gz"
radarrv="$(curl -s https://github.com/Radarr/Radarr/releases | grep -o '/Radarr/Radarr/archive/.*\.zip' | sort -V | tail -1 | sed -rn 's|/Radarr/Radarr/archive/v(.*).zip|\1|p')"
radarrconfig="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Radarr/configs/config.xml"
#
jacketturl="$(curl -sL https://api.github.com/repos/Jackett/Jackett/releases/latest | grep -P 'browser(.*)Jackett.Binaries.Mono.tar.gz' | cut -d\" -f4)"
jackettv="$(curl -sL https://api.github.com/repos/Jackett/Jackett/releases/latest | sed -rn 's/(.*)"tag_name": "v(.*)",/\2/p')"
jacketconfig="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Jackett/configs/ServerConfig.json"
jackettappport="$(shuf -i 10001-32001 -n 1)"
[[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]] && while [[ "$(netstat -ln | grep ':'"$jackettappport"'' | grep -c 'LISTEN')" -ge "1" ]]; do jackettappport="$(shuf -i 10001-32001 -n 1)"; done
#
embyurl="$(curl -sL https://api.github.com/repos/MediaBrowser/Emby/releases/latest | grep -P 'browser(.*)Emby.Mono.zip' | cut -d\" -f4)"
embyv="$(curl -sL https://api.github.com/repos/MediaBrowser/Emby/releases/latest | sed -rn 's/(.*)"tag_name": "(.*)",/\2/p')"
embyconfig="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Emby/configs/system.xml"
embyappporthttp="$(shuf -i 10001-32001 -n 1)"
[[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]] && while [[ "$(netstat -ln | grep ':'"$embyappporthttp"'' | grep -c 'LISTEN')" -ge "1" ]]; do embyappporthttp="$(shuf -i 10001-32001 -n 1)"; done
embyappporthttps="$(shuf -i 10001-32001 -n 1)"
[[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]] && while [[ "$(netstat -ln | grep ':'"$embyappporthttps"'' | grep -c 'LISTEN')" -ge "1" ]]; do embyappporthttps="$(shuf -i 10001-32001 -n 1)"; done
#
############################
### Custom Variables End ###
############################
#
# Disables the built in script updater permanently by setting this variable to 0.
updaterenabled="0"
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
    echo "3) Install or update Radarr"
    echo "4) Install or update Jackett"
    echo "5) Install or update Emby"
    echo "6) Exit"
    #
    echo
}
#
cronjobadd () {
    # adding jobs to cron: Set the variable tmpcron to a randomly generated temporary file.
    tmpcron="$(mktemp)"
    # Check if the job exists already by grepping whatever is between ^$
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/'"$appname"'.cronjob >> ~/.userdocs/cronjobs/logs/'"$appname"'.log$')" == "0" ]]
    then
        # sometimes the cronjob will be to run a custom script generated by the installer, located in the directory ~/.cronjobs
        mkdir -p ~/.userdocs/cronjobs/logs
        echo "Appending ${appname^} to crontab."
        crontab -l 2> /dev/null > "$tmpcron"
        echo '* * * * * bash -l ~/.userdocs/cronjobs/'"$appname"'.cronjob >> ~/.userdocs/cronjobs/logs/'"$appname"'.log' >> "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        echo "The ${appname^} cronjob is already in crontab"
    fi
}
#
cronjobremove () {
    tmpcron="$(mktemp)"
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/'"$appname"'.cronjob >> ~/.userdocs/cronjobs/logs/'"$appname"'.log$')" == "1" ]]
    then
        crontab -l 2> /dev/null > "$tmpcron"
        sed -i '/^\* \* \* \* \* bash -l ~\/.userdocs\/cronjobs\/'"$appname"'.cronjob >> ~\/.userdocs\/cronjobs\/logs\/'"$appname"'.log$/d' "$tmpcron"
        sed -i '/^$/d' "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        :
    fi
}
#
cronscript () {
    wget -qO ~/.userdocs/cronjobs/"$appname".cronjob "https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/Bash_Scripts/cronscript.sh"
    #
    [[ "$appname" = "sonarr" ]] && sed -i 's|APPNAME|'"$appname"'|g' ~/.userdocs/cronjobs/$appname.cronjob
    [[ "$appname" = "radarr" ]] && sed -i 's|APPNAME|'"$appname"'|g' ~/.userdocs/cronjobs/$appname.cronjob
    [[ "$appname" = "jackett"  ]] && sed -i 's|APPNAME|'"$appname"'|g' ~/.userdocs/cronjobs/$appname.cronjob
    [[ "$appname" = "emby" ]] && sed -i 's|APPNAME|'"$appname"'|g' ~/.userdocs/cronjobs/$appname.cronjob
    #
    [[ "$appname" = "sonarr" ]] && sed -i 's|PATH|~/.sonarr/NzbDrone.exe|g' ~/.userdocs/cronjobs/$appname.cronjob
    [[ "$appname" = "radarr" ]] && sed -i 's|PATH|~/.radarr/Radarr.exe|g' ~/.userdocs/cronjobs/$appname.cronjob
    [[ "$appname" = "jackett"  ]] && sed -i 's|PATH|~/.jackett/JackettConsole.exe|g' ~/.userdocs/cronjobs/$appname.cronjob
    [[ "$appname" = "emby" ]] && sed -i 's|PATH|~/.emby/MediaBrowser.Server.Mono.exe|g' ~/.userdocs/cronjobs/$appname.cronjob
    #
}
prerequisites () {
    mkdir -p ~/bin
    mkdir -p ~/.userdocs/{versions,cronjobs,logins,logs,pids,tmp}
    [[ $(echo "$PATH" | grep -oc ~/bin) -eq "0" ]] && export PATH=~/bin:"$PATH"
    echo 'This is a folder generated by the userdocs installation scripts that you may have used to house important information or components of the script.' > ~/.userdocs/readme.txt
}
#
libtoolsetup () {
    #
    prerequisites
    #
    if [[ ! -z $(which libtool 2> /dev/null) ]]
    then
        echo "Libtool is already installed and the latest version."; echo
    else
        [[ -f ~/bin/libtool ]] && libtoolcheck1="ON" || libtoolcheck1="NO"
        [[ -f ~/.userdocs/versions/libtool.version ]] && libtoolcheck2="ON" || libtoolcheck2="NO"
        [[ "$(cat ~/.userdocs/versions/libtool.version 2> /dev/null)" = "$libtoolv" ]] && libtoolcheck3="ON" || libtoolcheck3="NO"
        #
        if [[ "$libtoolcheck1" != 'ON' || "$libtoolcheck2" != 'ON' || "$libtoolcheck3" != 'ON' ]]
        then
            echo "Installing libtool which is required by mono"; echo
            #
            wget -qO ~/.userdocs/tmp/libtool.tar.gz $libtoolurl
            tar xf ~/.userdocs/tmp/libtool.tar.gz -C ~/.userdocs/tmp && cd ~/.userdocs/tmp/libtool-$libtoolv
            ./configure --prefix=$HOME > ~/.userdocs/logs/libtool.install.log 2>&1
            make >> ~/.userdocs/logs/libtool.install.log 2>&1
            make install >> ~/.userdocs/logs/libtool.install.log 2>&1
            cd && rm -rf ~/.userdocs/tmp/libtool{-$libtoolv,.tar.gz}
            #
            echo -n "$libtoolv" > ~/.userdocs/versions/libtool.version
        else
            echo "Libtool is already installed and the latest version."; echo
        fi
    fi
}
#
sqlite3setup () {
    #
    prerequisites
    #
    if [[ ! -z $(which sqlite3 2> /dev/null) ]]
    then
        echo "Libtool is already installed and the latest version."; echo
    else
        [[ -f ~/bin/sqlite3 ]] && sqlite3check1="ON" || sqlite3check1="NO"
        [[ -f ~/.userdocs/versions/sqlite3.version ]] && sqlite3check2="ON" || sqlite3check2="NO"
        [[ "$(cat ~/.userdocs/versions/sqlite3.version 2> /dev/null)" = "$sqlite3v" ]] && sqlite3check3="ON" || sqlite3check3="NO"
        #
        if [[ "$sqlite3check1" != 'ON' || "$sqlite3check2" != 'ON' || "$sqlite3check3" != 'ON' ]]
        then
            echo "Installing Sqlite3 which is required by Emby"
            wget -qO ~/.userdocs/tmp/sqlite.tar.gz "$sqlite3url"
            tar xf ~/.userdocs/tmp/sqlite.tar.gz -C ~/.userdocs/tmp/
            cd ~/.userdocs/tmp/sqlite-autoconf-"$sqlite3v"
            ./configure --prefix=$HOME > ~/.userdocs/logs/sqlite3.install.log 2>&1
            make >> ~/.userdocs/logs/sqlite3.install.log 2>&1
            make install >> ~/.userdocs/logs/sqlite3.install.log 2>&1
            cd && rm -rf ~/.userdocs/tmp/sqlite{-autoconf-"$sqlite3v",.tar.gz}
            #
            echo -n "$sqlite3v" > ~/.userdocs/versions/sqlite3.version
        else
            echo "Sqlite3 is already installed and the latest version."
        fi
    fi
}
#
programpaths () {
    [[ "$appname" = "sonarr" ]] && apppaths="$HOME/.config/NzbDrone/config.xml"
    [[ "$appname" = "radarr" ]] && apppaths="$HOME/.config/Radarr/config.xml"
    [[ "$appname" = "jackett" ]] && apppaths="$HOME/.config/Jackett/ServerConfig.json"
    [[ "$appname" = "emby" ]] && apppaths="$HOME/.emby/ProgramData-Server/config/system.xml"
}
#
genericproxypass () {
    if [[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]]
    then
        wget -qO ~/.apache2/conf.d/$appname.conf "$genericproxyapache"
        sed -i "s|generic|$appname|g" ~/.apache2/conf.d/$appname.conf
        #
        [[ "$appname" = "sonarr" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' $apppaths)"'|g' ~/.apache2/conf.d/$appname.conf
        [[ "$appname" = "radarr" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' $apppaths)"'|g' ~/.apache2/conf.d/$appname.conf
        [[ "$appname" = "jackett" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)"Port": (.*),|\2|p' $apppaths)"'|g' ~/.apache2/conf.d/$appname.conf
        [[ "$appname" = "emby" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)<PublicPort>(.*)</PublicPort>|\2|p' $apppaths)"'|g' ~/.apache2/conf.d/$appname.conf
        #
        [[ "$appname" = "sonarr" && ! -f "$apppaths" ]] && proxyport="$appport"; sed -i 's|PORT|'"$proxyport"'|g' ~/.apache2/conf.d/$appname.conf
        [[ "$appname" = "radarr" && ! -f "$apppaths" ]] && proxyport="$appport"; sed -i 's|PORT|'"$proxyport"'|g' ~/.apache2/conf.d/$appname.conf
        [[ "$appname" = "jackett" && ! -f "$apppaths" ]] && proxyport="$jackettappport"; sed -i 's|PORT|'"$proxyport"'|g' ~/.apache2/conf.d/$appname.conf
        [[ "$appname" = "emby" && ! -f "$apppaths" ]] && proxyport="$embyappporthttp"; sed -i 's|PORT|'"$proxyport"'|g' ~/.apache2/conf.d/$appname.conf
        #
        /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
        echo "The Apache proxypass was installed"; echo
        #
        if [[ -d ~/.nginx ]]
        then
            wget -qO ~/.nginx/conf.d/000-default-server.d/"$appname".conf "$genericproxynginx"
            #
            [[ "$appname" = "sonarr" ]] && sed -i 's|rewrite /generic/(.*) /$1 break;|rewrite /(.*) /username/$1 break;|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "radarr" ]] && sed -i 's|rewrite /generic/(.*) /$1 break;|rewrite /(.*) /username/$1 break;|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            #
            sed -i 's|generic|'"$appname"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            sed -i 's|username|'"$(whoami)"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            #
            [[ "$appname" = "sonarr" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' $apppaths)"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "radarr" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' $apppaths)"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "jackett" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)"Port": (.*),|\2|p' $apppaths)"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "emby" && -f "$apppaths" ]] && sed -i 's|PORT|'"$(sed -rn 's|(.*)<PublicPort>(.*)</PublicPort>|\2|p' $apppaths)"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            #
            [[ "$appname" = "sonarr" && ! -f "$apppaths" ]] && proxyport="$appport"; sed -i 's|PORT|'"$proxyport"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "radarr" && ! -f "$apppaths" ]] && proxyport="$appport"; sed -i 's|PORT|'"$proxyport"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "jackett" && ! -f "$apppaths" ]] && proxyport="$jackettappport"; sed -i 's|PORT|'"$proxyport"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            [[ "$appname" = "emby" && ! -f "$apppaths" ]] && proxyport="$embyappporthttp"; sed -i 's|PORT|'"$proxyport"'|g' ~/.nginx/conf.d/000-default-server.d/$appname.conf
            #
            /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
            echo "The nginx proxypass was installed"; echo
        fi
    fi
}
#
generichosturl () {
    if [[ $(hostname -f | egrep -co ^.*\.feralhosting\.com) -eq "1" ]]
    then
        [[ "$appname" = "sonarr" && -f "$apppaths" ]] && echo -e "\033[32m""https://$(hostname -f)/$(whoami)/$appname/settings/general""\e[0m"
        [[ "$appname" = "radarr" && -f "$apppaths" ]] && echo -e "\033[32m""https://$(hostname -f)/$(whoami)/$appname/settings/general""\e[0m"
        [[ "$appname" = "jackett" && -f "$apppaths" ]] && echo -e "\033[32m""https://$(hostname -f)/$(whoami)/$appname/""\e[0m"
        [[ "$appname" = "emby" && -f "$apppaths" ]] && echo -e "\033[32m""https://$(hostname -f)/$(whoami)/$appname/""\e[0m"
    else
        [[ "$appname" = "sonarr" && -f "$apppaths" ]] && echo -e "\033[32m""http://$(hostname -f):$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' $apppaths)/$(whoami)/$appname/settings/general""\e[0m"
        [[ "$appname" = "radarr" && -f "$apppaths" ]] && echo -e "\033[32m""http://$(hostname -f):$(sed -rn 's|(.*)<Port>(.*)</Port>|\2|p' $apppaths)/$(whoami)/$appname/settings/general""\e[0m"
        [[ "$appname" = "jackett" && -f "$apppaths" ]] && echo -e "\033[32m""http://$(hostname -f):$(sed -rn 's|(.*)"Port": (.*),|\2|p' $apppaths)/$(whoami)/$appname/admin/dashboard""\e[0m"
        [[ "$appname" = "emby" && -f "$apppaths" ]] && echo -e "\033[32m""http://$(hostname -f):$(sed -rn 's|(.*)<PublicPort>(.*)</PublicPort>|\2|p' $apppaths)/""\e[0m"
    fi    
}
#
genericrestart () {
    #
    kill -9 "$(screen -ls $appname | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p')" > /dev/null 2>&1
    #
    screen -wipe > /dev/null 2>&1
    #
    if [[ -z "$(screen -ls $appname | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p')" ]]
    then
        [[ "$appname" = "sonarr" ]] && screen -dmS $appname ~/bin/mono --debug ~/.$appname/NzbDrone.exe
        [[ "$appname" = "radarr" ]] && screen -dmS $appname ~/bin/mono --debug ~/.$appname/Radarr.exe
        [[ "$appname" = "jackett" ]] && screen -dmS $appname ~/bin/mono --debug ~/.$appname/JackettConsole.exe
        [[ "$appname" = "emby" ]] && screen -dmS $appname ~/bin/mono --debug ~/.$appname/MediaBrowser.Server.Mono.exe
        echo "${appname^} was restarted"
    fi
}
#
genericremove () {
    #
    read -ep "Would you like to remove $appname completely? " -i "n" makeitso
    echo
    if [[ "$makeitso" =~ ^[Yy]$ ]]
    then
        kill -9 "$(screen -ls $appname | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p')" > /dev/null 2>&1
        #
        screen -wipe > /dev/null 2>&1
        #
        if [[ "$appname" = "sonarr" ]]
        then
            rm -rf ~/."$appname" 
            rm -rf ~/.config/NzbDrone
            rm -rf ~/.userdocs/versions/"$appname".version
            rm -rf ~/.userdocs/cronjobs/"$appname".cronjob
            rm -rf ~/.userdocs/logins/"$appname".login
            rm -rf ~/.userdocs/pids/"$appname".pids
            rm -rf ~/.userdocs/logs/$appname.log
            #
            rm -rf ~/.apache2/conf.d/"$appname".conf
            rm -rf ~/.nginx/conf.d/000-default-server.d/"$appname".conf
        fi
        if [[ "$appname" = "radarr" ]]
        then
            rm -rf ~/."$appname" 
            rm -rf ~/.config/${appname^}
            rm -rf ~/.userdocs/versions/$appname.version
            rm -rf ~/.userdocs/cronjobs/$appname.cronjob
            rm -rf ~/.userdocs/logins/$appname.login
            rm -rf ~/.userdocs/pids/$appname.pids
            rm -rf ~/.userdocs/logs/$appname.log
            #
            rm -rf ~/.apache2/conf.d/$appname.conf
            rm -rf ~/.nginx/conf.d/000-default-server.d/$appname.conf
        fi
        if [[ "$appname" = "jackett" ]]
        then
            rm -rf ~/."$appname"
            rm -rf ~/.config/Jackett
            rm -rf ~/.userdocs/versions/"$appname".version
            rm -rf ~/.userdocs/cronjobs/"$appname".cronjob
            rm -rf ~/.userdocs/logins/"$appname".login
            rm -rf ~/.userdocs/pids/"$appname".pids
            rm -rf ~/.userdocs/logs/$appname.log
            #
            rm -rf ~/.apache2/conf.d/"$appname".conf
            rm -rf ~/.nginx/conf.d/000-default-server.d/"$appname".conf
        fi
        if [[ "$appname" = "emby" ]]
        then
            rm -rf ~/."$appname"
            #
            rm -rf ~/.userdocs/versions/"$appname".version
            rm -rf ~/.userdocs/cronjobs/"$appname".cronjob
            rm -rf ~/.userdocs/logins/"$appname".login
            rm -rf ~/.userdocs/pids/"$appname".pids
            rm -rf ~/.userdocs/logs/$appname.log
            #
            sed -i '/^export PATH=~\/bin:$PATH$/d' ~/.bashrc
            sed -i '/^export LD_LIBRARY_PATH=~\/lib:$LD_LIBRARY_PATH$/d' ~/.bashrc
            sed -i '/^export PKG_CONFIG_PATH=~\/lib\/pkgconfig:$PKG_CONFIG_PATH$/d' ~/.bashrc
            #
            rm -rf ~/.apache2/conf.d/"$appname".conf
            rm -rf ~/.nginx/conf.d/000-default-server.d/"$appname".conf
        fi
        #
        cronjobremove
        #
        echo "${appname^} was completely removed."
    else
        echo "Nothing was removed"
    fi
}
# These environment variables are required by emby to run.
embyexportenv () {
    #
    [[ $(echo "$PATH" | grep -oc ~/bin) -eq "0" ]] && export PATH=~/bin:"$PATH"
    [[ $(echo "$LD_LIBRARY_PATH" | grep -oc ~/lib) -eq "0" ]] && export LD_LIBRARY_PATH=~/lib:"$LD_LIBRARY_PATH"
    [[ $(echo "$PKG_CONFIG_PATH" | grep -oc ~/lib/pkgconfig) -eq "0" ]] && export PKG_CONFIG_PATH=~/lib/pkgconfig:"$PKG_CONFIG_PATH"
    #
    [[ $(cat ~/.bashrc | grep -oc 'export PATH=~/bin:$PATH') -eq "0" ]] && echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
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
                wget -qO ~/.userdocs/tmp/cmake.tar.gz "$cmakeurl" ~/.userdocs/logs/cmake.download.log 2>&1
                tar xf ~/.userdocs/tmp/cmake.tar.gz --strip-components=1 -C ~/
                rm -rf ~/.userdocs/tmp/cmake.tar.gz
                #
                wget -qO ~/.userdocs/tmp/mono.tar.bz2 "$monourl" ~/.userdocs/logs/mono.download.log 2>&1
                tar xf ~/.userdocs/tmp/mono.tar.bz2 -C ~/.userdocs/tmp && cd ~/.userdocs/tmp/mono-"$monovshort"
                ./autogen.sh --prefix="$HOME" > ~/.userdocs/logs/mono.install.log 2>&1
                make get-monolite-latest >> ~/.userdocs/logs/mono.install.log 2>&1
                make >> ~/.userdocs/logs/mono.log 2>&1 && make install >> ~/.userdocs/logs/mono.install.log 2>&1
                rm -rf ~/.userdocs/tmp/mono{-*,.tar.bz2}
                #
                echo -n "$monovfull" > ~/.userdocs/versions/mono.version
            else
                echo "Mono is already and installed and the latest version"; echo
            fi
            ;;
        "2")
            prerequisites
            #
            appname="sonarr"
            #
            programpaths
            #
            [[ -f ~/.$appname/NzbDrone.exe ]] && sonarrcheck1="ON" || sonarrcheck1="NO"
            [[ -f ~/.userdocs/versions/$appname.version ]] && sonarrcheck2="ON" || sonarrcheck2="NO"
            [[ "$(cat ~/.userdocs/versions/$appname.version 2> /dev/null)" = "$sonarrv" ]] && sonarrcheck3="ON" || sonarrcheck3="NO"
            #
            if [[ "$sonarrcheck1" != 'ON' || "$sonarrcheck2" != 'ON' || "$sonarrcheck3" != 'ON' ]] 
            then
                [[ -f ~/.$appname/NzbDrone.exe ]] && echo "Updating ${appname^}"; echo || echo "Installing ${appname^}"
                #
                wget -qO ~/.userdocs/tmp/NzbDrone.tar.gz "$sonarrurl"
                tar xf ~/.userdocs/tmp/NzbDrone.tar.gz -C ~/.userdocs/tmp/
                cp -rf ~/.userdocs/tmp/NzbDrone/. ~/.$appname
                rm -rf ~/.userdocs/tmp/NzbDrone{,.tar.gz}
                #
                if [[ ! -f "$apppaths" ]]
                then
                    mkdir -p ~/.config/NzbDrone >> ~/.userdocs/logs/$appname.log 2>&1
                    wget -qO "$apppaths" "$sonarrconfig"
                    sed -i 's|<Port>8989</Port>|<Port>'"$appport"'</Port>|g' "$apppaths"
                    sed -i 's|<UrlBase></UrlBase>|<UrlBase>/'"$(whoami)"'/'"$appname"'</UrlBase>|g' "$apppaths"
                fi
                #
                cronjobadd
                echo
                #
                cronscript
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo -n "$sonarrv" > ~/.userdocs/versions/$appname.version
                #
                sleep 2
            else
                #
                cronjobadd
                #
                cronscript
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo "Sonarr is already and installed and the latest version"; echo
                #
                genericremove
                echo
                #
                sleep 2
            fi
            ;;
        "3")
            prerequisites
            #
            appname="radarr"
            #
            programpaths
            #
            [[ -f ~/.$appname/${appname^}.exe ]] && radarrcheck1="ON" || radarrcheck1="NO"
            [[ -f ~/.userdocs/versions/$appname.version ]] && radarrcheck2="ON" || radarrcheck2="NO"
            [[ "$(cat ~/.userdocs/versions/$appname.version 2> /dev/null)" = "$radarrv" ]] && radarrcheck3="ON" || radarrcheck3="NO"
            #
            if [[ "$radarrcheck1" != 'ON' || "$radarrcheck2" != 'ON' || "$radarrcheck3" != 'ON' ]] 
            then
                [[ -f ~/.$appname/${appname^}.exe ]] && echo "Updating ${appname^}"; echo || echo "Installing ${appname^}"
                #
                wget -qO ~/.userdocs/tmp/${appname^}.tar.gz "$radarrurl"
                tar xf ~/.userdocs/tmp/${appname^}.tar.gz -C ~/.userdocs/tmp/
                cp -rf ~/.userdocs/tmp/${appname^}/. ~/.$appname
                rm -rf ~/.userdocs/tmp/${appname^}{,.tar.gz}
                #
                if [[ ! -f "$apppaths" ]]
                then
                    mkdir -p ~/.config/${appname^} >> ~/.userdocs/logs/$appname.log 2>&1
                    wget -qO "$apppaths" "$radarrconfig"
                    sed -i 's|<Port>7878</Port>|<Port>'"$appport"'</Port>|g' "$apppaths"
                    sed -i 's|<UrlBase></UrlBase>|<UrlBase>/'"$(whoami)"'/'"$appname"'</UrlBase>|g' "$apppaths"
                fi
                #
                cronjobadd
                echo
                #
                cronscript
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo -n "$radarrv" > ~/.userdocs/versions/$appname.version
                #
                sleep 2
            else
                #
                cronjobadd
                #
                cronscript
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo "${appname^} is already and installed and the latest version"; echo
                #
                genericremove
                echo
                #
                sleep 2
            fi
            ;;
        "4")
            prerequisites
            #
            appname="jackett"
            #
            programpaths
            #
            [[ -f ~/.jackett/JackettConsole.exe ]] && jackettcheck1="ON" || jackettcheck1="NO"
            [[ -f ~/.userdocs/versions/jackett.version ]] && jackettcheck2="ON" || jackettcheck2="NO"
            [[ "$(cat ~/.userdocs/versions/jackett.version 2> /dev/null)" = "$jackettv" ]] && jackettcheck3="ON" || jackettcheck3="NO"
            #
            if [[ "$jackettcheck1" != 'ON' || "$jackettcheck2" != 'ON' || "$jackettcheck3" != 'ON' ]]
            then
                [[ -f ~/.config/Jackett/ServerConfig.json ]] && echo "Updating Jackett"; echo || echo "Installing Jackett"
                #
                mkdir -p ~/.jackett
                wget -qO ~/.userdocs/tmp/jackett.tar.gz "$jacketturl"
                tar xf ~/.userdocs/tmp/jackett.tar.gz -C ~/.userdocs/tmp
                cp -rf ~/.userdocs/tmp/Jackett/. ~/.jackett
                rm -rf ~/.userdocs/tmp/Jackett 
                rm -f ~/.userdocs/tmp/jackett.tar.gz
                #
                if [[ ! -f ~/.config/Jackett/ServerConfig.json ]]
                then
                    mkdir -p ~/.config/Jackett
                    wget -qO ~/.config/Jackett/ServerConfig.json "$jacketconfig"
                    sed -i 's|"Port": PORT,|"Port": '"$jackettappport"',|g' ~/.config/Jackett/ServerConfig.json
                    sed -i 's|"BasePathOverride": PATH|"BasePathOverride": "/'"$(whoami)"'/jackett/"|g' ~/.config/Jackett/ServerConfig.json
                fi
                #
                cronjobadd
                #
                cronscript
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo -n "$jackettv" > ~/.userdocs/versions/jackett.version
                #
                sleep 2
            else
                #
                cronjobadd
                #
                cronscript
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo "Jackett is already and installed and the latest version"; echo
                #
                genericremove
                echo
                #
                sleep 2
            fi
            ;;
        "5")
            prerequisites
            #
            sqlite3setup
            #
            appname="emby"
            #
            programpaths
            #
            [[ -f ~/.emby/MediaBrowser.Server.Mono.exe ]] && embycheck1="ON" || embycheck1="NO"
            [[ -f ~/.userdocs/versions/emby.version ]] && embycheck2="ON" || embycheck2="NO"
            [[ "$(cat ~/.userdocs/versions/emby.version 2> /dev/null)" = "$embyv" ]] && embycheck3="ON" || embycheck3="NO"
            #
            if [[ "$embycheck1" != 'ON' || "$embycheck2" != 'ON' || "$embycheck3" != 'ON' ]] 
            then
                [[ -f ~/.emby/ProgramData-Server/config/system.xml ]] && echo "Updating Emby"; echo || echo "Installing Emby"
                #
                wget -qO ~/.userdocs/tmp/emby.zip $embyurl
                unzip -qo ~/.userdocs/tmp/emby.zip -d ~/.emby
                rm -f ~/.userdocs/tmp/emby.zip
                #
                if [[ ! -f ~/.emby/ProgramData-Server/config/system.xml ]]
                then
                    mkdir -p ~/.emby/ProgramData-Server/config
                    wget -qO ~/.emby/ProgramData-Server/config/system.xml "$embyconfig"
                    sed -i 's|<PublicPort>8096</PublicPort>|<PublicPort>'"$embyappporthttp"'</PublicPort>|g' ~/.emby/ProgramData-Server/config/system.xml
                    sed -i 's|<PublicHttpsPort>8920</PublicHttpsPort>|<PublicHttpsPort>'"$embyappporthttps"'</PublicHttpsPort>|g' ~/.emby/ProgramData-Server/config/system.xml
                    sed -i 's|<HttpServerPortNumber>8096</HttpServerPortNumber>|<HttpServerPortNumber>'"$embyappporthttp"'</HttpServerPortNumber>|g' ~/.emby/ProgramData-Server/config/system.xml
                    sed -i 's|<HttpsPortNumber>8920</HttpsPortNumber>|<HttpsPortNumber>'"$embyappporthttps"'</HttpsPortNumber>|g' ~/.emby/ProgramData-Server/config/system.xml
                fi
                #
                cronjobadd
                #
                cronscript
                #
                embyexportenv
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo -n "$embyv" > ~/.userdocs/versions/emby.version
                #
                sleep 2
            else
                #
                cronjobadd
                #
                cronscript
                #
                embyexportenv
                #
                genericproxypass
                #
                genericrestart
                echo
                #
                generichosturl
                echo
                #
                echo "Emby is already and installed and the latest version"; echo
                #
                genericremove
                echo
                #
                sleep 2
            fi
            ;;
        "6")
            echo "You chose to quit the script."
            echo
            #
            sleep 2
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
