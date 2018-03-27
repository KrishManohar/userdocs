if [[ ! -z "$1" && "$1" = 'help' ]]
then
    echo
    echo -e "\033[32m""Script help and usage instructions:""\e[0m"
    echo
    #
    ###################################
    ##### Custom Help Info Starts #####
    ###################################
    #
    echo -e "This script will complete Steps 1 to 6 from the proftpd FAQ. Continue the FAQ from Step 1."
    echo
    echo -e "\033[33m""proftpd is not started by this script so that you may configure your users and jails first""\e[0m"
    echo
    echo -e "Three read only jails that any valid user can access are configured by default, they are:"
    echo
    echo -e "1:""\033[36m"" ~/private/rtorrent/data""\e[0m" "2:""\033[36m"" ~/private/deluge/data""\e[0m" "3:""\033[36m"" ~/private/transmission/data""\e[0m"
    echo
    echo -e "\033[31m""Start Commands:""\e[0m"
    echo
    echo -e "Start SFTP: ""\033[36m""~/proftpd/sbin/proftpd -c ~/proftpd/etc/sftp.conf""\e[0m"
    echo
    echo -e "Start FTPS: ""\033[36m""~/proftpd/sbin/proftpd -c ~/proftpd/etc/ftps.conf""\e[0m"
    echo
    echo -e "\033[31m""Debugging Proftpd:""\e[0m"
    echo
    echo "If proftpd won't start use these commands to see the debugging inforamtion"
    echo
    echo -e "Debug SFTP: ""\033[36m""~/proftpd/sbin/proftpd -nd10 -c ~/proftpd/etc/sftp.conf""\e[0m"
    echo
    echo -e "Debug FTPS: ""\033[36m""~/proftpd/sbin/proftpd -nd10 -c ~/proftpd/etc/ftps.conf""\e[0m"
    echo
    echo -e "\033[33m""The proftpd deamon ports configured are:""\e[0m"
    echo
    echo -e "SFTP port = ""\033[32m""$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/sftp.conf)""\e[0m"
    echo
    echo -e "FTPS port = ""\033[32m""$(sed -nr 's/^Port (.*)/\1/p' ~/proftpd/etc/ftps.conf)""\e[0m"
    echo
    echo -e "\033[31m""adduser script:""\e[0m"
    echo
    echo -e "\033[36madduser\e[0m = Uses the built in add user script to easily create and add a new user."
    echo
    echo -e "Example usage: \033[36m$scriptname adduser\e[0m or it will accept a username: \033[36m$scriptname adduser username\e[0m"
    echo
    echo -e "\033[31m""deleteuser script:""\e[0m"
    echo
    echo -e "\033[36mdeleteuser\e[0m = Uses the built in add user script to easily create and add a new user."
    echo
    echo -e "Example usage: \033[36m$scriptname deleteuser\e[0m or it will accept a username: \033[36m$scriptname deleteuser username\e[0m"
    echo
    echo -e "\033[31m""Filezilla Importable Templates:""\e[0m"
    echo
    echo "Filezilla site templates that you can import into Filezilla were generated in:"
    echo
    echo -e "\033[36m""~/.userdocs/logins/username.$(hostname -f).xml""\e[0m"
    #
    ###################################
    ###### Custom Help Info Ends ######
    ###################################
    #
    echo
    exit
fi