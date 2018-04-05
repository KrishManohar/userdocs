#!/bin/bash
#
# bash <(curl -sL https://git.io/vxyJw)
#
############################
##### Basic Info Start #####
############################
#
# The MIT License (MIT)
#
# Copyright (c) 2018 userdocs
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
############################
###### Basic Info End ######
############################
#
############################
###### Variable Start ######
############################
#
# Script Version number is set here.
scriptversion="1.4.3"
#
# Script name goes here. Please prefix with install.
scriptname="install.multirtru"
#
# Author name goes here.
scriptauthor="userdocs"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="https://git.io/vxyJw"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/rutorrent-autodl-multi/scripts/install.multirtru.sh"
#
# This will generate a 20 character random password for use with your applications.
apppass="$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)"
# This will generate a random port for the script between the range 10001 to 32001 to use with applications. You can ignore this unless needed.
appport="$(shuf -i 10001-32001 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(ss -ln | grep -co ''"$appport"'')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
# Please use the relevant github repository for bug reporting.
gitissue="https://github.com/userdocs/userdocs/issues/new"
#
# Please set the path to your www root here.
wwwurl="$HOME/www/$(whoami).$(hostname -f)/public_html"
#
# If you use this script for a single app installation you can set this here. Otherwise leave blank and you will need to set this per installation in a function or before a function is used.
appname="rtorrent-rutorrent-autodl-multi"
#
# Please link to the cronscript module for this installer.
cronscripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/modules/cronscripts/$appname.sh"
#
# Please link to the changelog file.
changelogurl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/$appname/changelog"
#
############################
## Custom Variables Start ##
############################
#
option1="Install a custom instance."
option2="Update a custom instance"
option3="Remove a custom instance"
option4="Fix autodl on a custom instance"
option5="Quit the script"
#
# The link to the github repository for rutorrent.
giturl="https://github.com/Novik/ruTorrent.git"
#
# autodl configuration passwords are created using this variable.
autodlpass=$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)
#
# Some basic plugins urls. Use the github repo.
ratiocolor="https://github.com/Gyran/rutorrent-ratiocolor/archive/master.zip"
#
# rtorrent.rc template
confurl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/rtorrent/conf/.rtorrent.rc"
#
rutorrentgit="https://github.com/Novik/ruTorrent/archive/master.zip"
rutorrentmaster="https://github.com/Novik/ruTorrent.git"
rutorrentconf="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/rutorrent/conf/config.php"
#
# api rate limiting is a problem so i used the commands below to bypass the api.
#
#autodlirssicommunity="$(curl -s https://api.github.com/repos/autodl-community/autodl-irssi/releases/latest | grep -P '"browser(.*)zip"' | cut -d\" -f4)"
#autodltrackers="$(curl -s https://api.github.com/repos/autodl-community/autodl-trackers/releases/latest | grep -P '"browser(.*)zip"' | cut -d\" -f4)"
#autodlrutorrent="$(curl -s https://api.github.com/repos/autodl-community/autodl-rutorrent/releases/latest | grep -P '"browser(.*)zip"' | cut -d\" -f4)"
#
autodlirssicommunityv="$(curl -sL https://github.com/autodl-community/autodl-irssi/releases/latest | sed -rn 's#(.*)<a href="/autodl-community/autodl-irssi/releases/tag/(.*)">(.*)</a>#\2#p')"
autodltrackersv="$(curl -sL https://github.com/autodl-community/autodl-trackers/releases/latest | sed -rn 's#(.*)<a href="/autodl-community/autodl-trackers/releases/tag/(.*)">(.*)</a>#\2#p')"
autodlrutorrentv="$(curl -sL https://github.com/autodl-community/autodl-rutorrent/releases/latest | sed -rn 's#(.*)<a href="/autodl-community/autodl-rutorrent/releases/tag/(.*)">(.*)</a>#\2#p')"
#
autodlirssicommunity="https://github.com/autodl-community/autodl-irssi/releases/download/$autodlirssicommunityv/autodl-irssi-v$autodlirssicommunityv.zip"
autodltrackers="https://github.com/autodl-community/autodl-trackers/releases/download/$autodltrackersv/autodl-trackers-$autodltrackersv.zip"
autodlrutorrent="https://github.com/autodl-community/autodl-rutorrent/releases/download/$autodlrutorrentv/autodl-rutorrent-$autodlrutorrentv.zip"
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
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/cronjob.sh")
#
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/$appname/functions.sh")
#
############################
####### Function End #######
############################
#
############################
#### Self Updater Start ####
############################
#
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/updater.sh")
#
############################
##### Self Updater End #####
############################
#
############################
## Positional Param Start ##
############################
#
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/changelog.sh")
#
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/info.sh")
#
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/$appname/help.sh")
#
source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/$appname/posiparams.sh")
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
[[ -n "$appname" ]] && source <(curl -sL "https://raw.githubusercontent.com/userdocs/userdocs/master/modules/$appname/install.sh") || echo "No appname specified so no script was loaded"; exit
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