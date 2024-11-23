#!/bin/bash
/usr/lib/gnupg/scdaemon --daemon
if [[ -n $USER_PASSWORD ]]; then
  if [[ -n $USER_NAME ]]; then
    echo "$USER_NAME:x:$(id -u root):$(id -g root)::/root:/bin/zsh" >> /etc/passwd
    echo $USER_NAME:$USER_PASSWORD | chpasswd
  fi
  echo root:$USER_PASSWORD | chpasswd

  if ! grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config; then
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
  fi
fi

if [[ -n $USER_SSH ]]; then
    echo "$USER_SSH" > /root/.ssh/authorized_keys
fi

echo "Jumphost" > /etc/hostname
gpg --card-edit fetch quit
/usr/sbin/sshd -D