#!/bin/bash

sudo apt update && sudo apt install wget git tree unzip jq -y
sudo chown -R $USER ~/.config
ssh-keygen -t rsa -b 4096 -C "gcp-$(hostname)"

copy_key(){
  local server=$1;
  echo "Copy key to server?"
  read cpy
  echo ""
  if [[ $cpy =~ ^[Yy]$ ]]
  then
    ssh-copy-id $server
  fi
}

echo "Use backup server (good practice)? [y/n] "
read use_backup
echo ""
if [[ $use_backup =~ ^[Yy]$ ]]
then
  echo "Input the server address to use as backup server (format: <user>@<server_addr>): "
  read server_addr
  echo ""
  copy_key $server_addr

  echo "Use hop server? [y/n]"
  read use_hop_server
  echo ""
  if [[ $use_hop_server =~ ^[Yy]$ ]]
  then
    echo "Input the server address to use as hop server (format: <user>@<server_addr>): "
    read hop_server_addr
    echo ""
    copy_key $hop_server_addr
    echo "export HOP_SERVER='$hop_server_addr'" >> ~/.server_data
  fi
  echo "export BACKUP_SERVER='$server_addr'" >> ~/.bash_aliases
  echo "Fill the rest of server data with your data (~/.server_data)"
  echo "export BACKUP_SERVER='$server_addr'" >> ~/.server_data
  echo "export TO_BACKUP_DIR=<local_backup_dir>" >> ~/.server_data
  echo "export REMOTE_BACKUP_DIR=<remote_backup_dir>" >> ~/.server_data
  echo "" >> ~/.server_data
  cat ./server_data >> ~/.server_data
fi

sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 10
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 20

echo "Done, exit"
