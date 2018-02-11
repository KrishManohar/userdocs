#!/bin/bash
#
############################
##### Basic Info Start #####
############################
#
# Install ruTorrent 3.8 from github repo
git clone https://github.com/Novik/ruTorrent.git ~/.userdocs/tmp/rutorrent
wget -qO ~/.userdocs/tmp/rutorrent/conf/config.php https://raw.githubusercontent.com/userdocs/userdocs/master/Remote_Programs/rutorrent/conf/config.php
cp -f ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/.{htaccess,htpasswd} ~/.userdocs/tmp/rutorrent/
rm -rf ~/www/$(whoami).$(hostname -f)/public_html/rutorrent
mv -f ~/.userdocs/tmp/rutorrent ~/www/$(whoami).$(hostname -f)/public_html/rutorrent
rm -rf ~/.userdocs/tmp/rutorrent
#
# Install ratio color pllugin
wget -qO ~/.userdocs/tmp/ratiocolor.zip https://github.com/Gyran/rutorrent-ratiocolor/archive/master.zip
unzip -qo ~/.userdocs/tmp/ratiocolor.zip -d ~/.userdocs/tmp/
mv -f ~/.userdocs/tmp/rutorrent-ratiocolor-master ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/ratiocolor
rm -rf ~/.userdocs/tmp/rutorrent-ratiocolor-master ~/.userdocs/tmp/ratiocolor.zip
#
exit