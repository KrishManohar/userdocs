#
nodejs="$(curl -sN https://nodejs.org/en/download/ | egrep -om 1 'https://nodejs.org/dist/(.*)/node-v(.*)-linux-x64.tar.xz')"
#
function_installnode () {
	echo "Installing nodejs."
	echo
	wget -O ~/.userdocs/tmp/node.js.tar.gz "$nodejs" > ~/.userdocs/logs/node.log 2>&1
	tar xf ~/.userdocs/tmp/node.js.tar.gz --strip-components=1 -C ~/
	cd && rm -rf ~/.userdocs/tmp/node.js.tar.gz
	echo -n "$(~/bin/node -v | sed -rn 's/v(.*)/\1/p')" > ~/.userdocs/versions/node.version
	# ~/bin/npm install forever -g >> ~/.userdocs/logs/node-forever.log 2>&1
	echo "Nodejs $(~/bin/node -v | sed -rn 's/v(.*)/\1/p') has been installed"
	echo
}
#