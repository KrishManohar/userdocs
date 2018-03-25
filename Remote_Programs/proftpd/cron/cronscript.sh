#!/bin/bash
#
# This file is commented out so as not to start proftpd until we are ready and it is configured.
#
# A simple check to see if proftpd is running based on the pid file.
#[[ $(cat ~/proftpd/sftp.pid) -eq $(ps x | pgrep proftpd) && -n $(cat ~/proftpd/sftp.pid 2> /dev/null) ]] || ~/proftpd/sbin/proftpd -c ~/proftpd/etc/sftp.conf
#[[ $(cat ~/proftpd/ftps.pid) -eq $(ps x | pgrep proftpd) && -n $(cat ~/proftpd/sftp.pid 2> /dev/null) ]] || ~/proftpd/sbin/proftpd -c ~/proftpd/etc/ftps.conf
#
