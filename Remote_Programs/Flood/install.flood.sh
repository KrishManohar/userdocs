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
# wget -qO ~/install.flood https://git.io/vHqf6 && bash ~/install.flood
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
    echo 'v0.0.2 - Updated templated'
    echo 'v0.0.1 - Updated templated'
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
scriptname="install.flood"
#
# Author name goes here.
scriptauthor="userdocs"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="https://git.io/vHqf6"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Flood/install.flood.sh"
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
floodconfig="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/Flood/configs/config.js"
#
socketpath="$HOME/private/rtorrent/.socket"
#
appname="flood"
#    
startcommand="~/bin/npm start --prefix ~/."$appname""
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
function_showMenu () {
    #
    echo "1) Install Flood for rtorrent"
    echo "2) Update Flood for rtorrent"
    echo "3) Remove Flood for rtorrent"
    echo "4) wip - Remove Flood for an rtorrent custom instance"
    echo "5) Quit the script"
    #
    echo
}
#
#
function_installnode () {
	echo "Installing nodejs."
	echo
	wget -O ~/.userdocs/tmp/node.js.tar.gz https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz > ~/.userdocs/logs/node-forever.log 2>&1
	tar xf ~/.userdocs/tmp/node.js.tar.gz --strip-components=1 -C ~/
	cd && rm -rf ~/.userdocs/tmp/node.js.tar.gz
	echo -n "$(~/bin/node -v | sed -rn 's/v(.*)/\1/p')" > ~/.userdocs/versions/node.version
	~/bin/npm install forever -g >> ~/.userdocs/logs/node-forever.log 2>&1
	echo "Nodejs $(~/bin/node -v | sed -rn 's/v(.*)/\1/p') has been installed"
	echo
}
#
function_installflood () {
	if [[ ! -d ~/.$appname ]]
	then
		echo "Flood is installing. Please wait until the install is complete."
		echo
		git clone https://github.com/jfurrow/flood.git ~/.$appname > ~/.userdocs/logs/$appname.log 2>&1
		echo "Git repo has been cloned"
		echo
		wget -O ~/.$appname/config.js "$floodconfig" >> ~/.userdocs/logs/$appname.log 2>&1
		sed -i 's|username|'"$(whoami)"'|g' ~/.$appname/config.js
		sed -i 's|PORT|'"$appport"'|g' ~/.$appname/config.js
		sed -i 's|SECRETKEY|'"$apppass"'|g' ~/.$appname/config.js
		sed -i 's|SOCKETPATH|'"$socketpath"'|g' ~/.$appname/config.js
		echo "The configuration file has been created"
		echo
		cd ~/.$appname
		echo "Installing Flood and npm packages. Please wait."
		echo
		npm install --production >> ~/.userdocs/logs/$appname.log 2>&1
		echo "Flood has been installed and configured"
		echo
	else
		echo "${appname^} is already installed. Please use the remove or update options"
		echo
	fi
}
#
function_updateflood () {
    touch "$HOME/.userdocs/tmp/$appname.lock"
    function_cronjobremove
    function_genericrestart
    #
    cd "$HOME/.$appname"
    git pull
    npm install --production
    cd && rm -f "$HOME/.userdocs/tmp/$appname.lock"
    #
    function_genericrestart
    function_cronjobadd
    echo
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
function_installnode
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
    function_showMenu
    read -e CHOICE
    echo
    case "$CHOICE" in
        "1")
            function_cronjobremove
            #
			function_installflood
			#
			function_genericproxypass
			#
			function_cronjobadd
			#
			function_genericrestart
			#
			function_generichosturl
			#
            ;;
        "2")
            function_updateflood
            #
            ;;
        "3")
            function_cronjobremove
			function_genericremove
            #
            ;;
        "4")
            echo "nothing to see here yet"
            echo
            ;;
        "5")
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