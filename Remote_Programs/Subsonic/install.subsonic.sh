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
# Bash Command for easy reference: wget -qO ~/install.subsonic http://git.io/bGZT && bash ~/install.subsonic
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

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
    #echo 'v0.0.2 - My changes go here'
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
scriptversion="2.5.0"
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
gitiourl=""
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
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(netstat -ln | grep ':'"$appport"'' | grep -c 'LISTEN')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
# Bug reporting variables.
gitissue="https://github.com/userdocs/userdocs/issues/new"
#
############################
## Custom Variables Start ##
############################
#
subsonicversion="6.0"
#
getversion="$(curl -s http://java.com/en/download/linux_manual.jsp | sed -rn 's/(.*)>Recommended Version (.*) Update (.*)<(.*)/\2/p')"
getupdate="$(curl -s http://java.com/en/download/linux_manual.jsp | sed -rn 's/(.*)>Recommended Version (.*) Update (.*)<(.*)/\3/p')"
javaversion="The Latest Java available is $getversion Update $getupdate"
javadecimal="1.$getversion.0_$getupdate"
#
# Check the version of the installed java binary in the PATH
currentjavaversion="$(java -version 2>&1 | sed -rn 's/(.*)"(.*)"(.*)/\2/p')"
#
# Gets the Java version from the last time this script installed Java by checking the ~/.userdocs/versions/java.version file
installedjavaversion="$(cat ~/.userdocs/versions/java.version 2> /dev/null)"
#
# Java URL which shoudl always return the most  current linux x64 url download
javaupdateurl="$(curl -s http://java.com/en/download/linux_manual.jsp | egrep -om 1 '<a title="Download Java software for Linux x64" href="http://javadl\.oracle\.com/webapps/download/AutoDL\?BundleId=(.*)" ' | sed -rn 's/(.*)href="(.*)"(.*)/\2/p')"
# Defines the memory variable
# buffer
maxmemory="4096"
#
subsonicfv="http://subsonic.org/download/subsonic-6.0-standalone.tar.gz"
subsonicfvs="subsonic-6.0-standalone.tar.gz"
# ffmpeg files
sffmpegfv="http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz"
sffmpegfvs="ffmpeg-release-64bit-static.tar.xz"
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
cronjobadd () {
    # adding jobs to cron: Set the variable tmpcron to a randomly generated temporary file.
    tmpcron="$(mktemp)"
    # Check if the job exists already by grepping whatever is between ^$
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/subsonic.cronjob$')" == "0" ]]
    then
        # sometimes the cronjob will be to run a custom script generated by the installer, located in the directory ~/.userdocs/cronjobs
        mkdir -p ~/.userdocs/cronjobs/logs
        echo "Appending application to crontab."; echo
        crontab -l 2> /dev/null > "$tmpcron"
        echo '* * * * * bash -l ~/.userdocs/cronjobs/subsonic.cronjob' >> "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        echo "This cronjob is already in crontab"; echo
    fi
}
#
cronjobremove () {
    tmpcron="$(mktemp)"
    if [[ "$(crontab -l 2> /dev/null | grep -oc '^\* \* \* \* \* bash -l ~/.userdocs/cronjobs/subsonic.cronjob$')" == "1" ]]
    then
        crontab -l 2> /dev/null > "$tmpcron"
        sed -i '/^\* \* \* \* \* bash -l ~\/.userdocs\/cronjobs\/subsonic.cronjob$/d' "$tmpcron"
        sed -i '/^$/d' "$tmpcron"
        crontab "$tmpcron"
        rm "$tmpcron"
    else
        :
    fi
}
#
cronscript () {
    # Create the cron script.
    echo '#!/bin/bash
    if [[ -z "$(ps -p $(cat ~/private/subsonic/subsonic.sh.PID) --no-headers)" && -d ~/private/subsonic ]]
    then
        bash ~/private/subsonic/subsonic.sh
        echo "$(date +"%H:%M on the %d.%m.%y")" >> ~/.userdocs/cronjobs/logs/subsonic.log
    else
        exit
    fi' > ~/.userdocs/cronjobs/subsonic.cronjob
}
#
proxypass () {
if [[ -f ~/private/subsonic/subsonic.sh ]]
then
    mkdir -p ~/.apache2/conf.d
    echo -en 'Include /etc/apache2/mods-available/proxy.load\nInclude /etc/apache2/mods-available/proxy_http.load\nInclude /etc/apache2/mods-available/headers.load\nInclude /etc/apache2/mods-available/ssl.load\n\nProxyRequests Off\nProxyPreserveHost On\nProxyVia On\nSSLProxyEngine on\n\nProxyPass /subsonic http://10.0.0.1:'$(sed -n -e 's/SUBSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/subsonic/subsonic.sh 2> /dev/null)'/${USER}/subsonic\nProxyPassReverse /subsonic http://10.0.0.1:'$(sed -n -e 's/SUBSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/subsonic/subsonic.sh 2> /dev/null)'/${USER}/subsonic\nRedirect /${USER}/subsonic https://${APACHE_HOSTNAME}/${USER}/subsonic' > "$HOME/.apache2/conf.d/subsonic.conf"
    /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
    # Nginx proxypass
    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
    then
        mkdir -p ~/.nginx/proxy
        echo -e 'location /subsonic {\n\nproxy_temp_path '"$HOME"'/.nginx/proxy;\n\nproxy_set_header        Host            $http_x_host;\nproxy_set_header        X-Real-IP       $remote_addr;\nproxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\nrewrite /subsonic/(.*) /'$(whoami)'/subsonic/$1 break;\nproxy_pass http://10.0.0.1:'$(sed -n -e 's/SUBSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/subsonic/subsonic.sh 2> /dev/null)'/'$(whoami)'/subsonic/;\nproxy_redirect http:// https://;\n\n}' > ~/.nginx/conf.d/000-default-server.d/subsonic.conf
        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
    fi
    echo -e "The" "\033[36m""nginx/apache proxypass""\e[0m" "has been installed."
    echo
    echo -e "Subsonic is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/subsonic/""\e[0m"
    echo
fi
}
#
installjava () {
    if [[ ! -f ~/bin/java && -f ~/.userdocs/versions/java.version ]]
    then
        rm -f ~/.javaversion ~/.userdocs/.javaversion ~/.userdocs/versions/java.version
        export installedjavaversion=""
    fi
    if [[ "$installedjavaversion" != "$javadecimal" ]]
    then
        echo "Please wait a moment while java is installed"; echo
        rm -rf ~/private/java
        wget -qO ~/.userdocs/tmp/java.tar.gz "$javaupdateurl"
        tar xf ~/.userdocs/tmp/java.tar.gz --strip-components=1 -C ~/
        rm -rf ~/.userdocs/tmp/*
        echo "$javadecimal" > ~/.userdocs/versions/java.version
        rm -f {Welcome.html,THIRDPARTYLICENSEREADME-JAVAFX.txt,THIRDPARTYLICENSEREADME.txt,release,README,LICENSE,COPYRIGHT}
        echo -e "\033[31m""Important:""\e[0m" "Java" "\033[32m""$javadecimal""\e[0m" "has been installed to" "\033[36m""$HOME/""\e[0m"
        #
        if [[ -f ~/private/subsonic/subsonic.sh.PID ]] 
        then
            kill -9 "$(cat ~/private/subsonic/subsonic.sh.PID 2> /dev/null)" 2> /dev/null
            [[ -z "$(ps -p $(cat ~/private/subsonic/subsonic.sh.PID) --no-headers)" && -d ~/private/subsonic ]] && bash ~/private/subsonic/subsonic.sh
        fi
        echo
    fi
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
#############################
#### subsonicrsk starts  ####
#############################
#
wget -qO ~/bin/subsonicrsk http://git.io/vEBak
chmod -f 700 ~/bin/subsonicrsk
#
#############################
##### subsonicrsk ends  #####
#############################
#
#############################
#### subsonicron starts  ####
#############################
#
cronjobadd
cronscript
#
#############################
##### subsonicron ends  #####
#############################
#
#############################
##### proxypass starts  #####
#############################
#
proxypass
#
#############################
###### proxypass ends  ######
#############################
#
if [[ "$updatestatus" == "y" ]]
then
    :
else
    echo -e "The" "\033[36m""~/bin/subsonicrsk""\e[0m" "has been updated."
    echo
    read -ep "The scripts have been updated, do you wish to continue [y] or exit now [q] : " -i "y" updatestatus
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
    mkdir -p ~/private
    #
    #############################
    #### Install Java Start  ####
    #############################
    #
    echo $installedjavaversion 
    echo $jvdecimal
    installjava
    #
    #############################
    ##### Install Java End  #####
    #############################
    #
    if [[ ! -d ~/private/subsonic ]]
    then
        echo -e "Congratulations," "\033[31m""Java is installed""\e[0m"". Continuing with the installation."
        echo
        echo -e "Path" "\033[36m""~/private/subsonic/""\e[0m" "created. Moving to next step."
        mkdir -p ~/.userdocs/tmp/
        mkdir -p ~/private/subsonic/transcode
        mkdir -p ~/private/subsonic/playlists
        mkdir -p ~/private/subsonic/Podcasts
        # buffer
        echo -n "$subsonicfvs" > ~/private/subsonic/.version
        echo
        echo -e "\033[32m""$subsonicfvs""\e[0m" "Is downloading now."
        wget -qO ~/.userdocs/tmp/subsonic.tar.gz "$subsonicfv"
        echo -e "\033[36m""$subsonicfvs""\e[0m" "Has been downloaded and renamed to" "\033[36m""subsonic.tar.gz\e[0m"
        echo -e "\033[36m""subsonic.tar.gz""\e[0m" "Is unpacking now."
        tar xf ~/.userdocs/tmp/subsonic.tar.gz -C ~/private/subsonic/
        echo -e "\033[36m""subsonic.tar.gz""\e[0m" "Has been unpacked to" "\033[36m""~/private/subsonic/\e[0m"
        echo
        echo -e "\033[32m""$sffmpegfvs""\e[0m" "Is downloading now."
        wget -qO ~/.userdocs/tmp/ffmpeg.tar.gz "$sffmpegfv"
        echo -e "\033[36m""$sffmpegfvs""\e[0m" "Has been downloaded and renamed to" "\033[36m""ffmpeg.zip\e[0m"
        echo -e "\033[36m""$sffmpegfvs""\e[0m" "Is being unpacked now."
        tar xf ~/.userdocs/tmp/ffmpeg.tar.gz --strip-components=1 -C ~/private/subsonic/transcode/
        chmod -f 700 ~/private/subsonic/transcode/{Audioffmpeg,ffmpeg,lame,xmp}
        echo -e "\033[36m""$sffmpegfvs""\e[0m" "Has been unpacked to" "\033[36m~/private/subsonic/transcode/\e[0m"
        rm -rf ~/.userdocs/tmp/*
        echo
        echo -e "\033[32m""Copying over a local version of lame.""\e[0m"
        # cp -f /usr/local/bin/lame ~/private/subsonic/transcode/ 2> /dev/null
        chmod -f 700 ~/private/subsonic/transcode/lame
        echo -e "Lame copied to" "\033[36m""~/private/subsonic/transcode/\e[0m"
        echo
        echo -e "\033[32m""Copying over a local version of flac.""\e[0m"
        cp -f /usr/bin/flac ~/private/subsonic/transcode/ 2> /dev/null
        chmod -f 700 ~/private/subsonic/transcode/flac
        echo -e "Flac copied to" "\033[36m""~/private/subsonic/transcode/""\e[0m"
        echo
        echo -e "\033[31m""Configuring the start-up script.""\e[0m"
        echo -e "\033[35m""User input is required for this next step:""\e[0m"
        echo -e "\033[33m""Note on user input:""\e[0m" "It is OK to use a relative path like:" "\033[33m""~/private/rtorrent/data""\e[0m"
        #
        sed -i 's|SUBSONIC_HOME=/var/subsonic|SUBSONIC_HOME=~/private/subsonic|g' ~/private/subsonic/subsonic.sh
        sed -i "s/SUBSONIC_PORT=4040/SUBSONIC_PORT=$appport/g" ~/private/subsonic/subsonic.sh
        sed -i 's|SUBSONIC_CONTEXT_PATH=/|SUBSONIC_CONTEXT_PATH=/$(whoami)/subsonic|g' ~/private/subsonic/subsonic.sh
        # buffer
        sed -i "s/SUBSONIC_MAX_MEMORY=150/SUBSONIC_MAX_MEMORY=$maxmemory/g" ~/private/subsonic/subsonic.sh
        sed -i '0,/SUBSONIC_PIDFILE=/s|SUBSONIC_PIDFILE=|SUBSONIC_PIDFILE=~/private/subsonic/subsonic.sh.PID|g' ~/private/subsonic/subsonic.sh
        #
        read -ep "Enter the path to your media or leave blank and press enter to skip: " path
        #
        sed -i "s|SUBSONIC_DEFAULT_MUSIC_FOLDER=/var/music|SUBSONIC_DEFAULT_MUSIC_FOLDER=$path|g" ~/private/subsonic/subsonic.sh
        # buffer
        sed -i 's|SUBSONIC_DEFAULT_PODCAST_FOLDER=/var/music/Podcast|SUBSONIC_DEFAULT_PODCAST_FOLDER=~/private/subsonic/Podcast|g' ~/private/subsonic/subsonic.sh
        sed -i 's|SUBSONIC_DEFAULT_PLAYLIST_FOLDER=/var/playlists|SUBSONIC_DEFAULT_PLAYLIST_FOLDER=~/private/subsonic/playlists|g' ~/private/subsonic/subsonic.sh
        # buffer
        # buffer
        sed -i 's/quiet=0/quiet=1/g' ~/private/subsonic/subsonic.sh
        sed -i "22 i export LC_ALL=en_GB.UTF-8\n" ~/private/subsonic/subsonic.sh
        sed -i '22 i export LANG=en_GB.UTF-8' ~/private/subsonic/subsonic.sh
        sed -i '22 i export LANGUAGE=en_GB.UTF-8' ~/private/subsonic/subsonic.sh
        # Apache proxypass
        mkdir -p ~/.apache2/conf.d
        echo -en 'Include /etc/apache2/mods-available/proxy.load\nInclude /etc/apache2/mods-available/proxy_http.load\nInclude /etc/apache2/mods-available/headers.load\nInclude /etc/apache2/mods-available/ssl.load\n\nProxyRequests Off\nProxyPreserveHost On\nProxyVia On\nSSLProxyEngine on\n\nProxyPass /subsonic http://10.0.0.1:'"$appport"'/${USER}/subsonic\nProxyPassReverse /subsonic http://10.0.0.1:'"$appport"'/${USER}/subsonic\nRedirect /${USER}/subsonic https://${APACHE_HOSTNAME}/${USER}/subsonic' > "$HOME/.apache2/conf.d/subsonic.conf"
        /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
        echo
        # Nginx proxypass
        if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
        then
            mkdir -p ~/.nginx/proxy
            echo -e 'location /subsonic {\n\nproxy_temp_path '"$HOME"'/.nginx/proxy;\n\nproxy_set_header        Host            $http_x_host;\nproxy_set_header        X-Real-IP       $remote_addr;\nproxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\nrewrite /subsonic/(.*) /'$(whoami)'/subsonic/$1 break;\nproxy_pass http://10.0.0.1:'"$appport"'/'$(whoami)'/subsonic/;\nproxy_redirect http:// https://;\n\n}' > ~/.nginx/conf.d/000-default-server.d/subsonic.conf
            /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
        fi
        echo -e "\033[31m""Start-up script successfully configured.""\e[0m"
        echo "Executing the start-up script now."
        [[ -z "$(ps -p $(cat ~/private/subsonic/subsonic.sh.PID) --no-headers)" && -d ~/private/subsonic ]] && bash ~/private/subsonic/subsonic.sh
        echo -e "A restart/start/kill script has been created at:" "\033[35m""~/bin/subsonicrsk""\e[0m"
        echo -e "\033[32m""Subsonic is now started, use the links below to access it. Don't forget to set path to FULL path to you music folder in the gui.""\e[0m"
        echo
        echo -e "Subsonic is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/subsonic/""\e[0m"
        echo -e "It may take a minute or two to load properly."
        echo
        echo -e "Subsonic started at PID:" "\033[31m""$(cat ~/private/subsonic/subsonic.sh.PID 2> /dev/null)""\e[0m"
        echo
        bash
        exit
    else
        echo -e "\033[31m""Subsonic appears to already be installed.""\e[0m" "Please kill the PID:" "\033[33m""$(cat ~/private/subsonic/subsonic.sh.PID 2> /dev/null)""\e[0m" "if it is running and delete the" "\033[36m""~/private/subsonic directory""\e[0m"
        echo
        read -ep "Would you like me to kill the process and remove the directories for you? [y] or update your installation [u] quit now [q]: "  confirm
        echo
        if [[ "$confirm" =~ ^[Yy]$ ]]
        then
            echo "Killing the process and removing files."
            kill -9 "$(cat ~/private/subsonic/subsonic.sh.PID 2> /dev/null)" 2> /dev/null
            echo -e "\033[31m" "Done""\e[0m"
            echo "Removing ~/private/subsonic"
            rm -rf ~/private/subsonic
            echo -e "\033[31m" "Done""\e[0m"
            echo "Removing scripts."
            rm -f ~/bin/subsonic.4.8
            rm -f ~/subsonic.4.8.sh
            rm -f ~/subsonicstart.sh
            rm -f ~/subsonicrestart.sh
            rm -f ~/subsonickill.sh
            rm -f ~/subsonicrsk.sh
            rm -f ~/bin/subsonicrsk
            rm -f ~/bin/subsonicron
            rm -f ~/.cronjobs/subsonic.cronjob
            cronjobremove
            rm -f ~/.nginx/conf.d/000-default-server.d/subsonic.conf
            rm -f ~/.apache2/conf.d/subsonic.conf
            /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
            /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
            echo -e "\033[31m" "Done""\e[0m"
            echo "Finalising removal."
            rm -rf ~/private/subsonic
            echo -e "\033[31m" "Done and Done""\e[0m"
            echo
            read -ep "Would you like you relaunch the installer [y] or quit [q]: " -i "y"  confirm
            echo
            if [[ "$confirm" =~ ^[Yy]$ ]]
            then
                echo -e "\033[32m""Relaunching the installer.""\e[0m"
                if [[ -f ~/bin/"$scriptname" ]]
                then
                    bash ~/bin/"$scriptname"
                else
                    wget -qO ~/bin/"$scriptname" "$scripturl"
                    bash ~/bin/"$scriptname"
                fi
            else
                exit
            fi
        elif [[ "$confirm" =~ ^[Uu]$ ]]
        then
            echo -e "Subsonic is being updated. This will only take a moment."
            kill -9 "$(cat ~/private/subsonic/subsonic.sh.PID 2> /dev/null)" 2> /dev/null
            mkdir -p ~/.userdocs/tmp
            wget -qO ~/subsonic.tar.gz "$subsonicfv"
            tar xf ~/subsonic.tar.gz -C ~/.userdocs/tmp
            rm -f ~/.userdocs/tmp/subsonic.sh
            cp -rf ~/.userdocs/tmp/. ~/private/subsonic/
            wget -qO ~/ffmpeg.zip "$sffmpegfv"
            unzip -qo ~/ffmpeg.zip -d ~/private/subsonic/transcode
            chmod -f 700 ~/private/subsonic/transcode/{Audioffmpeg,ffmpeg,lame,xmp}
            echo -n "$subsonicfvs" > ~/private/subsonic/.version
            rm -rf ~/subsonic.tar.gz ~/ffmpeg.zip ~/.userdocs/tmp/*
            sed -i "s|^SUBSONIC_CONTEXT_PATH=/$|SUBSONIC_CONTEXT_PATH=/$(whoami)/subsonic|g" ~/private/subsonic/subsonic.sh
            # Apache proxypass
            mkdir -p ~/.apache2/conf.d
            echo -en 'Include /etc/apache2/mods-available/proxy.load\nInclude /etc/apache2/mods-available/proxy_http.load\nInclude /etc/apache2/mods-available/headers.load\nInclude /etc/apache2/mods-available/ssl.load\n\nProxyRequests Off\nProxyPreserveHost On\nProxyVia On\nSSLProxyEngine on\n\nProxyPass /subsonic http://10.0.0.1:'$(sed -n -e 's/SUBSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/subsonic/subsonic.sh 2> /dev/null)'/${USER}/subsonic\nProxyPassReverse /subsonic http://10.0.0.1:'$(sed -n -e 's/SUBSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/subsonic/subsonic.sh 2> /dev/null)'/${USER}/subsonic\nRedirect /${USER}/subsonic https://${APACHE_HOSTNAME}/${USER}/subsonic' > "$HOME/.apache2/conf.d/subsonic.conf"
            /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
            echo
            # Nginx proxypass
            if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
            then
                mkdir -p ~/.nginx/proxy
                echo -e 'location /subsonic {\n\nproxy_temp_path '"$HOME"'/.nginx/proxy;\n\nproxy_set_header        Host            $http_x_host;\nproxy_set_header        X-Real-IP       $remote_addr;\nproxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\nrewrite /subsonic/(.*) /'$(whoami)'/subsonic/$1 break;\nproxy_pass http://10.0.0.1:'$(sed -n -e 's/SUBSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/subsonic/subsonic.sh 2> /dev/null)'/'$(whoami)'/subsonic/;\nproxy_redirect http:// https://;\n\n}' > ~/.nginx/conf.d/000-default-server.d/subsonic.conf
                /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
            fi
            [[ -z "$(ps -p $(cat ~/private/subsonic/subsonic.sh.PID) --no-headers)" && -d ~/private/subsonic ]] && bash ~/private/subsonic/subsonic.sh
            echo -e "A restart/start/kill script has been created at:" "\033[35m""~/bin/subsonicrsk""\e[0m"
            echo -e "\033[32m""Subsonic is now started, use the link below to access it. Don't forget to set path to FULL path to you music folder in the gui.""\e[0m"
            echo
            echo -e "Subsonic is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/subsonic/""\e[0m"
            echo -e "It may take a minute or two to load properly."
            echo
            echo -e "Subsonic started at PID:" "\033[31m""$(cat ~/private/subsonic/subsonic.sh.PID 2> /dev/null)""\e[0m"
            echo
            bash
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