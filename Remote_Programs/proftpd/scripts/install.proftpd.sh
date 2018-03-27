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
# wget -qO ~/install.proftpd https://git.io/vyPfn && bash ~/install.proftpd
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
###### Variable Start ######
############################
#
# Script Version number is set here.
scriptversion="1.4.0"
#
# Script name goes here. Please prefix with install.
scriptname="install.proftpd"
#
# Author name goes here.
scriptauthor="userdocs"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="https://git.io/vyPfn"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/scripts/install.proftpd.sh"
#
# This will generate a 20 character random passsword for use with your applications.
apppass="$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)"
# This will generate a random port for the script between the range 10001 to 32001 to use with applications. You can ignore this unless needed.
appport="$(shuf -i 10001-32001 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(ss -ln | grep -co ''"$appport"'')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
appname="proftpd"
#
# Bug reporting variables.
gitissue="https://github.com/userdocs/userdocs/issues/new"
#
cronscripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/cron/cronscript.sh"
#
changelogurl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/changelog"
#
############################
## Custom Variables Start ##
############################
#
filezilla="http://git.io/vfAZ9"
#
proftpdversion="proftpd-1.3.6"
installedproftpdversion="$(cat $HOME/proftpd/.proftpdversion 2> /dev/null)"
#
proftpdconf="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/conf/proftpd.conf"
sftpconf="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/conf/sftp.conf"
ftpsconf="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/conf/ftps.conf"
scripturl="https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/proftpd/scripts/install.proftpd.sh"
#
proftpdurl="ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6.tar.gz"
#
sftpport="$(shuf -i 10001-32001 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(ss -ln | grep -co ''"$sftpport"'')" -ge "1" ]]; do sftpport="$(shuf -i 10001-32001 -n 1)"; done
#
ftpsport="$(shuf -i 10001-32001 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(ss -ln | grep -co ''"$ftpsport"'')" -ge "1" ]]; do ftpsport="$(shuf -i 10001-32001 -n 1)"; done
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
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/cronjob.sh)
#
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/proftpd/functions.sh)
#
############################
####### Function End #######
############################
#
############################
#### Self Updater Start ####
############################
#
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/updater.sh)
#
############################
##### Self Updater End #####
############################
#
############################
## Positional Param Start ##
############################
#
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/proftpd/changelog.sh)
#
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/info.sh)
#
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/proftpd/help.sh)
#
source <(curl -sL https://raw.githubusercontent.com/userdocs/userdocs/master/modules/proftpd/posiparams.sh)
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
    if [[ -d "$HOME/proftpd" ]]
    then
        if [[ -f "$HOME"/proftpd/.proftpdversion ]]
        then
            echo -e "\033[32m""proftpd update. No settings, jails or users will be lost by updating.""\e[0m"
            echo
            read -ep "Would you like to update your version $installedproftpdversion of proftpd with this one $proftpdversion? [y]es or [e]xit or full [r]einstall: " agree2update
            echo
        else
            echo -e "\033[32m""proftpd update. No settings, jails or users will be lost by updating.""\e[0m"
            echo
            read -ep "Would you like to update your version of proftpd with this one $proftpdversion? [y]es or [e]xit or full [r]einstall: " agree2update
            echo
        fi
        if [[ "$agree2update" =~ ^[Yy]$ ]]
        then
            killall -9 -u "$(whoami)" proftpd >/dev/null 2>&1
            mkdir -p "$HOME"/proftpd/install_logs
            rm -rf "$HOME/$proftpdversion"{,.tar.gz}
            wget -qO "$HOME/$proftpdversion.tar.gz" "$proftpdurl"
            tar xf "$HOME/$proftpdversion.tar.gz"
            #
            [[ -z "$(grep -o '^ProcessTitles terse$' $HOME/proftpd/etc/proftpd.conf)" ]] && sed -i '/###### Options/a ProcessTitles terse' "$HOME"/proftpd/etc/proftpd.conf || :
            [[ -z "$(grep -o '^IdentLookups off$' $HOME/proftpd/etc/proftpd.conf)" ]] && sed -i '/###### Options/a IdentLookups off' "$HOME"/proftpd/etc/proftpd.conf || :
            [[ -z "$(grep -o '^UseReverseDNS off$' $HOME/proftpd/etc/proftpd.conf)" ]] && sed -i '/###### Options/a UseReverseDNS off' "$HOME"/proftpd/etc/proftpd.conf || :
            [[ -z "$(grep -o '^AllowOverride off$' $HOME/proftpd/etc/proftpd.conf)" ]] && sed -i '/###### Options/a AllowOverride off' "$HOME"/proftpd/etc/proftpd.conf || :
            #
            echo -n "$proftpdversion" > "$HOME"/proftpd/.proftpdversion
            cd "$HOME/$proftpdversion"
            echo "Starting to 1: configure, 2: make, 3 make install"
            echo
            install_user="$(whoami)" install_group="$(whoami)" ./configure --prefix="$HOME"/proftpd --enable-openssl --enable-dso --enable-nls --enable-ctrls --with-shared=mod_ratio:mod_readme:mod_sftp:mod_tls:mod_ban > "$HOME"/proftpd/install_logs/configure.log 2>&1
            echo "1: configure complete, moving to 2 of 3"
            make > "$HOME"/proftpd/install_logs/make.log 2>&1
            echo "2: make complete, moving to 3 of 3"
            make install > "$HOME"/proftpd/install_logs/make_install.log 2>&1
            echo "3: make install complete, moving to post installation configuration"
            echo
            "$HOME"/proftpd/bin/ftpasswd --group --name="$(whoami)" --file="$HOME/proftpd/etc/ftpd.group" --gid="$(id -g "$(whoami)")" --member="$(whoami)" >/dev/null 2>&1
            # Some tidy up
            rm -rf ~/"$proftpdversion"{,.tar.gz}
            chmod 440 ~/proftpd/etc/ftpd{.passwd,.group}
			#
			sftpport="$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/sftp.conf)"
			ftpsport="$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/ftps.conf)"
			#
			wget -qO "$HOME/proftpd/etc/sftp.conf" "$sftpconf"
			wget -qO "$HOME/proftpd/etc/ftps.conf" "$ftpsconf"
			# sftp.conf
			sed -i 's|/media/DiskID/home/my_username|'"$HOME"'|g' "$HOME/proftpd/etc/sftp.conf"
			sed -i 's|Port 23001|Port '"$sftpport"'|g' "$HOME/proftpd/etc/sftp.conf"
			# ftps.conf
			sed -i 's|/media/DiskID/home/my_username|'"$HOME"'|g' "$HOME/proftpd/etc/ftps.conf"
			sed -i 's|Port 23002|Port '"$ftpsport"'|g' "$HOME/proftpd/etc/ftps.conf"
			#
            "$HOME"/proftpd/sbin/proftpd -c "$HOME"/proftpd/etc/sftp.conf >/dev/null 2>&1
            "$HOME"/proftpd/sbin/proftpd -c "$HOME"/proftpd/etc/ftps.conf >/dev/null 2>&1
            echo -e "proftpd sftp and ftps servers were started."
			#
			echo
			cronjobadd
			cronscript
            echo
            exit
        elif [[ "$agree2update" =~ ^[Rr]$ ]]
        then
            read -ep "Are you sure you want to do a full reinstall, all settings, jails and users will be lost? [y]es i am sure or [e]xit: " areyousure
            echo
            if [[ "$areyousure" =~ ^[Yy]$ ]]
            then
                killall -9 -u "$(whoami)" proftpd >/dev/null 2>&1
                rm -rf "$HOME"/proftpd >/dev/null 2>&1
				cronjobremove
            else
                echo "You chose to exit"
                echo
                exit
            fi
        else
            echo "You chose to exit"
            echo
            exit
        fi
    fi
    #
    mkdir -p "$HOME"/proftpd/etc/sftp/authorized_keys
    mkdir -p "$HOME"/proftpd/etc/keys
    mkdir -p "$HOME"/proftpd/{ssl,install_logs}
    wget -qO "$HOME/$proftpdversion.tar.gz" "$proftpdurl"
    tar xf "$HOME/$proftpdversion.tar.gz"
    #git clone -q "$proftpdurl"
    #chmod -R 700 "$HOME/$proftpdversion"
    echo -n "$proftpdversion" > "$HOME"/proftpd/.proftpdversion
    cd "$HOME/$proftpdversion"
    echo -e "\033[33m""About to configure, make and install proftpd. This could take some time to complete. Be patient.""\e[0m"
    echo
    # configure and install
    echo "Starting to 1: configure, 2: make, 3 make install"
    echo
    install_user="$(whoami)" install_group="$(whoami)" ./configure --prefix="$HOME"/proftpd --enable-openssl --enable-dso --enable-nls --enable-ctrls --with-shared=mod_ratio:mod_readme:mod_sftp:mod_tls:mod_ban > "$HOME"/proftpd/install_logs/configure.log 2>&1
    echo "1: configure complete, moving to 2 of 3"
    make > "$HOME"/proftpd/install_logs/make.log 2>&1
    echo "2: make complete, moving to 3 of 3"
    make install > "$HOME"/proftpd/install_logs/make_install.log 2>&1
    echo "3: make install complete, moving to post installation configuration"
    echo
    # Some tidy up
    rm -rf ~/"$proftpdversion"{,.tar.gz}
    # Generate our keyfiles
    ssh-keygen -q -t rsa -f "$HOME"/proftpd/etc/keys/sftp_rsa -N '' && ssh-keygen -q -t dsa -f "$HOME"/proftpd/etc/keys/sftp_dsa -N ''
    openssl req -new -x509 -nodes -days 365 -subj '/C=GB/ST=none/L=none/CN=none' -newkey rsa:3072 -sha256 -keyout "$HOME"/proftpd/ssl/proftpd.key.pem -out "$HOME"/proftpd/ssl/proftpd.cert.pem >/dev/null 2>&1
    # Get the conf files from github and configure them for this user
	wget -qO "$HOME/proftpd/etc/proftpd.conf" "$proftpdconf"
	wget -qO "$HOME/proftpd/etc/sftp.conf" "$sftpconf"
	wget -qO "$HOME/proftpd/etc/ftps.conf" "$ftpsconf"
    # proftpd.conf
    sed -i 's|/media/DiskID/home/my_username|'"$HOME"'|g' "$HOME/proftpd/etc/proftpd.conf"
    sed -i 's|User my_username|User '"$(whoami)"'|g' "$HOME/proftpd/etc/proftpd.conf"
    sed -i 's|Group my_username|Group '"$(whoami)"'|g' "$HOME/proftpd/etc/proftpd.conf"
    sed -i 's|AllowUser my_username|AllowUser '"$(whoami)"'|g' "$HOME/proftpd/etc/proftpd.conf"
    # sftp.conf
    sed -i 's|/media/DiskID/home/my_username|'"$HOME"'|g' "$HOME/proftpd/etc/sftp.conf"
    sed -i 's|Port 23001|Port '"$sftpport"'|g' "$HOME/proftpd/etc/sftp.conf"
    # ftps.conf
    sed -i 's|/media/DiskID/home/my_username|'"$HOME"'|g' "$HOME/proftpd/etc/ftps.conf"
    sed -i 's|Port 23002|Port '"$ftpsport"'|g' "$HOME/proftpd/etc/ftps.conf"
    echo "$apppass" | "$HOME"/proftpd/bin/ftpasswd --passwd --name="$(whoami)" --file="$HOME/proftpd/etc/ftpd.passwd" --uid="$(id -u "$(whoami)")" --gid="$(id -g "$(whoami)")" --home="$HOME/" --shell="/bin/false" --stdin >/dev/null 2>&1
    "$HOME"/proftpd/bin/ftpasswd --group --name="$(whoami)" --file="$HOME/proftpd/etc/ftpd.group" --gid="$(id -g "$(whoami)")" --member="$(whoami)" >/dev/null 2>&1
    echo -e "\033[33m""You have completed the installtion. Please continue with the FAQ from Step 1 onwards.""\e[0m"
    echo
    echo -e "\033[31m""proftpd was NOT started to allow you to edit the jails in Step 2 of the FAQ as required.""\e[0m"
    echo
    echo -e "\033[33m""See Step 3 of the FAQ for how to start proftpd.""\e[0m"
    echo
    echo -e "\033[31m""FTPS/SFTP Connection Settings:""\e[0m"
    echo
    echo -e "This is your hostname: ""\033[32m""$(hostname -f)""\e[0m"
    echo
    echo -e "This is your" "\033[32m""SFTP""\e[0m" "port:" "\033[32m""$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/sftp.conf)""\e[0m"
    echo
    echo -e "This is your" "\033[32m""FTPS""\e[0m" "port:" "\033[32m""$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/ftps.conf)""\e[0m"
    echo
    echo -e "This is your main username: ""\033[32m""$(whoami)""\e[0m"" and this is your password: ""\033[32m""$apppass""\e[0m"
    #function
    filezillaxml
    echo
    echo "Filezilla site templates that you can import into Filezilla were generated in:"
    echo
    echo -e "\033[36m""~/.userdocs/logins/$(whoami).$(hostname -f).xml""\e[0m"
    echo
    echo -e "Use this command to see important information:" "\033[36m""$scriptname help""\e[0m"
    echo
	#
	cronjobadd
	cronscript
	#
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
