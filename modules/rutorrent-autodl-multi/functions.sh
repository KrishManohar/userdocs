functionone () {
    if [[ -f ~/multirtru.restart.txt && -s ~/multirtru.restart.txt ]]
    then
        echo -e "\033[32m""Existing custom installations read from the ~/multirtru.restart.txt""\e[0m"
        echo
        sed -rn "s/screen -fa -dmS rtorrent-(.*) rtorrent -n -o import=\~\/.rtorrent-(.*).rc/\2/p" ~/multirtru.restart.txt
        echo
    else
        echo "No instances to show when checking the ~/multirtru.restart.txt"
        echo
        echo -e "To return to the menu type: ""\033[32m""none""\e[0m"
        echo
    fi
}
#
functiontwo () {
    suffix=""
    functionone
    while [[ -z "$suffix" ]]
    do
        read -ep "What is the name of suffix you wish to modify?: " suffix
        echo
    done
}