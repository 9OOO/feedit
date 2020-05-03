#!/bin/bash

# Fuse needs to be installed.
sudo apt install fuse -y

# Cahnge fuse config with 'allow_other' option
while read a ; do echo ${a//#user_allow_other/user_allow_other} ; done < /etc/fuse.conf > //etc/fuse.conf.t ; mv /etc/fuse.conf{.t,}

# Lets install Rclone, choose(uncomment)  Stable or Beta

# rclone stable
#curl https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Installer%20Scripts/rclone-install-stable.sh | bash

# rclone beta
curl https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Installer%20Scripts/rclone-install-beta.sh | bash

# 3rd way to install with curl (need sudo)
# curl https://rclone.org/install.sh | sudo bash -s beta


# First, a local dir and a rclone mount dir. You can put these dirs anywhere in your home folder but I’d like to put these inside another folder.

mkdir "$HOME"/gdrive/ #Folder where 2 MergerFS folders are in
mkdir "$HOME"/gdrive/Local/ # Servers as our local mount
mkdir "$HOME"/gdrive/Mount/ # Rclone mount point

# Then, we create another folder where we’ll mount MergerFS. Let’s name it MERGERFS
mkdir "$HOME"/MERGERFS  # Actual mergerfs mount point

# One more, plz, dir for logs
mkdir -p "$HOME"/logs/ # Dir for logs

# Installing MergerFS
curl https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Installer%20Scripts/mergerfs-install.sh | bash

# Update with new commands
source ~/.bashrc
source ~/.profile

# To confirm installation, do which mergerfs
which mergerfs

# Download rclone config (and rename)
curl -P ~/.config/rclone/ -o rclone.conf https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Service%20Files/rclone-mod-dpd.service

# Download services conf to systemd
wget -P ~/.config/systemd/user/ https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Service%20Files/rclone-vfs.service # RClone VFS Service
wget -P ~/.config/systemd/user/ https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Service%20Files/mergerfs.service # MergerFS Mount

# Do pwd and take note of the output.
cd ~/
pwd

# Find:
# 'xxxxx' and 'yyyyy' 
# In:
# ~/.config/systemd/user/mergerfs.service
# ~/.config/systemd/user/rclone-vfs.service
# Replace:
# 'xxxxx' with 'HOME'
# 'yyyyy' with '$USER'

sed -i -e 's/xxxxx/home/g' ~/.config/systemd/user/mergerfs.service
sed -i -e 's/xxxxx/home/g' ~/.config/systemd/user/rclone-vfs.service
sed -i -e 's/yyyyy/box/g' ~/.config/systemd/user/mergerfs.service
sed -i -e 's/yyyyy/box/g' ~/.config/systemd/user/rclone-vfs.service

# Update with new commands
source ~/.bashrc
source ~/.profile

#Reload systemd daemon by doing (sudo required)
curl https://raw.githubusercontent.com/cargo12/testclone/master/script/daemon-reload.sh | bash

#Enable and start the two systemd services by doing
systemctl --user enable --now rclone-vfs && systemctl --user enable --now mergerfs

# !!ADD LATER!!
# Rclone VFS Service File Checker script
# wget https://raw.githubusercontent.com/cargo12/testclone/master/MergerFS-Rclone/Service%20Files/Rclone%20Service%20File%20Check/service-file-check.sh && chmod +x service-file-check.sh && ./service-file-check.sh && rm service-file-check.sh

#Confirm that everything works by doing
ls MERGERFS
