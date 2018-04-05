showMenu () 
{
        #
        echo "1) $option1"
        echo "2) $option2"
        echo "3) $option3"
        echo "4) $option4"
        echo "5) $option5"
        #
        echo
}

while [ 1 ]
do
    showMenu
    read -e CHOICE
    echo
    case "$CHOICE" in
        "1")
            prerequisites
            #
            # Reset the $suffix variable so that the script can reload a section multiple times in a single use.
            suffix=""
            appname=""
            #
            echo -e "This script will create a new unique rutorrent,rtorrent and (optionally) autodl instance using a suffix, for example:"
            echo
            echo -e "For example: ""\033[32m""rutorrent-1 ""\e[0m""\033[33m""autodl-1 and irssi-1 ""\e[0m""\033[36m""rtorrent-1 and ~/.rtorrent-1.rc""\e[0m"
            echo
            echo -e "\033[31m""The first thing we need to do is pick a suffix to use:""\e[0m"
            echo
            echo -e "To return to the menu type: ""\033[32m""back""\e[0m"
            echo
            #
            while [[ -z "$suffix" ]]
            do
                read -ep "Please chose a suffix to use for our new installations: " suffix
                echo
            done
            #
            if [[ "$suffix" != "back" ]]
            then
                if [[ ! -f ~/.rtorrent-"$suffix".rc && ! -d ~/private/rtorrent-"$suffix" && ! -d "$wwwurl/rutorrent-$suffix" ]]
                then
                    installrtorrent
                    #
                    installrutorrent
                    #
                    installrutorrentratiocolour
                    #
                    read -ep "Would you like this script to install and configure Autodl-irssi for this instance to? [y]es or [n]o: " -i "n" autodlinstall
                    echo
                    if [[ "$autodlinstall" =~ ^[Yy]$ ]]
                    then
                        installautodl
                        #
                        installautodlrutorrent
                        #
                        autodlfix
                        #
                        autodlstart
                        #
                    else
                        echo "This instance has been installed without autodl-irssi"
                        echo
                    fi
                    #
                    appname="rtorrent-$suffix"
                    #
                    cronjobadd
                    #
                    cronscript
                    #
                    passwordprotect
                    #
                    genericstart
                else
                    echo -e "\033[31m""This suffix is already in use. Please use another.""\e[0m"
                    echo
                fi
                sleep 3
            fi
        ;;
        "2")
            functiontwo
            #
            if [[ "$suffix" != "back" ]]
            then
                if [[ -d "$wwwurl/rutorrent-$suffix" ]]
                then
                    prerequisites
                    #
                    echo -e "Updating ruTorrent"
                    echo
                    # Download the rutorrent github master repo to the ~/.userdocs/tmp directory.
                    wget -qO ~/.userdocs/tmp/rutorrentgit.zip "$rutorrentgit"
                    # Extract the rutorrentgit.zip in the ~/.userdocs/tmp directory
                    unzip -qo ~/.userdocs/tmp/rutorrentgit.zip
                    #
                    # Check to see if there is a .htaccess file present and delete it. Otherwise do nothing.
                    [[ -f ~/.userdocs/tmp/ruTorrent-master/.htaccess ]] && rm -f ~/ruTorrent-master/.htaccess
                    #
                    # Check to see if there is a rutorrent-suffix directory is present and delete some plugins we don't need. Otherwise do nothing.
                    [[ -d "$wwwurl/public_html/rutorrent-$suffix" ]] && rm -rf "$wwwurl/public_html/rutorrent-$suffix"/plugins/{cpuload,diskspace}
                    #
                    cp -rf ~/ruTorrent-master/. "$wwwurl/public_html/rutorrent-$suffix"
                    #
                    # Download the required rutorrent conf template file again.
                    wget -qO "$wwwurl"/public_html/rutorrent-"$suffix"/conf/config.php "$rutorrentconf"
                    #
                    # Delete these files and folders if they exists otherwise do nothing.
                    [[ -d ~/.userdocs/tmp/ruTorrent-master ]] && rm -rf ~/.userdocs/tmp/ruTorrent-master
                    [[ -f ~/.userdocs/tmp/rutorrentgit.zip ]] && rm -rf ~/.userdocs/tmp/rutorrentgit.zip
                    #
                    # Download and install the ratio colour plugin
                    wget -qO ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/ratiocolor.zip "$ratiocolor"
                    unzip -qo ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/ratiocolor.zip -d ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/
                    rm -f ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/ratiocolor.zip
                    #
                    echo -e "Editing the files: rutorrent"
                    echo
                    sed -i 's|/private/rtorrent/.socket|/private/rtorrent-'"$suffix"'/.socket|g' ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/conf/config.php
                    #
                    if [[ $(grep -c '^screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~/.rtorrent-'"$suffix"'.rc$' ~/.userdocs/multirtru.restart.txt) -eq "0" ]]
                    then
                        echo 'screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~/.rtorrent-'"$suffix"'.rc' >> ~/.userdocs/multirtru.restart.txt
                    fi
                else 
                    echo -e "\033[31m""No matching rutorrent instances exist. Try again.""\e[0m"
                    echo
                fi
                #
                if [[ -d ~/.autodl-"$suffix" && -d ~/.irssi-"$suffix" ]]
                then
                    ############################
                    ####### Autodl Start #######
                    ############################
                    #
                    echo -e "Updating autodl-$suffix"
                    echo
                    kill -9 $(screen -ls autodl | sed -rn 's/(.*).autodl-(.*)/\1/p')  > /dev/null 2>&1
                    # Makes the directories we require for the irssi and autodl update.
                    mkdir -p ~/{.autodl-"$suffix",.irssi-"$suffix"/scripts/autorun}
                    # Downloads the newest RELEASE version of the autodl community edition and saves it as a zip file.
                    wget -qO ~/autodl-irssi.zip "$autodlirssicommunity"
                    # Downloads the newest  RELEASE version  of the autodl community trackers file and saves it as a zip file.
                    wget -qO ~/autodl-trackers.zip "$autodltrackers"
                    # Unpack core autodl files to the desired location for further processing
                    unzip -qo ~/autodl-irssi.zip -d ~/.irssi-"$suffix"/scripts/
                    # Unpack the latest trackers file just to make sure we are they are current.
                    unzip -qo ~/autodl-trackers.zip -d ~/.irssi-"$suffix"/scripts/AutodlIrssi/trackers/
                    # Moves the files around to their proper homes. The .pl file is moved to autorun so that autodl starts automatically when we open irssi
                    cp -f ~/.irssi-"$suffix"/scripts/autodl-irssi.pl ~/.irssi-"$suffix"/scripts/autorun/
                    # Delete files we no longer need.
                    rm -f ~/autodl-{irssi,trackers}.zip ~/.irssi-"$suffix"/scripts/{README*,CONTRIBUTING.md,autodl-irssi.pl}
                    echo -e "[options]\ngui-server-port = $appport\ngui-server-password = $autodlpass" > ~/.autodl-"$suffix"/autodl.cfg
                    #
                    ############################
                    ######## Autodl End ########
                    ############################
                    #
                    ############################
                    ##### RuTorrent Starts #####
                    ############################
                    #
                    # Copy the contents from autodl-rutorrent-master to a folder called autodl-irssi in the rutorrent plug-in directory, creating it if absent
                    mkdir -p ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins
                    # Downloads the latest version of the autodl-irssi plugin
                    wget -qO ~/autodl-rutorrent.zip "$autodlrutorrent"
                    # Unpacks the autodl rutorrent plugin here
                    unzip -qo ~/autodl-rutorrent.zip -d ~/www/"$(whoami)"."$(hostname -f)"/public_html/rutorrent-"$suffix"/plugins/autodl-irssi
                    # Delete the downloaded zip and the unpacked folder we no longer require.
                    cd && rm -rf autodl-rutorrent{-master,.zip}
                    # Uses echo to make the config file for the rutorrent plugun to work with autodl using the variables port and pass
                    echo -ne '<?php\n$autodlPort = '"$appport"';\n$autodlPassword = "'"$autodlpass"'";\n?>' > ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/conf.php
                    if [[ $(grep -c '^screen -dmS autodl-'"$suffix"' irssi --home=$HOME/.irssi-'"$suffix"'/$' ~/.userdocs/multirtru.restart.txt) -eq "0" ]]
                    then
                        echo 'screen -dmS autodl-'"$suffix"' irssi --home=$HOME/.irssi-'"$suffix"'/' >> ~/.userdocs/multirtru.restart.txt
                    fi
                    #
                    # Add to crontab
                    tmpcron="$(mktemp)"
                    if [ "$(crontab -l 2> /dev/null | grep -c 'screen -dmS autodl-'"$suffix"' irssi --home=$HOME/.irssi-'"$suffix")" == "0" ]; then
                        echo "appending rtorrent-${suffix} to crontab."
                        crontab -l 2> /dev/null > "$tmpcron"
                        echo '@reboot screen -dmS autodl-'"$suffix"' irssi --home=$HOME/.irssi-'"$suffix" >> "$tmpcron"
                        crontab "$tmpcron"
                        rm "$tmpcron"
                    else
                        echo "This instance is already in your crontab."
                    fi 
                    ############################
                    ###### RuTorrent Ends ######
                    ############################
                    #
                    ############################
                    ##### Fix script Start #####
                    ############################
                    #
                    echo "Applying the fix script as part of the update:"
                    # Set a custom home dir for autodl to ~/.autodl-$suffix
                    sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' ~/.irssi-"$suffix"/scripts/AutodlIrssi/Dirs.pm
                    # Fix the core Autodl files by changing 127.0.0.1 to 10.0.0.1 using sed in 3 places in 2 files.
                    sed -i "s|use constant LISTEN_ADDRESS => '127.0.0.1';|use constant LISTEN_ADDRESS => '10.0.0.1';|g" ~/.irssi-"$suffix"/scripts/AutodlIrssi/GuiServer.pm
                    sed -i 's|$rtAddress = "127.0.0.1$rtAddress"|$rtAddress = "10.0.0.1$rtAddress"|g' ~/.irssi-"$suffix"/scripts/AutodlIrssi/MatchedRelease.pm
                    sed -i 's|my $scgi = new AutodlIrssi::Scgi($rtAddress, {REMOTE_ADDR => "127.0.0.1"});|my $scgi = new AutodlIrssi::Scgi($rtAddress, {REMOTE_ADDR => "10.0.0.1"});|g' ~/.irssi-"$suffix"/scripts/AutodlIrssi/MatchedRelease.pm
                    #
                    echo -e "\033[33m""Autodl fix has been applied""\e[0m"
                    # Fix the relevent rutorrent plugin file by changing 127.0.0.1 to 10.0.0.1 using sed
                    sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/getConf.php
                    sed -i "s|'/.autodl/autodl.cfg'|'/.autodl-$suffix/autodl.cfg'|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/getConf.php
                    echo -e "\033[33m""Autodl-rutorrent fix has been applied""\e[0m"
                    echo
                    #
                    ############################
                    ###### Fix script End ######
                    ############################
                    #
                    # restart autodl.
                    screen -wipe > /dev/null 2>&1
                    screen -dmS autodl-"$suffix" irssi --home="$HOME"/.irssi-"$suffix"/
                    # Send a command to the new screen telling Autodl to update itself. This basically generates the ~/.autodl/AutodlState.xml files with updated info.
                    screen -S autodl-"$suffix" -p 0 -X stuff '/autodl update^M'
                    #
                    ############################
                    ############################
                    ############################
                    echo -e "rutorrent-$suffix and autodl-$suffix have been updated."
                    echo
                    sleep 3
                else 
                    echo -e "\033[31m""No matching autodl instances exist. Try again.""\e[0m"
                    echo
                    sleep 3
                fi
            fi
        ;;
        "3")
            functiontwo
            #
            if [[ "$suffix" != "none" ]]
            then
                kill -9 $(screen -ls rtorrent | sed -rn 's/(.*).rtorrent-(.*)/\1/p')  > /dev/null 2>&1
                kill -9 $(screen -ls autodl | sed -rn 's/(.*).autodl-(.*)/\1/p')  > /dev/null 2>&1
                screen -wipe > /dev/null 2>&1
                #
                echo -e "\033[32m""Custom instance has been shutdown: if it was running""\e[0m"
                echo
                if [[ -f ~/.rtorrent-"$suffix".rc ]]
                then
                    rm -f ~/.rtorrent-"$suffix".rc
                    echo "~/.rtorrent-$suffix.rc has been removed"
                    echo
                else
                    echo "~/.rtorrent-$suffix.rc file not found, skipping"
                    echo
                fi
                #
                if [[ -d ~/private/rtorrent-"$suffix" ]]
                then
                    rm -rf ~/private/rtorrent-"$suffix"
                    echo "~/private/rtorrent-$suffix has been removed"
                    echo
                else
                    echo "~/private/rtorrent-$suffix not found, skipping"
                    echo
                fi
                #
                if [[ -d ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix" ]]
                then
                    rm -rf ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"
                    echo "~/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix has been removed"
                    echo
                else
                    echo "~/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix not found, skipping"
                    echo
                fi
                if [[ -d ~/.irssi-"$suffix" ]]
                then
                    rm -rf ~/.irssi-"$suffix"
                    echo "~/.irssi-$suffix has been removed"
                    echo
                else
                    echo "~/.irssi-$suffix not found, skipping"
                    echo
                fi
                if [[ -d ~/.autodl-"$suffix" ]]
                then
                    rm -rf ~/.autodl-"$suffix"
                    echo "~/.autodl-$suffix has been removed"
                    echo
                else
                    echo "~/.autodl-$suffix not found, skipping"
                    echo
                fi
                #
                if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                then
                    rm -f ~/.nginx/conf.d/000-default-server.d/scgi-"$suffix"-htpasswd
                    rm -f ~/.nginx/conf.d/000-default-server.d/rtorrent-"$suffix".conf
                    rm -f ~/.nginx/conf.d/000-default-server.d/rtorrent-"$suffix"-rpc.conf
                    /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                    echo "Nginx related files have been removed and nginx has been reloaded"
                    echo
                fi
                if [[ -f ~/.userdocs/multirtru.restart.txt ]]
                then
                    sed -i '/screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~\/.rtorrent-'"$suffix"'.rc/d' ~/.userdocs/multirtru.restart.txt
                    sed -i '/screen -dmS autodl-'"$suffix"' irssi --home=$HOME\/.irssi-'"$suffix"'\//d' ~/.userdocs/multirtru.restart.txt
                    sed -i '/^$/d' ~/.userdocs/multirtru.restart.txt
                fi
                #
                appname="rtorrent-$suffix"
                cronjobremove
                appname="autodl-$suffix"
                cronjobremove
                #
                if [ "$(crontab -l 2> /dev/null | grep -c 'screen -dmS autodl-'"$suffix"' irssi --home=$HOME/.irssi-'"$suffix")" == "0" ]
                then
                    echo "This instance was not setup in crontab, skipping"
                    echo
                else
                    tmpcron="$(mktemp)"
                    crontab -l > $tmpcron 
                    sed -i '/screen -dmS autodl-'"$suffix"' irssi --home=$HOME\/.irssi-'"$suffix"'/d' $tmpcron
                    crontab "$tmpcron"
                    rm "$tmpcron"
                    echo "This instance of autodl-irssi has been removed from crontab"
                    echo
                fi
                # 
                if [ "$(crontab -l 2> /dev/null | grep -c 'screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~/.rtorrent-'"$suffix"'.rc')" == "0" ]
                then
                    echo "This instance was not setup in crontab, skipping"
                    echo
                else
                    tmpcron="$(mktemp)"
                    crontab -l > $tmpcron 
                    sed -i '/@reboot screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~\/.rtorrent-'"$suffix"'.rc/d' $tmpcron
                    crontab "$tmpcron"
                    rm "$tmpcron"
                    echo "This instance has been removed from crontab"
                    echo
                fi
                #
                echo -e "\033[31m""Done""\e[0m"
                echo
                sleep 3
            fi
        ;;
        "4")
            functiontwo
            #
            if [[ "$suffix" != "none" ]]
            then
                if [[ -d "$HOME/.irssi-$suffix/scripts/AutodlIrssi" ]]
                then
                    echo -e "\033[33m""Autodl Before""\e[0m"
                    echo -e "\033[32m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm =" "\033[31m""$(sed -n "s/use constant LISTEN_ADDRESS => '\(.*\)';/\1/p" $HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm 2> /dev/null)""\e[0m"
                    echo -e "\033[32m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm Result 1 =" "\033[31m""$(sed -n 's/\(.*\)$rtAddress = "\(.*\)$rtAddress" if $rtAddress =~ \/^:\\d{1,5}$\/;/\2/p' $HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm 2> /dev/null)""\e[0m"
                    echo -e "\033[32m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm Result 2 =" "\033[31m""$(sed -n 's/\(.*\)my $scgi = new AutodlIrssi::Scgi($rtAddress, {REMOTE_ADDR => "\(.*\)"});/\2/p' $HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm 2> /dev/null)""\e[0m" 
                    echo
                    #
                    echo -e "\033[31m""Applying some fixes to autodl if needed.""\e[0m"
                    echo
                    sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm"
                    sed -i "s/use constant LISTEN_ADDRESS => '127.0.0.1';/use constant LISTEN_ADDRESS => '10.0.0.1';/g" "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm"
                    sed -i 's|$rtAddress = "127.0.0.1$rtAddress"|$rtAddress = "10.0.0.1$rtAddress"|g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm"
                    sed -i 's/my $scgi = new AutodlIrssi::Scgi($rtAddress, {REMOTE_ADDR => "127.0.0.1"});/my $scgi = new AutodlIrssi::Scgi($rtAddress, {REMOTE_ADDR => "10.0.0.1"});/g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm"
                    #
                    echo -e "\033[33m""Autodl After""\e[0m"
                    echo -e "\033[32m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm =" "\033[31m""$(sed -n "s/use constant LISTEN_ADDRESS => '\(.*\)';/\1/p" $HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm 2> /dev/null)""\e[0m"
                    echo -e "\033[32m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm Result 1 =" "\033[31m""$(sed -n 's/\(.*\)$rtAddress = "\(.*\)$rtAddress" if $rtAddress =~ \/^:\\d{1,5}$\/;/\2/p' $HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm 2> /dev/null)""\e[0m"
                    echo -e "\033[32m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm Result 2 =" "\033[31m""$(sed -n 's/\(.*\)my $scgi = new AutodlIrssi::Scgi($rtAddress, {REMOTE_ADDR => "\(.*\)"});/\2/p' $HOME/.irssi-$suffix/scripts/AutodlIrssi/MatchedRelease.pm 2> /dev/null)""\e[0m" 
                    echo
                    #
                    if [[ -f ~/.autodl-"$suffix"/autodl.cfg ]]
                    then
                        cp -f ~/.autodl-"$suffix"/autodl.cfg ~/.autodl-"$suffix"/autodl.cfg.bak-$(date +"%d.%m.%y@%H:%M:%S")
                    fi
                    # If the autodl.cfg exists we use sed to update the existing username and pass with the ones the script has generated.
                    # else we use and echo to create our autodl.cfg file. Takes the two previously made variables, $appport and $apppass to update/create the required info.
                    if [[ -f ~/.autodl-"$suffix"/autodl.cfg ]]
                    then
                        if [[ $(tr -d "\r\n" < ~/.autodl-"$suffix"/autodl.cfg | wc -c) -eq "0" ]]
                        then
                            echo -e "[options]\ngui-server-port = $appport\ngui-server-password = $apppass" > ~/.autodl-"$suffix"/autodl.cfg
                        else
                            # Sed command to enter the port variable
                            sed -ri 's|(.*)gui-server-port =(.*)|gui-server-port = '"$appport"'|g' ~/.autodl-"$suffix"/autodl.cfg
                            # Sed command to enter the password variable
                            sed -ri 's|(.*)gui-server-password =(.*)|gui-server-password = '"$apppass"'|g' ~/.autodl-"$suffix"/autodl.cfg
                        fi
                    else 
                        echo -e "[options]\ngui-server-port = $appport\ngui-server-password = $apppass" > ~/.autodl-"$suffix"/autodl.cfg
                    fi
                    #
                else
                    echo -e "\033[36m""$HOME/.irssi-$suffix/scripts/AutodlIrssi/""\e[0m" "does not exist"
                    echo
                fi
                #
                if [[ -d "$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/plugins/autodl-irssi" ]]
                then
                    echo -e "\033[33m""Autodl-rutorrent Before""\e[0m"
                    echo -e "\033[32m""/rutorrent-$suffix/plugins/autodl-irssi/getConf.php =" "\033[31m""$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/autodl-irssi/getConf.php 2> /dev/null)""\e[0m"
                    echo
                    #
                    echo -e "\033[31m""Applying some fixes to autodl rutorrent plugin if needed.""\e[0m"
                    echo
                    sed -i 's/if (!socket_connect($socket, "127.0.0.1", $autodlPort))/if (!socket_connect($socket, "10.0.0.1", $autodlPort))/g' "$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
                    echo -e "\033[33m""Autodl-rutorrent After""\e[0m"
                    echo -e "\033[32m""/rutorrent/plugins/autodl-irssi/getConf.php =" "\033[31m""$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/plugins/autodl-irssi/getConf.php 2> /dev/null)""\e[0m"
                    echo
                    # Uses echo to make the config file for the rutorrent plugun to work with autodl using the variables port and pass
                    echo -ne '<?php\n$autodlPort = '"$appport"';\n$autodlPassword = "'"$apppass"'";\n?>' > ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/conf.php
                    #
                else
                    echo -e "\033[36m""$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/plugins/autodl-irssi/""\e[0m" "does not exist"
                    echo
                    exit
                fi
                kill -9 $(screen -ls autodl | sed -rn 's/(.*).autodl-(.*)/\1/p')  > /dev/null 2>&1
                screen -wipe > /dev/null 2>&1
                screen -dmS autodl-"$suffix" irssi --home="$HOME"/.irssi-"$suffix"/
                echo -e "\033[33m""Checking we restarted irssi or if there are multiple screens/processes""\e[0m"
                echo
                echo $(screen -ls | grep autodl-"$suffix")
                echo
                echo -e "Done. Please refresh/reload rutorrent using CTRL + F5"
                echo
                echo -e "This fix might have to be run each time you update/overwrite the autodl or autodl-rutorrent files."
                echo
                sleep 3
            fi
        ;;
        "5")
            echo "You chose to quit the script."
            echo
            exit
        ;;
    esac
done
