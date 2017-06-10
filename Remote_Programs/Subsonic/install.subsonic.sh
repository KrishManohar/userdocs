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
# wget -qO ~/install.subsonic https://git.io/v1J6i && bash ~/install.subsonic
#
# The GPLv3 License (GNU)
#
# Copyright (c) 2017 userdocs
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
    echo 'v2.6.3 - script parity'
    echo 'v2.6.1 - bug fixes and small tweaks. No more rsk script as the method has been replaced with the template built in method.'
    echo 'v2.6.0 - script and template updated to fall inline with userdocs template method.'
    echo 'v2.5.0 - Rework of template so that manual script editing and updating is becoming obselete in regards to program updates'
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
scriptversion="2.6.3"
#
# Script name goes here. Please prefix with install.
scriptname="install.subsonic"
#
# Author name goes here.
scriptauthor="userdocs"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="https://git.io/v1J6i"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Subsonic/install.subsonic.sh"
#
# This will generate a 20 character random passsword for use with your applications.
apppass="$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)"
# This will generate a random port for the script between the range 10001 to 32001 to use with applications. You can ignore this unless needed.
appport="$(shuf -i 10001-32001 -n 1)"
#
# This will take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(netstat -ln | grep ':'"$appport"'' | grep -c 'LISTEN')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
# Bug reporting variables.
gitissue="https://github.com/userdocs/userdocs/issues/new"
#
############################
## Custom Variables Start ##
############################
#
# The current version of $appname can be set here and will be used in the rest of the script.
appversion="6.1.1"
#
# This variable must be set and in lowercase. It will define multiple values in the scipt such as installation paths, filenames and be used to configure files.
appname="subsonic"
#
# This is the command that will be used to start the program and used in the cron scripts. It just needs to be the basic start command for the app.
startcommand="~/.$appname/$appname.sh"
#
# This command will check to see if $appname is installed and use the configured port instead of q random port.
[[ -f "$HOME/.$appname/$appname.sh" ]] && appport="$(cat "$HOME/.$appname/$appname.sh" | sed -rn 's/SUBSONIC_PORT=\$\{SUBSONIC_PORT:-(.*)\}/\1/p')"
#
# This variable is set to one if the nginx proxypass requires a socket, for example this is used with flood.
# socketpath=""
#
# These variables are for getting the most recent version of java creating the required urls and version numbers for the script.
getversion="$(curl -Ls http://java.com/en/download/linux_manual.jsp | sed -rn 's/(.*)>Recommended Version (.*) Update (.*)<(.*)/\2/p')"
getupdate="$(curl -Ls http://java.com/en/download/linux_manual.jsp | sed -rn 's/(.*)>Recommended Version (.*) Update (.*)<(.*)/\3/p')"
javaversion="The Latest Java available is $getversion Update $getupdate"
javadecimal="1.$getversion.0_$getupdate"
javaupdateurl="$(curl -Ls http://java.com/en/download/linux_manual.jsp | egrep -om 1 '<a title="Download Java software for Linux x64" href="http://javadl\.oracle\.com/webapps/download/AutoDL\?BundleId=(.*)" ' | sed -rn 's/(.*)href="(.*)"(.*)/\2/p')"
# currentjavaversion="$(java -version 2>&1 | sed -rn 's/(.*)"(.*)"(.*)/\2/p')"
installedjavaversion="$(cat ~/.userdocs/versions/java.version 2> /dev/null)"
#
# Defines the memory variable
maxmemory="4096"
#
# These variables are for getting the $appname standalone files and creating the version echo.
appnamefv="https://s3-eu-west-1.amazonaws.com/subsonic-public/download/subsonic-$appversion-standalone.tar.gz"
appnamefvs="$appname $appversion"
# hese variables are for getting the ffmpeg files and creating the version echo.
sffmpegfv="http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz"
sffmpegfvs="ffmpeg-release-64bit-static.tar.xz"
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
## Custom Functions Start ##
############################
#
function_installjava () {
    if [[ ! -f ~/bin/java && -f ~/.userdocs/versions/java.version ]]
    then
        rm -f ~/.javaversion ~/.userdocs/.javaversion ~/.userdocs/versions/java.version
        export installedjavaversion=""
    fi
    if [[ "$installedjavaversion" != "$javadecimal" ]]
    then
        echo "Please wait a moment while java is installed"; echo
        wget -qO ~/.userdocs/tmp/java.tar.gz "$javaupdateurl"
        tar xf ~/.userdocs/tmp/java.tar.gz --strip-components=1 -C ~/
        rm -rf ~/.userdocs/tmp/java.tar.gz
        echo "$javadecimal" > ~/.userdocs/versions/java.version
        rm -f ~/{Welcome.html,THIRDPARTYLICENSEREADME-JAVAFX.txt,THIRDPARTYLICENSEREADME.txt,release,README,LICENSE,COPYRIGHT}
        echo -e "\033[31m""Important:""\e[0m" "Java" "\033[32m""$javadecimal""\e[0m" "has been installed to" "\033[36m""$HOME/bin""\e[0m"
        echo
    fi
}
#
function_installapp () {
    echo -n "$appversion" > ~/.userdocs/versions/"$appname".version
    mkdir -p ~/."$appname"/{transcode,playlists,Podcasts}
    #
    echo -e "\033[32m""$appnamefvs""\e[0m" "is downloading and installing now."; echo
    #
    wget -qO ~/.userdocs/tmp/"$appname".tar.gz "$appnamefv"
    tar xf ~/.userdocs/tmp/"$appname".tar.gz -C ~/."$appname"
    # transcoding files
    wget -qO ~/.userdocs/tmp/ffmpeg.tar.gz "$sffmpegfv"
    tar xf ~/.userdocs/tmp/ffmpeg.tar.gz --strip-components=1 -C ~/."$appname"/transcode/
    chmod -f 700 ~/."$appname"/transcode/{Audioffmpeg,ffmpeg,lame,xmp}
    rm -rf ~/.userdocs/tmp/"$appname".tar.gz
    rm -rf ~/.userdocs/tmp/ffmpeg.tar.gz
    cp -f /usr/bin/lame ~/."$appname"/transcode/ 2> /dev/null
    chmod -f 700 ~/."$appname"/transcode/lame
    cp -f /usr/bin/flac ~/."$appname"/transcode/ 2> /dev/null
    chmod -f 700 ~/."$appname"/transcode/flac
}
#
function_editapp () {
    wget -qO "$HOME/.$appname/$appname.sh" https://git.io/vHDE4
    #
    echo -e "\033[31m""Configuring the start-up script.""\e[0m"; echo
    #
    sed -i 's|SUBSONIC_PORT=${SUBSONIC_PORT:-4040}|SUBSONIC_PORT=${SUBSONIC_PORT:-'$appport'}|g' "$HOME/.$appname/$appname.sh"
    #
    echo -e "\033[35m""User input is required for this next step:""\e[0m"
    #
    echo -e "\033[33m""Note on user input:""\e[0m" "It is OK to use a relative path like:" "\033[33m""~/private/rtorrent/data""\e[0m"
    #
    read -ep "Enter the path to your media or leave blank and press enter to skip: " -i "~/private/rtorrent/data" path
    echo
    #
    sed -i 's|SUBSONIC_DEFAULT_MUSIC_FOLDER=${SUBSONIC_DEFAULT_MUSIC_FOLDER:-/var/music}|SUBSONIC_DEFAULT_MUSIC_FOLDER=${SUBSONIC_DEFAULT_MUSIC_FOLDER:-'"$path"'}|g' "$HOME/.$appname/$appname.sh"
}
#
function_updateapp () {
    while [[ -n $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') ]]
    do
        kill -9 $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') > /dev/null 2>&1
        rm -f "$HOME/.userdocs/pids/$appname.pid"
        #
        screen -wipe > /dev/null 2>&1
    done
    #
    echo -n "$appversion" > ~/.userdocs/versions/"$appname".version
    mkdir -p ~/."$appname"/{transcode,playlists,Podcasts}
    #                                                     
    echo -e "\033[32m""$appnamefvs""\e[0m" "is downloading and updating now."; echo
    #
    mkdir -p ~/.userdocs/tmp/"$appname"
    wget -qO ~/.userdocs/tmp/"$appname".tar.gz "$appnamefv"
    tar xf ~/.userdocs/tmp/"$appname".tar.gz -C ~/.userdocs/tmp/"$appname"
    rm -f ~/.userdocs/tmp/"$appname"/"$appname".sh
    cp -rf ~/.userdocs/tmp/"$appname"/. ~/."$appname"/
    # transcoding files
    wget -qO ~/.userdocs/tmp/ffmpeg.tar.gz "$sffmpegfv"
    tar xf ~/.userdocs/tmp/ffmpeg.tar.gz --strip-components=1 -C ~/."$appname"/transcode/
    chmod -f 700 ~/."$appname"/transcode/{Audioffmpeg,ffmpeg,lame,xmp}
    rm -rf ~/.userdocs/tmp/"$appname"{,.tar.gz}
    rm -rf ~/.userdocs/tmp/ffmpeg.tar.gz
    cp -f /usr/bin/lame ~/."$appname"/transcode/ 2> /dev/null
    chmod -f 700 ~/."$appname"/transcode/lame
    cp -f /usr/bin/flac ~/."$appname"/transcode/ 2> /dev/null
    chmod -f 700 ~/."$appname"/transcode/flac
    #
    screen -dmS "$appname" && screen -S "$appname" -p 0 -X stuff "export TMPDIR=~/.userdocs/tmp; $startcommand^M"
    echo -n $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') > "$HOME/.userdocs/pids/$appname.pid"
    echo "${appname^} was restarted"; echo
    function_generichosturl
}
#
############################
### Custom Functions End ###
############################
#
############################
## Generic Function Start ##
############################
#
function_prerequisites () {
    mkdir -p ~/bin
    mkdir -p ~/.userdocs/{versions,cronjobs,logins,logs,pids,tmp}
    #
    [[ $(echo "$PATH" | grep -oc ~/bin) -eq "0" ]] && export PATH=~/bin:"$PATH"
	[[ $(echo "$TMPDIR" | grep -oc ~/.userdocs/tmp) -eq "0" ]] && export TMPDIR=~/.userdocs/tmp
    #
    echo 'This is a folder generated by the userdocs installation scripts that you may have used to house important information or components of the script.' > ~/.userdocs/readme.txt
}
#
function_cronjobadd () {
    tmpcron="$(mktemp)"
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/'"$appname"'.cronjob >> ~/.userdocs/cronjobs/logs/'"$appname"'.log 2>&1$')" == "0" ]]
    then
        mkdir -p ~/.userdocs/cronjobs/logs
        echo "Appending ${appname^} to crontab."; echo
        crontab -l 2> /dev/null > "$tmpcron"
        echo '* * * * * bash -l ~/.userdocs/cronjobs/'"$appname"'.cronjob >> ~/.userdocs/cronjobs/logs/'"$appname"'.log 2>&1' >> "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        echo "The ${appname^} cronjob is already in crontab"; echo
    fi
    #
    rm -f ~/.userdocs/cronjobs/"$appname".cronjob
    wget -qO ~/.userdocs/cronjobs/"$appname".cronjob "https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/Bash_Scripts/cronscript.sh"
	sed -i 's|# screen command|screen -dmS '"$appname"' \&\& screen -S '"$appname"' -p 0 -X stuff "export TMPDIR=~/.userdocs/tmp; '"$startcommand"'^M"|g' ~/.userdocs/cronjobs/"$appname".cronjob
	sed -i 's|APPNAME|'"$appname"'|g' ~/.userdocs/cronjobs/"$appname".cronjob
}
#
function_cronjobremove () {
    tmpcron="$(mktemp)"
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/'"$appname"'.cronjob >> ~/.userdocs/cronjobs/logs/'"$appname"'.log 2>&1$')" == "1" ]]
    then
        crontab -l 2> /dev/null > "$tmpcron"
        sed -i '/^\* \* \* \* \* bash -l ~\/.userdocs\/cronjobs\/'"$appname"'.cronjob >> ~\/.userdocs\/cronjobs\/logs\/'"$appname"'.log 2>&1$/d' "$tmpcron"
        sed -i '/^$/d' "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        :
    fi
}
#
function_generichosturl () {
    echo -e "${appname^} is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/$appname/""\e[0m"; echo
    echo "It may take a few minutes to load. Refresh the page to see the app."; echo
}
#
function_genericproxypass () {
    #
	genericproxyapache="https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/proxypass/apache/generic.conf"
	genericproxynginx="https://raw.githubusercontent.com/userdocs/userdocs/master/0_templates/proxypass/nginx/generic.conf"
	# If the proxypass requires a socket.
	socket="0"
	if [[ -d ~/.nginx ]]
	then
        mkdir -p ~/.nginx/proxy
		wget -qO ~/.nginx/conf.d/000-default-server.d/"$appname".conf "$genericproxynginx"
        #
        if [[ "$appname" =~ ^(subsonic|sonarr|radarr|madsonic)$ ]]
        then
            sed -i 's|# rewrite /(.*) /username/$1 break;|rewrite /(.*) /username/$1 break;|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
        else
            sed -i 's|# rewrite /generic/(.*) /$1 break;|rewrite /generic/(.*) /$1 break;|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
        fi
        #
        sed -i 's|HOME|'"$HOME"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
		sed -i 's|generic|'"$appname"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
		sed -i 's|username|'"$(whoami)"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
		sed -i 's|PORT|'"$appport"'|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
        #
		#
		if [[ "$socket" -eq "1" ]]
		then
			sed -i 's|# include   /etc/nginx/scgi_params;|include   /etc/nginx/scgi_params;|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
			sed -i 's|# scgi_pass unix://SOCKETPATH;|scgi_pass unix://'"$socketpath"';|g' ~/.nginx/conf.d/000-default-server.d/"$appname".conf
		fi
		#
		/usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
		echo "The nginx proxypass was installed"
		echo
	fi
    #
    wget -qO ~/.apache2/conf.d/"$appname".conf "$genericproxyapache"
    sed -i "s|generic|$appname|g" ~/.apache2/conf.d/"$appname".conf
    sed -i 's|PORT|'"$appport"'|g' ~/.apache2/conf.d/"$appname".conf
    #
    /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
    echo "The Apache proxypass was installed"; echo
    #
}
#
function_genericrestart () {
    while [[ -n $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') ]]
    do
        kill -9 $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') > /dev/null 2>&1
        rm -f "$HOME/.userdocs/pids/$appname.pid"
        #
        screen -wipe > /dev/null 2>&1
    done
    #
    if [[ -d "$HOME/.$appname" && ! -f "$HOME/.userdocs/tmp/$appname.lock" ]]
    then
        if [[ -z "$(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p')" ]]
        then
            screen -dmS "$appname" && screen -S "$appname" -p 0 -X stuff "export TMPDIR=~/.userdocs/tmp; $startcommand^M"
            echo -n $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') > "$HOME/.userdocs/pids/$appname.pid"
            echo "${appname^} was restarted"
            echo
        fi
    fi
}
#
function_genericremove () {
    #
    read -ep "Would you like to remove $appname completely? " -i "y" makeitso
    echo
    if [[ "$makeitso" =~ ^[Yy]$ ]]
    then
        while [[ -n $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') ]]
        do
            kill -9 $(screen -ls "$appname" | sed -rn 's/[^\s](.*).'"$appname"'(.*)/\1/p') > /dev/null 2>&1
            rm -f "$HOME/.userdocs/pids/$appname.pid"
            #
            screen -wipe > /dev/null 2>&1
        done
        #
		sleep 5
        #
		rm -rf "$HOME/.$appname"
		rm -rf ~/.userdocs/versions/"$appname".version
		rm -rf ~/.userdocs/cronjobs/"$appname".cronjob
		rm -rf ~/.userdocs/logins/"$appname".login
		rm -rf ~/.userdocs/pids/"$appname".pid
		rm -rf ~/.userdocs/logs/"$appname".log
        rm -rf ~/.userdocs/tmp/"$appname".lock
		#
		rm -rf "$HOME/.nginx/conf.d/000-default-server.d/$appname.conf"
		/usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
        rm -rf "$HOME/.apache2/conf.d/$appname.conf"
        /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
        #
        echo "${appname^} was completely removed."
		echo
		sleep 2
		rm -rf "$HOME/.$appname"
    else
        echo "Nothing was removed"
		echo
		sleep 2
    fi
}
#
############################
### Generic Function End ###
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
### Prerequisites Starts ###
############################
#
function_prerequisites
function_installjava
#
############################
#### Prerequisites Ends ####
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
    echo -e "The version of the" "\033[33m""${appname^}""\e[0m" "server being used in this script is:" "\033[31m""$appversion""\e[0m"
    echo -e "The version of the" "\033[33m""Java""\e[0m" "being used in this script is:" "\033[31m""$javaversion""\e[0m"
    echo
    if [[ -f "$HOME/.userdocs/versions/$appname.version" ]]
    then
        echo -e "Your currently installed version of ${appname^} is:" "\033[32m""$(sed -n '1p' $HOME/.userdocs/versions/$appname.version)""\e[0m"
        echo
    fi
    #
    if [[ -d "$HOME/.$appname" ]]
    then
        function_cronjobremove
        function_genericproxypass
        function_genericrestart
        function_cronjobadd
        function_generichosturl
    fi
    #
    read -ep "The scripts have been updated, do you wish to continue [y] or exit now [q] : " -i "y" updatestatus
    echo
fi
#
#
if [[ "$updatestatus" =~ ^[Yy]$ ]]
then
#
############################
#### User Script Starts ####
############################
#
    #
    if [[ ! -d "$HOME/.$appname" ]]
    then
        function_installapp
        function_editapp
        function_genericproxypass
        function_genericrestart
        function_cronjobadd
        function_generichosturl
        #
        exit
    else
        echo -e "\033[31m""${appname^} appears to already be installed.""\e[0m"
        echo
        read -ep "Would you like me to kill the process and remove the directories for you? [y] or update your installation [u] quit now [q]: "  confirm
        echo
        if [[ "$confirm" =~ ^[Yy]$ ]]
        then
            function_cronjobremove
            function_genericremove
            function_genericrestart
            #
            echo -e "\033[31m" "Done""\e[0m"
            echo
            read -ep "Would you like you relaunch the installer [y] or quit [q]: " -i "y"  confirm
            echo
            if [[ "$confirm" =~ ^[Yy]$ ]]
            then
                echo -e "\033[32m""Relaunching the installer.""\e[0m"
                if [[ -f "$HOME/bin/$scriptname.sh" ]]
                then
                    "$HOME/bin/$scriptname.sh"
                    exit
                else
                    bash $(realpath $0)
                    exit
                fi
            else
                exit
            fi
        elif [[ "$confirm" =~ ^[Uu]$ ]]
        then
            echo -e "${appname^} is being updated. This will only take a moment."; echo
            function_cronjobremove
            function_updateapp
            function_cronjobadd
            exit
        else
            echo "You chose to quit and exit the script"
            echo
            exit
        fi
    fi
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