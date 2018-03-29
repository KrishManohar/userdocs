prerequisites () {
    mkdir -p ~/bin
    mkdir -p ~/.userdocs/{versions,cronjobs,logins,logs,pids,tmp}
    #
    [[ $(echo "$PATH" | grep -oc ~/bin) -eq "0" ]] && export PATH=~/bin:"$PATH"
	[[ $(echo "$TMPDIR" | grep -oc ~/.userdocs/tmp) -eq "0" ]] && export TMPDIR="$HOME/.userdocs/tmp"
    #
    echo 'This is a folder generated by the userdocs installation scripts that you may have used to house important information or components of the script.' > ~/.userdocs/readme.txt
}
#
functionone () {
    if [[ -f ~/.userdocs/multirtru.restart.txt && -s ~/.userdocs/multirtru.restart.txt ]]
    then
        echo -e "\033[32m""Existing custom installations read from the ~/.userdocs/multirtru.restart.txt""\e[0m"
        echo
        sed -rn "s/screen -fa -dmS rtorrent-(.*) rtorrent -n -o import=\~\/.rtorrent-(.*).rc/\2/p" ~/.userdocs/multirtru.restart.txt
        echo
    else
        echo "No instances to show when checking the ~/.userdocs/multirtru.restart.txt"
        echo
        echo -e "To return to the menu type: ""\033[32m""none""\e[0m"
        echo
    fi
}
#
functiontwo () {
    suffix=""
    functionone
    while [[ -z "$suffix" ]]
    do
        read -ep "What is the name of suffix you wish to modify?: " suffix
        echo
    done
}
#
installrtorrent () {
	mkdir -p "$HOME/private/rtorrent-$suffix/data" "$HOME/private/rtorrent-$suffix/watch" "$HOME/private/rtorrent-$suffix/work"
	wget -qO "$HOME/.rtorrent-$suffix.rc" "$confurl"
	sed -i 's|/media/DiskID/home/username/private/rtorrent/|'"$HOME"'/private/rtorrent-'"$suffix"'/|g' "$HOME/.rtorrent-$suffix.rc"
	sed -i 's|/media/DiskID/home/username/www/username.server.feralhosting.com/public_html/rutorrent/php/initplugins.php username|'"$HOME"'/www/'"$(whoami)"'.'"$(hostname -f)"'/public_html/rutorrent-'"$suffix"'/php/initplugins.php '"$(whoami)"'|g' "$HOME/.rtorrent-$suffix.rc"
	echo 'screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~/.rtorrent-'"$suffix"'.rc' >> "$HOME/.userdocs/multirtru.restart.txt"
}
#
installrutorrent () {
	git clone "$rutorrentmaster" "$wwwurl/rutorrent-$suffix"
	wget -qO "$wwwurl/rutorrent-$suffix/conf/config.php" "$rutorrentconf"
	sed -i 's|/private/rtorrent/.socket|/private/rtorrent-'"$suffix"'/.socket|g' "$wwwurl/rutorrent-$suffix/conf/config.php"
    mkdir -p "$wwwurl/rutorrent-$suffix/share/torrents"
	rm -rf "$wwwurl/rutorrent-$suffix/plugins/{cpuload,diskspace}"
}
#
installrutorrentratiocolour () {    
    wget -qO "$wwwurl/rutorrent-$suffix/plugins/ratiocolor.zip" "$ratiocolor"
    unzip -qo "$wwwurl/rutorrent-$suffix/plugins/ratiocolor.zip" -d "$wwwurl/rutorrent-$suffix/plugins/"
    mv "$wwwurl/rutorrent-$suffix/plugins/rutorrent-ratiocolor-master" "$wwwurl/rutorrent-$suffix/plugins/ratiocolor"
    #
    if [[ -f "$wwwurl/rutorrent-$suffix/plugins/ratiocolor.zip" ]]; then 
        rm -rf "$wwwurl/rutorrent-$suffix/plugins/ratiocolor.zip" "$wwwurl/rutorrent-$suffix/plugins/rutorrent-ratiocolor-master"
    fi
    if [[ -d "$wwwurl/rutorrent-$suffix/plugins/rutorrent-ratiocolor-master" ]]; then 
        rm -rf "$wwwurl/rutorrent-$suffix/plugins/rutorrent-ratiocolor-master"
    fi
}
#
installautodl () {
    mkdir -p ~/{.autodl-"$suffix",.irssi-"$suffix"/scripts/autorun}
    wget -qO ~/autodl-irssi.zip "$autodlirssicommunity"
    wget -qO ~/autodl-trackers.zip "$autodltrackers"
    unzip -qo ~/autodl-irssi.zip -d ~/.irssi-"$suffix"/scripts/
    unzip -qo ~/autodl-trackers.zip -d ~/.irssi-"$suffix"/scripts/AutodlIrssi/trackers/
    cp -f ~/.irssi-"$suffix"/scripts/autodl-irssi.pl ~/.irssi-"$suffix"/scripts/autorun/
    rm -f ~/autodl-{irssi,trackers}.zip ~/.irssi-"$suffix"/scripts/{README*,CONTRIBUTING.md,autodl-irssi.pl}
    echo -e "[options]\ngui-server-port = $appport\ngui-server-password = $autodlpass\nrt-address = $HOME/private/rtorrent-$suffix/.socket\nupload-type = watchdir\nupload-watch-dir = $HOME/private/rtorrent-$suffix/watch/" > ~/.autodl-"$suffix"/autodl.cfg
}
#
installautodlrutorrent () {
	mkdir -p "$wwwurl/rutorrent-$suffix/plugins"
	wget -qO ~/autodl-rutorrent.zip "$autodlrutorrent"
	unzip -qo ~/autodl-rutorrent.zip -d "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi"
	cd && rm -rf autodl-rutorrent{-master,.zip}
	echo -ne '<?php\n$autodlPort = '"$appport"';\n$autodlPassword = "'"$autodlpass"'";\n?>' > "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/conf.php"
}
#
autodlfix () {
	sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' "$HOME/.irssi-$suffix/scripts/AutodlIrssi/Dirs.pm"
	sed -i "s|use constant LISTEN_ADDRESS => '127.0.0.1';|use constant LISTEN_ADDRESS => '10.0.0.1';|g" "$HOME/.irssi-$suffix/scripts/AutodlIrssi/GuiServer.pm"
	#
	sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
	sed -i "s|'/.autodl/autodl.cfg'|'/.autodl-$suffix/autodl.cfg'|g" "$wwwurl/rutorrent-$suffix/plugins/autodl-irssi/getConf.php"
}
#
autodlstart (){
	if [[ -d "$HOME/.autodl-$suffix" && "$HOME/.irssi-$suffix" ]]
	then
		screen -wipe > /dev/null 2>&1
		screen -dmS autodl-"$suffix" irssi --home="$HOME"/.irssi-"$suffix"/
		echo 'screen -dmS autodl-'"$suffix"' irssi --home=$HOME/.irssi-'"$suffix"'/' >> ~/.userdocs/multirtru.restart.txt
		# Send a command to the new screen telling Autodl to update itself. This basically generates the ~/.autodl/AutodlState.xml files with updated info.
		screen -S autodl-"$suffix" -p 0 -X stuff '/autodl update^M'
	fi
}
#
genericstart () {
    if [[ -d ~/.autodl-"$suffix" && ~/.irssi-"$suffix" ]]
        then
        echo -e "\033[32m""Checking we have started irssi or if there are multiple screens/processes""\e[0m"
        echo
        echo -e "\033[31m"$(screen -ls | grep autodl-"$suffix")"\e[0m"
        echo
        echo -e "You can attach to the screen using this command: ""\033[32m""screen -r autodl-$suffix""\e[0m"
        echo
    fi
    echo -e "\033[32m""5:""\e[0m" "Creating the screen process"
    echo
    #
    screen -fa -dmS rtorrent-"$suffix" rtorrent -n -o import=~/.rtorrent-"$suffix".rc
    #
    echo -e "\033[32m""This command was added to""\e[0m" "\033[36m""~/.userdocs/multirtru.restart.txt""\e[0m" "\033[32m""so you can easily restart this instance""\e[0m"
    echo
    echo -e "To reattach to this screen type: ""\033[33m""screen -r rtorrent-$suffix""\e[0m"
    echo
    echo -e "Is it running? ""\033[33m"$(screen -ls | grep rtorrent-"$suffix")"\e[0m"
    echo
    echo -e "The username for this instance is:" "\033[32m""$username""\e[0m"
    echo
    echo -e "Visit this URL to see your new instance:"
    echo
    echo -e "\033[32m""https://$username:$apppass@$(hostname -f)/$(whoami)/rutorrent-$suffix/""\e[0m"
    echo
    echo -e "Your password for ""\033[32m""rutorrent-$suffix""\e[0m" "is" "\033[32m""$apppass""\e[0m" "Please make a note of this password now."
    echo
    echo -e "If you forget the pass you will have to use the script in this FAQ - https://www.feralhosting.com/faq/view?question=22"
    echo
    echo -e "\033[33m""Don't forget, you can manage your passwords with this FAQ:""\e[0m" "\033[36m""https://www.feralhosting.com/faq/view?question=22""\e[0m"
    echo
}
#
passwordprotect () {
    echo -e "\033[31m""4:""\e[0m" "Password Protect the Installation"
    echo
    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
    then
        echo -e 'location /rutorrent-'"$suffix"' {\n    auth_basic "rutorrent-'"$suffix"'";\n    auth_basic_user_file '"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/rutorrent-'"$suffix"'/.htpasswd;\n}\n\nlocation /rutorrent-'"$suffix"'/conf { deny all; }\nlocation /rutorrent-'"$suffix"'/share { deny all; }' > ~/.nginx/conf.d/000-default-server.d/rtorrent-"$suffix".conf
        echo -e 'location /rtorrent-'"$suffix"'/rpc {\n    include   /etc/nginx/scgi_params;\n    scgi_pass unix://'"$HOME"'/private/rtorrent-'"$suffix"'/.socket;\n\n    auth_basic '\''rtorrent SCGI for rutorrent-'"$suffix"''\'';\n    auth_basic_user_file conf.d/000-default-server.d/scgi-'"$suffix"'-htpasswd;\n}' > ~/.nginx/conf.d/000-default-server.d/rtorrent-"$suffix"-rpc.conf
        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
    fi
    #
    echo -e 'AuthType Basic\nAuthName "rtorrent-'"$suffix"'"\nAuthUserFile "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/rutorrent-'"$suffix"'/.htpasswd"\nRequire valid-user' > $wwwurl/rutorrent-"$suffix"/.htaccess
    chmod 644 $wwwurl/rutorrent-"$suffix"/.htaccess
    #
    while [[ -z "$username" ]]
    do
        read -ep "Please give me a username for the user we are creating: " -i "rutorrent-$suffix" username
    done
    #
    echo
    echo -e "Generating a random 20 character random password for the user:" "\033[32m""$username""\e[0m"
    echo
    #
    htpasswd -cbm $wwwurl/rutorrent-"$suffix"/.htpasswd "$username" "$apppass"
    chmod 644 $wwwurl/rutorrent-"$suffix"/.htpasswd
    echo
    #
    # nginx copy rutorrent-suffix htpasswd to create the rpc htpasswd file.
    #
    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
    then
        cp -f $wwwurl/rutorrent-"$suffix"/.htpasswd ~/.nginx/conf.d/000-default-server.d/scgi-"$suffix"-htpasswd
        sed -i 's/\(.*\):\(.*\)/rutorrent:\2/g' ~/.nginx/conf.d/000-default-server.d/scgi-"$suffix"-htpasswd
    fi
    #
}
#