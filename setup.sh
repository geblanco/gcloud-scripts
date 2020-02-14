#!/bin/bash

sudo apt update && sudo apt install wget git tree unzip -y
sudo chown -R $USER ~/.config
ssh-keygen -t rsa -b 4096 -C "gcp-$(hostname)"

echo "Use backup server (good practice)? [y/n] "
read use_backup
echo ""
if [[ $use_backup =~ ^[Yy]$ ]]
then
  echo "Input the server address to use as backup server (format: <user>@<server_addr>): "
  read server_addr
  echo ""
  ssh-copy-id $server_addr

  echo "export BACKUP_SERVER='$server_addr'" >> ~/.bash_aliases
fi

