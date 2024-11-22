#!/bin/bash
/usr/lib/gnupg/scdaemon --daemon
echo "$USER_NAME:x:$(id -u root):$(id -g root)::/root:/bin/zsh" >> /etc/passwd
echo root:$USER_PASSWORD | chpasswd
echo $USER_NAME:$USER_PASSWORD | chpasswd
gpg --card-edit fetch quit
/usr/sbin/sshd -D