#!/bin/bash
#
# fiximus maximus
#
# Please set the path to your www root here.
wwwurl="$HOME/www/$(whoami).$(hostname -f)/public_html"
#
autodlfix="$(sed -rn "s#(.*)'(.*)';#\2#p" ~/.irssi/scripts/AutodlIrssi/GuiServer.pm)"
rutorrentfix="$(sed -n 's/\(.*\)if (\!socket_connect($socket, "\(.*\)", $autodlPort))/\2/p' $wwwurl/rutorrent/plugins/autodl-irssi/getConf.php)"
#
# Autodl ~/.irssi/scripts/AutodlIrssi/GuiServer.pm
[[ "$autodlfix" = '127.0.0.1' ]] && sed -i "s|'127.0.0.1';|'10.0.0.1';|g" ~/.irssi/scripts/AutodlIrssi/GuiServer.pm
#
# Autodl Rutorrent 
[[ "$rutorrentfix" = '127.0.0.1' ]] && sed -i 's|if (!socket_connect($socket, "127.0.0.1", $autodlPort))|if (!socket_connect($socket, "10.0.0.1", $autodlPort))|g' "$wwwurl/rutorrent/plugins/autodl-irssi/getConf.php"
#
exit