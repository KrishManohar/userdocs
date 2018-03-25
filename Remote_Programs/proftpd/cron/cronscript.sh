#!/bin/bash
#
[[ $(cat ~/proftpd/sftp.pid) -eq $(ps x | pgrep proftpd) ]] || echo no
[[ $(cat ~/proftpd/ftps.pid) -eq $(ps x | pgrep proftpd) ]] || echo no
