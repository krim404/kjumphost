#!/bin/bash
/usr/lib/gnupg/scdaemon --daemon
echo root:$USER_PASSWORD | chpasswd
gpg --card-edit fetch quit
/usr/sbin/sshd -D