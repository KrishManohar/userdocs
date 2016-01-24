
lftp on Windows using Cygwin.
---

Here you will be guided on using `lftp` on Windows via Cygwin.

> **Imortant note:** A prerequisite of this tutorial is that you have followed and successfully completed this tutorial - [Installing Cygwin on Windows using lftp as an example.](https://github.com/userdocs/file-transfer/blob/master/Windows/Cygwin/readme.md)

Using lftp
---

The usage of `lftp` in this guide will require two things from you.

**1:** That you enter some commands via the Cygwin terminal accessed by the short-cut you created on your desktop in the Cygwin guide. There is no user interface for `lftp`. This has been made as simple as possible so read on.

**Important note:** We are going to use a pre configured `rc` file for this tutorial. You can customise it to meets your needs when you better know them.

**2:** That you download and customise some settings and aliases in the `~/.lftp/rc` file. This will be part of the guide.

Before using lftp
---

Open the Cygwin terminal.

Now create the folder we require for the `rc` file with this command.

~~~
mkdir -p ~/.lftp
~~~

Now download the customised `rc` file to the correct location using this command.

~~~
wget -qO ~/.lftp/rc https://git.io/vz3bI
~~~

You will now have a basic `rc` file that looks like this:

~~~
set sftp:auto-confirm yes
set color:use-color auto
set bmk:save-password true
set cmd:default-protocol sftp
set mirror:parallel-transfer-count 1
set mirror:use-pget-n 20
set pget:default-n 20
set cmd:prompt "lftp \[\e[01;32m\]\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\] % "

alias pg pget -c
alias m mirror -c
~~~

You can edit it with `nano` if you need to but for now I recommend you just leave it as it is.

~~~
nano ~/.lftp/rc
~~~

If you did edit it, once you are done editing the `rc` file press and hold `CTRL` and then press `x` to save. Press `y` to confirm.

Connecting via sftp
---

We will be using `SFTP` as the default method for connecting and assuming the `SSH` port is `22`.

This is the general format for the command we will use combined with our `rc` defaults. Where `username` is your `sftp` username and `hostname.com` is the hostname or IP of your server.

~~~
lftp username@hostname.com
~~~

You will then see a prompt to enter your `sftp` password.

**Important note:** You can right click and select paste but you will not see anything pasted. This is normal.

~~~
password:
~~~

When you have entered your password you can test to see if you are successfully connected to the remote host by using the command

~~~
ls
~~~

You should see a file listing of your remote server. If you do not see your files or get an error please check your connection information.

Once successfully connected do this command (where `server` is the name of the bookmark you wish to create)

~~~
bookmark add server
~~~

Now use this command to check it was saved:

~~~
bookmark list
~~~

Now it should be as simple as using this command to connect  (where `server` is the name of the bookmark you just created):

~~~
lftp server
~~~

Downloading files and folders using lftp
---

Once you have successfully connected to a server you can now download using `lftp`.

The two commands you will need to use are:

**Important note:** These commands will make use of the defaults we have set in our `rc` file.

`pget` - download a file in parts.

`mirror` - download a folder.

Here are examples of how you will use the commands once connected.

**Important note:** If there are spaces in the name of your file or folders you will need to quote the path or file name. You should do this anyway as it won't hurt.

To download a single file.`O ~/"Downloads"` is specifying the local download directory for your files.

~~~
pget -cO ~/"Downloads" ~/"myfile.avi"
~~~

To download the content of a directory. `~/"Downloads"` is the local directory your files will be mirrored to.

~~~
mirror -c ~/"myfolder" ~/"Downloads"
~~~

Uploading files and folders using lftp
---

WIP

Automated Script.
---

Download this script using this command.

~~~
wget -qO ~/lftpsync.sh https://git.io/vzZ74
~~~

Now we must edit to hard code some settings so that we can use the script to continuously sync. We can do that one of two ways. Either by editing the file with a text editor in Windows, like `notepad ++` or by using the Cygwin terminal and `nano`

For Cygwin x86 the file will now be located at (where `username` is your Windows username):

~~~
C:\cygwin\home\username\lftpsync.sh
~~~

For Cygwin x64 the file will now be located at (where `username` is your Windows username):

~~~
C:\cygwin64\home\username\lftpsync.sh
~~~

Optionally - In the terminal use this command:

~~~
nano ~/lftpsync.sh
~~~

This is the section we are interested ina and must edit.

~~~
### Editing options 1 - 4 is required. Editing options 5 - 10 is optional.
#
# 1: Your sftp/ftp username
username="username"
# 2: Your sftp/ftp password
password="password"
# 3: Your seedbox server URL/hostname
hostname="servername.com"
# 4: The remote directory on the seedbox you wish to mirror from. Can now be passed to the script directly using "$1"
remote_dir='~/directory/to/mirror/from'
# 5: Optional - The local directory your files will be mirrored to. Will be created if it does not exist so the default setting will work.
local_dir="$HOME/lftp-mirrored"
# 6: Optional - Set the SSH port if yours is not the default.
port="22"
#
# 7: Optional - The number of parallel files to download. It is set to download 1 file at a time.
parallel="1"
# 8: Optional - set maximum number of connections lftp can open
default_pget="20"
# 9: Optional - Set the number of connections per file lftp can open
pget_mirror="20"
# 10: Optional - Add custom arguments or flags here.
args="-c -e"
~~~

Once you have edited this section and saved the script you can run it.

~~~
bash ~/lftpsync.sh
~~~

If it works correctly you can exit the script by pressing and holding `CTRL` and then pressing `c`.Now run it in a screen using this command.

~~~
screen -dmS lftpsync ~/lftpsync.sh
~~~

Attach to this screen using:

~~~
screen -r lftpsync
~~~

Then press and hold `CTRL` and `a` then press `d` to detach from the screen. This leaves it running in the background.

Crontab
---

WIP