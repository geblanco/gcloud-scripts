#!/bin/bash

sudo apt update && sudo apt install wget git tree unzip jq -y
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
  echo "Fill the rest of server data with your data (~/.server_data)"
  echo "export BACKUP_SERVER='$server_addr'" >> ~/.server_data
  echo "export TO_BACKUP_DIR=<local_backup_dir>" >> ~/.server_data
  echo "export REMOTE_BACKUP_DIR=<remote_backup_dir>" >> ~/.server_data
fi

pip3 install 'dvc[all]'
echo "alias dvc='python3 -m dvc'" >> ~/.bash_aliases
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 10
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 20

cd ~
git clone https://github.com/google/jsonnet
cd jsonnet/
make 
sudo ln -s `pwd`/jsonnet /usr/bin/jsonnet

echo "Done, exit"
