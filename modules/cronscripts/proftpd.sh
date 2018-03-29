#!/bin/bash
#
# This file is commented out so as not to start proftpd until we are ready and it is configured.
#
# If the file ~/proftpd/****.pid exists then read the file to get the PID number. Otherwise do nothing. Do not print errors.
[[ -f ~/proftpd/sftp.pid ]] && sftppid="$(cat ~/proftpd/sftp.pid 2> /dev/null)"
[[ -f ~/proftpd/ftps.pid ]] && ftpspid="$(cat ~/proftpd/ftps.pid 2> /dev/null)"
#
# Check to see if the PID is a running process and if the result is empty then restart. Otherwise do nothing. Do not print errors.
#
# SFTP server check. Uncomment and save file to activate.
#[[ -z "$(ps --no-headers -p "$sftppid" 2> /dev/null)" ]] && ~/proftpd/sbin/proftpd -c ~/proftpd/etc/sftp.conf
#
# FTPS server check. Uncomment and save file to activate.
#[[ -z "$(ps --no-headers -p "$ftpspid" 2> /dev/null)" ]] && ~/proftpd/sbin/proftpd -c ~/proftpd/etc/ftps.conf
#
