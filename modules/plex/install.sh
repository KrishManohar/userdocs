echo "Welcome to the Feral install plex script."
echo
if [[ -d ~/private/plex ]]; then
    read -ep "Do you want to update to $plexversion [y]es or [n]o: " -i "y" plexupdate
    echo
fi
if [[ "$plexupdate" =~ ^[Yy]$ ]]; then
    #
    wget -qO ~/plex.deb "$plexamd64url"
    #
    dpkg-deb -x ~/plex.deb ~/private/plex
    #
    [[ -f ~/plex.deb ]] && rm -f ~/plex.deb
    #
    pkill -9 -fu "$(whoami)" 'plexmediaserver' > /dev/null 2>&1
    pkill -9 -fu "$(whoami)" 'EAE Service' > /dev/null 2>&1
    #
    if [[ "$(date +%-M)" -le '4' ]] && [[ "$(date +%-M)" -ge '0' ]]; then time="$(( 5 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '9' ]] && [[ "$(date +%-M)" -ge '5' ]]; then time="$(( 10 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '14' ]] && [[ "$(date +%-M)" -ge '10' ]]; then time="$(( 15 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '19' ]] && [[ "$(date +%-M)" -ge '15' ]]; then time="$(( 20 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '24' ]] && [[ "$(date +%-M)" -ge '20' ]]; then time="$(( 25 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '29' ]] && [[ "$(date +%-M)" -ge '25' ]]; then time="$(( 30 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '34' ]] && [[ "$(date +%-M)" -ge '30' ]]; then time="$(( 35 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '39' ]] && [[ "$(date +%-M)" -ge '35' ]]; then time="$(( 40 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '44' ]] && [[ "$(date +%-M)" -ge '40' ]]; then time="$(( 45 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '49' ]] && [[ "$(date +%-M)" -ge '45' ]]; then time="$(( 50 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '54' ]] && [[ "$(date +%-M)" -ge '50' ]]; then time="$(( 55 * 60 ))"; fi
    if [[ "$(date +%-M)" -le '59' ]] && [[ "$(date +%-M)" -ge '55' ]]; then time="$(( 60 * 60 ))"; fi
    #
    while [[ "$(ps -xU $(whoami) | grep -Ev 'screen (.*) plex' | grep -Ecw "/bin/sh usr/lib/plexmediaserver/start.sh$")" -eq "0" ]]
    do
        countdown="$(( $time-$(($(date +%-M) * 60 + $(date +%-S))) ))"
        printf '\rPlex will restart in approximately: %dm:%ds ' $(($countdown%3600/60)) $(($countdown%60))
    done
    echo -e '\n'
    #
    exit
fi
#
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
read -ep 'What plex version would you like to install (non plex pass): ' -i "$plexversion" plexversion
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
    [[ -d ~/Library ]] && rm -rf ~/Library
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