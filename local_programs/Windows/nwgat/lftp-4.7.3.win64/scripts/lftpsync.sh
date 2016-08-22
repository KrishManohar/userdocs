#!/bin/bash
#
# v1.0.1 nwgat
#
# Credits: A heavily modified version of this idea and script http://www.torrent-invites.com/showthread.php?t=132965 towards a simplified end user experience.
# Authors: Lordhades - Adamaze - userdocs
# Script URL: https://git.io/v6Mza
# wget -qO ~/lftpsync.sh https://git.io/v6Mza
#
### Editing options 2 - 5 is required. Editing options 5 - 10 is optional. Option 0 is only required if you have set have a private key you wish to use
#
# 0: Optional - Change this if you are on linux to just /tmp as the cuyrrent setup is for the windows solution
tmpdir="../tmp"
# 1: Optional - Set your private keyfile name here to match a keyfile placed in keys/ so that you can logon using a private keyfile. Otherwise leave it blank. Set up guides for private key auth on your host will vary.
keyname=""
# Change this if you are on a unix OS to a directory of your choosing.
keydirectory="../keys"
# 2: Your sftp/ftp username
username="username"
# 3: Your sftp/ftp password. If you have set up a private key file then you can ignore this variable.
password="password"
# 4: Your seedbox server URL/hostname
hostname="servername.com"
# 5: The remote directory on the seedbox you wish to mirror from. Can now be passed to the script directly using "$1". It must exist on the remote server.
remote_dir='~/directory/to/mirror/from'
# 6: Optional - The local directory your files will be mirrored to. It is relative to the portable folder and will be created if it does not exist so the default setting will work.
local_dir="../Downloads"
# 7: Optional - Set the SSH port if yours is not the default.
port="22"
# 8: Optional - The number of parallel files to download. It is set to download 1 file at a time.
parallel="1"
# 9: Optional - set maximum number of connections lftp can open
default_pget="20"
# 10: Optional - Set the number of connections per file lftp can open
pget_mirror="20"
# 11: Optional - Add custom arguments or flags here.
args="-c -e"
# This is so we can pass remote directory path to the script when calling the script. Use single quotes on the path.
[[ ! -z "$1" ]] && remote_dir="$1"
#
base_name="$(basename "$0")"
lock_file="$tmpdir/$base_name.lock"
#
[[ -z $(ps -p $(sed -rn 's/\[(.*)\](.*)/\1/p;1q' $tmpdir/PID 2> /dev/null) 2> /dev/null) ]] && echo "removing lock file"; rm -f "$lock_file"
#
trap "rm -f $lock_file" SIGINT SIGTERM
#
if [[ -f "$lock_file" ]]
#
then
	echo "$base_name is running already."
	exit
else
	touch "$lock_file"
	lftp -e "debug -Tpo $tmpdir/PID 0;set sftp:connect-program ssh -a -x -i $keydirectory/$keyname" -p "$port" -u "$username,$password" "sftp://$hostname" <<-EOF
	set sftp:auto-confirm yes
	set mirror:parallel-transfer-count "$parallel"
	set pget:default-n $default_pget
	set mirror:use-pget-n $pget_mirror
	mirror $args --log="$tmpdir/$base_name.log" "$remote_dir" "$local_dir"
	quit
	EOF
	#
	rm -f $tmpdir/PID
	rm -f "$lock_file"
	trap - SIGINT SIGTERM
	exit
fi
