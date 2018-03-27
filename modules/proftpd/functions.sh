remotepath () {
    path1="media"
    path2="$(echo $HOME | cut -d '/' -f3)"
    path3="$(echo $HOME | cut -d '/' -f4)"
    if [[ "$path3" = "home" ]]; then
        path3="home"
        path4="$(whoami)"
        echo "1 0 $(echo ${#path1}) $path1 $(echo ${#path2}) $path2 $(echo ${#path3}) $path3 $(echo ${#path4}) $path4"
    else
        path3="$(whoami)"
        echo "1 0 $(echo ${#path1}) $path1 $(echo ${#path2}) $path2 $(echo ${#path3}) $path3"
    fi
}
jailpath () {

    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f5)" ]] && path1="$(echo $HOME/$jailpath | cut -d '/' -f5)" || path1="nullanvoid"
    #
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f6)" ]] && path2="$(echo $HOME/$jailpath | cut -d '/' -f6)" || path2="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f7)" ]] && path3="$(echo $HOME/$jailpath | cut -d '/' -f7)" || path3="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f8)" ]] && path4="$(echo $HOME/$jailpath | cut -d '/' -f8)" || path4="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f9)" ]] && path5="$(echo $HOME/$jailpath | cut -d '/' -f9)" || path5="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f10)" ]] && path6="$(echo $HOME/$jailpath | cut -d '/' -f10)" || path6="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f11)" ]] && path7="$(echo $HOME/$jailpath | cut -d '/' -f11)" || path7="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f12)" ]] && path8="$(echo $HOME/$jailpath | cut -d '/' -f12)" || path8="nullanvoid"
    [[ -n "$(echo $HOME/$jailpath | cut -d '/' -f13)" ]] && path9="$(echo $HOME/$jailpath | cut -d '/' -f13)" || path9="nullanvoid"
    #
    echo "$(echo ${#path1}) $path1 $(echo ${#path2}) $path2 $(echo ${#path3}) $path3 $(echo ${#path4}) $path4 $(echo ${#path5}) $path6 $(echo ${#path6}) $path6 $(echo ${#path7}) $path7 $(echo ${#path8}) $path8 $(echo ${#path9}) $path9" | sed -r "s/ 10 nullanvoid//g"
}
#
filezillaxml () {
    mkdir -p ~/.userdocs/logins
    #
    filezillauser="$(whoami)"
    #
    wget -qO ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml "$filezilla"
    #
    sed -ri 's|HOSTNAME|'"$(hostname -f)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|DAEMONPORTSFTP|'"$sftpport"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|DAEMONPORTFTPS|'"$ftpsport"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|DAEMONPROTOCOLSFTP|1|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|DAEMONPROTOCOLFTPS|4|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|USERNAME|'"$filezillauser"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|PASSWORD|'"$(echo -n $apppass | base64)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|SERVERNAMESFTP|'"$filezillauser $(hostname) sftp"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|SERVERNAMEFTPS|'"$filezillauser $(hostname) ftps"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|REMOTEDIR|'"$(remotepath)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
}
#
filezillaxmladduser () {
    mkdir -p ~/.userdocs/logins
    #
    filezillauser="$name"
    #
    wget -qO ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml "$filezilla"
    #
    sed -ri 's|HOSTNAME|'"$(hostname -f)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|DAEMONPORTSFTP|'"$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/sftp.conf)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|DAEMONPORTFTPS|'"$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/ftps.conf)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|DAEMONPROTOCOLSFTP|1|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|DAEMONPROTOCOLFTPS|4|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|USERNAME|'"$filezillauser"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|PASSWORD|'"$(echo -n $apppass | base64)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|SERVERNAMESFTP|'"$filezillauser $(hostname) sftp"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    sed -ri 's|SERVERNAMEFTPS|'"$filezillauser $(hostname) ftps"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
    #
    sed -ri 's|REMOTEDIR|'"$(remotepath) $(jailpath)"'|g' ~/.userdocs/logins/"$filezillauser"."$(hostname -f)".xml
}