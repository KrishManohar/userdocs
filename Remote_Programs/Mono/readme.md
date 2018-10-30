# Install Monoapps.

This script provides a degree of automation to installing, running, updating and removing some mono related applications on a Feral slot.

All applications are https proxypassed with Apache or Nginx and cronjobs are created to restart them.

Running an option again post installation will update and offer the option to remove the application.

Dependencies installed when required - libtool / sqlite

- Mono - Will always use the latest mono stable release.
- Sonarr - Will always use the latest stable release
- Radarr - Will always use the latest stable release
- Lidarr - Will always use the latest appveyor build until an official release is present
- Jackett - Will always use the latest stable release
- Emby - Will always use the latest stable release (amd64 version)

enjoy.

Run this command in ssh to use the script.

~~~
bash <(curl -sL https://git.io/vzyZ4)
~~~