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