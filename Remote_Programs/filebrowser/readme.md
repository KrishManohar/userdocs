# Filebrowser - Feralhosting

[https://github.com/filebrowser/filebrowser](https://github.com/filebrowser/filebrowser)

This program is not like h5ai. h5ai is a "modern file indexer for HTTP web servers" that runs from your WWW directory powered by apache or nginx. It does something different 

What this does is allow you to manage your slot files directly from the web browser since it runs via ssh and is proxypassed using nginx in this example.

You can create separate configured instances that limit to a specific folder using SCOPE. Then you can create users with limited permissions to access the data in that folder via a browser.

[https://filebrowser.github.io/configuration/](https://filebrowser.github.io/configuration/)

The setup is this:

Binary run from the ~/bin directory in a screen.

We point the binary to configuration file in `~/.config/filebrowser` using `-c` ( but this is optional as you can do all this via the command switches directly )

We proxypass it using nginx to be available by https only.

The below commands can be copy and pasted and will download, install and configure filebrowser with nginx on Feralhosting. The commands canbe tweaked to work with other providers.

~~~bash
mkdir -p ~/.config/filebrowser
wget -qO ~/.config/filebrowser/filebrowser.json https://git.io/fxQGc
wget -qO ~/filebrowser.tar.gz $(curl -sNL https://git.io/fxQ38 | grep -P 'browser(.*)linux-amd64-filebrowser.tar.gz' | cut -d\" -f4)
tar xf ~/filebrowser.tar.gz --exclude LICENSE --exclude README.md -C ~/bin
#
# Proxypass
wget -qO ~/.nginx/conf.d/000-default-server.d/filebrowser.conf https://git.io/vpSav
sed -i 's|# rewrite /(.*) /username/$1 break;|rewrite /(.*) /username/$1 break;|g' ~/.nginx/conf.d/000-default-server.d/filebrowser.conf
sed -i 's|HOME|'"$HOME"'|g' ~/.nginx/conf.d/000-default-server.d/filebrowser.conf
sed -i 's|generic|filebrowser|g' ~/.nginx/conf.d/000-default-server.d/filebrowser.conf
sed -i 's|username|'"$(whoami)"'|g' ~/.nginx/conf.d/000-default-server.d/filebrowser.conf
#
# Port Generation
appport="$(shuf -i 10001-32001 -n 1)" && while [[ "$(ss -ln | grep -co ''"$appport"'')" -ge "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
sed -i 's|PORT|'"$appport"'|g' ~/.nginx/conf.d/000-default-server.d/filebrowser.conf
sed -i 's|PORT|'"$appport"'|g' ~/.config/filebrowser/filebrowser.json
#
# Configuration
sed -i "s|BASEURL|/$(whoami)/filebrowser|g" ~/.config/filebrowser/filebrowser.json
sed -i "s|CONFIG|$HOME/.config/filebrowser/filebrowser.db|g" ~/.config/filebrowser/filebrowser.json
sed -i "s|LOG|$HOME/.config/filebrowser/filebrowser.log|g" ~/.config/filebrowser/filebrowser.json
sed -i "s|SCOPE|$HOME|g" ~/.config/filebrowser/filebrowser.json
#
# Reload nginx - ignore the errors
/usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf 2> /dev/null
#
# Start the program
screen -dmS "filebrowser" && screen -S "filebrowser" -p 0 -X stuff "filebrowser -c $HOME/.config/filebrowser/filebrowser.json^M"
~~~