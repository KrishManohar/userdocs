functionone () {
    if [[ -f ~/multirtru.restart.txt && -s ~/multirtru.restart.txt ]]
    then
        echo -e "\033[32m""Existing custom installations read from the ~/multirtru.restart.txt""\e[0m"
        echo
        sed -rn "s/screen -fa -dmS rtorrent-(.*) rtorrent -n -o import=\~\/.rtorrent-(.*).rc/\2/p" ~/multirtru.restart.txt
        echo
    else
        echo "No instances to show when checking the ~/multirtru.restart.txt"
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
install-autodl () {
	#
	mkdir -p ~/{.autodl-"$suffix",.irssi-"$suffix"/scripts/autorun}
	wget -qO ~/autodl-irssi.zip "$autodlirssicommunity"
	wget -qO ~/autodl-trackers.zip "$autodltrackers"
	unzip -qo ~/autodl-irssi.zip -d ~/.irssi-"$suffix"/scripts/
	unzip -qo ~/autodl-trackers.zip -d ~/.irssi-"$suffix"/scripts/AutodlIrssi/trackers/
	cp -f ~/.irssi-"$suffix"/scripts/autodl-irssi.pl ~/.irssi-"$suffix"/scripts/autorun/
	rm -f ~/autodl-{irssi,trackers}.zip ~/.irssi-"$suffix"/scripts/{README*,CONTRIBUTING.md,autodl-irssi.pl}
	echo -e "[options]\ngui-server-port = $appport\ngui-server-password = $autodlpass\nrt-address = $HOME/private/rtorrent-$suffix/.socket\nupload-type = watchdir\nupload-watch-dir = $HOME/private/rtorrent-$suffix/watch/" > ~/.autodl-"$suffix"/autodl.cfg
	#
}
#
install-autodl-rutorrent () {
	#
	mkdir -p ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins
	wget -qO ~/autodl-rutorrent.zip "$autodlrutorrent"
	unzip -qo ~/autodl-rutorrent.zip -d ~/www/"$(whoami)"."$(hostname -f)"/public_html/rutorrent-"$suffix"/plugins/autodl-irssi
	cd && rm -rf autodl-rutorrent{-master,.zip}
	echo -ne '<?php\n$autodlPort = '"$appport"';\n$autodlPassword = "'"$autodlpass"'";\n?>' > ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/conf.php
	#
}
#
install-rtorrent () {
	#
	mkdir -p "$HOME/private/rtorrent-$suffix/data" "$HOME/private/rtorrent-$suffix/watch" "$HOME/private/rtorrent-$suffix/work"
	wget -qO "$HOME/.rtorrent-$suffix.rc" "$confurl"
	sed -i 's|/media/DiskID/home/username/private/rtorrent/|'"$HOME"'/private/rtorrent-'"$suffix"'/|g' "$HOME/.rtorrent-$suffix.rc"
	sed -i 's|/media/DiskID/home/username/www/username.server.feralhosting.com/public_html/rutorrent/php/initplugins.php username|'"$HOME"'/www/'"$(whoami)"'.'"$(hostname -f)"'/public_html/rutorrent-'"$suffix"'/php/initplugins.php '"$(whoami)"'|g' ~/.rtorrent-"$suffix".rc
	sed -i 's|/private/rtorrent/.socket|/private/rtorrent-'"$suffix"'/.socket|g' "$rutorrentpath/conf/config.php"
	echo 'screen -fa -dmS rtorrent-'"$suffix"' rtorrent -n -o import=~/.rtorrent-'"$suffix"'.rc' >> "$HOME/multirtru.restart.txt"
	#
}
#
install-rutorrent () {
	#
	git clone "$rutorrent-github" "$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix"
	wget -qO "$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/conf/config.php" "$rutorrentconf"
	sed -i 's|/private/rtorrent/.socket|/private/rtorrent-'"$suffix"'/.socket|g' "$rutorrentpath/conf/config.php"
	rm -rf "$rutorrentpath/plugins/{cpuload,diskspace}"
	#
}
install-rutorrent-ratiocolour () {
	#
	wget -qO "$rutorrentpath/plugins/ratiocolor.zip" "$ratiocolor"
	unzip -qo "$rutorrentpath/plugins/ratiocolor.zip" -d "$rutorrentpath/plugins/"
	mv "$rutorrentpath/plugins/rutorrent-ratiocolor-master" "$rutorrentpath/plugins/ratiocolor"
	rm -rf "$rutorrentpath/plugins/ratiocolor.zip" "$rutorrentpath/plugins/rutorrent-ratiocolor-master"
	#
}
#
autodl-fix () {
	#
	sed -i 's|return File::Spec->catfile(getHomeDir(), ".autodl");|return File::Spec->catfile(getHomeDir(), ".autodl-'"$suffix"'");|g' ~/.irssi-"$suffix"/scripts/AutodlIrssi/Dirs.pm
	sed -i "s|use constant LISTEN_ADDRESS => '127.0.0.1';|use constant LISTEN_ADDRESS => '10.0.0.1';|g" ~/.irssi-"$suffix"/scripts/AutodlIrssi/GuiServer.pm
	#
	sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/getConf.php
	sed -i "s|'/.autodl/autodl.cfg'|'/.autodl-$suffix/autodl.cfg'|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-"$suffix"/plugins/autodl-irssi/getConf.php
	#
}