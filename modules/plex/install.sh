echo "Welcome to the Feral install plex script."
echo
while [[ -z "$username" ]]
do
    read -ep "Enter your plex account username: " username
    echo
done
#
while [[ -z "$password" ]]
do
    read -ep "Enter your plex account password: " password
    echo
done
#
echo -e "\033[33m""You can check the latest version here:""\e[0m" 'https://www.plex.tv/downloads/'
echo
#
read -ep 'What plex version would you like to install (non plex pass): ' -i '1.12.1.4885-1046ba85f' plexversion
echo
#
echo -e "\033[33m""Your username is:""\e[0m" "$username"
echo
echo -e "\033[33m""Your password is:""\e[0m" "$password"
echo
read -ep "Are these details correct, [y]es [n]o to reload this script and start again or [q]uit: " confirm
echo
#
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    #
    pkill -9 -fu "$(whoami)" 'plexmediaserver' > /dev/null 2>&1
    pkill -9 -fu "$(whoami)" 'EAE Service' > /dev/null 2>&1
    #
    mkdir -p ~/.config/feral/ns/forwarding/tcp
    grep -l 32400 ~/.config/feral/ns/forwarding/tcp/* | xargs rm -f > /dev/null 2>&1
    #
    [[ -d ~/Library ]] &&  rm -rf ~/Library
    [[ -d ~/private/plex ]] && rm -rf ~/private/plex
    #
    mkdir -p ~/private/plex
    #
    echo "$plexversion" > ~/private/plex/.version
    echo ''"$username"':'"$password"'' > ~/private/plex.login
    #
    while [ ! -f ~/private/plex.url ]; do printf '\rInstalling plex, please wait (May take up to 10min)...'; sleep 2; done
    echo
    echo -e "\033[33m""Please visit your plex installation on this url:""\e[0m" 
    echo
    [[ -f ~/private/plex.url ]] && echo -e "$(cat ~/private/plex.url)"
    echo
    exit
fi
#
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    bash ~/bin/install.plex
    exit
fi
#
if [[ "$confirm" =~ ^[Qq]$ ]]; then
    echo "You chose to quit the script"
    echo
    exit
fi
#
if [[ "$confirm" =~ ^[^YyQqNn].*?$ ]]; then
    echo -e "\033[31m""A wild kitten walked over the keyboard, i will quit this script to be safe.""\e[0m"
    echo
    exit
fi
#
exit