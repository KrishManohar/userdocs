if [[ ! -z "$1" && "$1" = 'deleteuser' ]]
then
    if [[ -d ~/proftpd && -f ~/proftpd/bin/ftpasswd ]]
    then
    echo -e "\033[32m""Available users before:""\e[0m"
    echo
    echo -e "\033[33m""$(cat ~/proftpd/etc/ftpd.passwd | cut -d ':' -f1)""\e[0m"
    echo
    passwdfile="$HOME/proftpd/etc/ftpd.passwd"
    groupdfile="$HOME/proftpd/etc/ftpd.group"
    binarycmd="$HOME/proftpd/bin/ftpasswd"
    #
    if [ -n "$2" ]
    then
        echo -e "Using ""\033[32m""$2""\e[0m"" for name."
        name="$2"
        echo
    else
        read -ep "Please input username: " name
        echo
    fi
    "$binarycmd" --passwd --name="$name" --delete-user --file="$passwdfile"
    "$binarycmd" --group --name="$name" --delete-group --file="$groupdfile"
    #
    rm -f ~/.userdocs/logins/"$name"."$(hostname -f)".xml
    #
    echo
    echo -e "\033[32m""Available users after:""\e[0m"
    echo
    echo -e "\033[33m""$(cat ~/proftpd/etc/ftpd.passwd | cut -d ':' -f1)""\e[0m"
    echo
    echo "User deleted."
    echo
    exit
    fi
fi
#
if [[ -n "$1" && "$1" = 'adduser' ]]
then
    if [[ -d ~/proftpd && -f ~/proftpd/bin/ftpasswd ]]
    then
        #
        # Edit below this line
        #
        # made by finesse for feral hosting FAQ
        # use as you like
        # no warranties
        passwdfile="$HOME/proftpd/etc/ftpd.passwd"
        groupdfile="$HOME/proftpd/etc/ftpd.group"
        binarycmd="$HOME/proftpd/bin/ftpasswd"
        idcount=5001
        exec 6<&0
        exec 0<"$passwdfile"
        while read line1
        do
            foundid="$(echo $line1 |grep -o $idcount)"
            if [ -n "$foundid" ]
                then
                    idcount="$(expr $idcount + 1)"
            fi
        done
        exec 0<&6
        echo -e "Using" "\033[32m""$idcount""\e[0m" "for id's."
        echo
        if [[ -n "$2" ]]
        then
            echo -e "Using ""\033[32m""$2""\e[0m"" for the username."
            name="$2"
            echo
        else
            read -ep "Please input a username: " name
            echo
        fi
		#
        if [[ -n "$3" ]]
        then
            echo -e "Using ""\033[32m""$3""\e[0m"" for the password."
            apppass="$3"
            echo
        else
            read -ep "Do you want to enter a password [y] or use a random one [r]: " -i "y" mypassword
            echo
            if [[ "$mypassword" =~ ^[Yy]$ ]]
            then
                read -ep "Please input a password: " apppass
                echo
            else
                :
            fi
        fi
		#
		echo -e "\033[32m""Do not include the""\e[0m" "\033[36m""~/""\e[0m" "\033[32m""in the path. Use paths that match existing Jails, relative to your Root directory, for example:""\e[0m"
        echo
        echo -e "\033[36m""private/rtorrent/data""\e[0m"
        echo
        echo -e "\033[33m""Use TAB to auto complete the path.""\e[0m"
        echo
        read -ep "Please specify a relative path to the users home/jail directory: ~/" -i "private/rtorrent/data" jailpath
        echo
        echo "$apppass" | "$binarycmd" --passwd --name="$name" --file="$passwdfile" --uid="$idcount" --gid="$idcount" --home="$HOME/$jailpath" --shell="/bin/false" --stdin >/dev/null 2>&1
        "$binarycmd" --group --name="$name" --file="$groupdfile" --gid="$idcount" --member="$name" >/dev/null 2>&1
        echo -e "The username is: ""\033[32m""$name""\e[0m"
        echo
        echo -e "The password is: ""\033[32m""$apppass""\e[0m"
        echo
        echo -e "The jail PATH is: ""\033[36m""$HOME/$jailpath""\e[0m"
        echo
        #
        # Edit above this line
        filezillaxmladduser
        echo "Filezilla site templates that you can import into Filezilla were generated in:"
        echo
        echo -e "\033[36m""~/.userdocs/logins/$name.$(hostname -f).xml""\e[0m"
        #
        echo
        exit
    else
        echo -e "\033[36m""~/proftpd/bin/ftpasswd""\e[0m"" not found. Is proftpd actually installed?"
        echo
        exit
    fi
fi