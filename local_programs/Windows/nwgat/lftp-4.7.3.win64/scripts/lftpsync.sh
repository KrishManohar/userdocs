#!/bin/bash
#
# v1.0.0 nwgat
#
# Credits: A heavily modified version of this idea and script http://www.torrent-invites.com/showthread.php?t=132965
# Authors: Lordhades - Adamaze - userdocs
# Script URL: https://git.io/vzZ51
# wget -qO ~/lftpsync.sh https://git.io/vzZ5X
#
### Editing options 1 - 4 is required. Editing options 5 - 10 is optional.
#
# 1: Your sftp/ftp username
username="username"
# 2: Your sftp/ftp password
password="password"
# 3: Your seedbox server URL/hostname
hostname="servername.com"
# 4: The remote directory on the seedbox you wish to mirror from. Can now be passed to the script directly using "$1". It must exist on the remote server.
remote_dir='~/directory/to/mirror/from'
# 5: Optional - The local directory your files will be mirrored to. It is relative to the portable folder and will be created if it does not exist so the default setting will work.
local_dir="../Downloads"
# 6: Optional - Set the SSH port if yours is not the default.
port="22"
# 7: Optional - The number of parallel files to download. It is set to download 1 file at a time.
parallel="1"
# 8: Optional - set maximum number of connections lftp can open
default_pget="20"
# 9: Optional - Set the number of connections per file lftp can open
pget_mirror="20"
# 10: Optional - Add custom arguments or flags here.
args="-c -e"
# This is so we can pass remote directory path to the script when calling the script. Use single quotes on the path.
[[ ! -z "$1" ]] && remote_dir="$1"
#
base_name="$(basename "$0")"
lock_file="/tmp/$base_name.lock"
trap "rm -f $lock_file" SIGINT SIGTERM
if [[ -e "$lock_file" ]]
#
then
	echo "$base_name is running already."
	exit
else
	touch "$lock_file"
	lftp -p "$port" -u "$username,$password" "sftp://$hostname" <<-EOF
	set sftp:auto-confirm yes
	set mirror:parallel-transfer-count "$parallel"
	set pget:default-n $default_pget
	set mirror:use-pget-n $pget_mirror
	mirror $args --log="../$base_name.log" "$remote_dir" "$local_dir"
	quit
	EOF
	#
	rm -f "$lock_file"
	trap - SIGINT SIGTERM
	exit
fi