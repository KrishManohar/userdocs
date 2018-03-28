if [[ ! -z "$1" && "$1" = 'changelog' ]]
then
    echo
    curl -sL "$changelogurl"
	echo
    exit
fi