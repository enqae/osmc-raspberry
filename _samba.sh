#!/usr/bin/env bash

# Based on https://www.raspberrypi.org/magpi/samba-file-server/

echo "Installing Samba Server..."

# Base software
sudo apt-get install -y samba samba-common-bin

# Add the shared volumes
cat <<-EOF

This is a manual step =>

1. Edit /etc/samba/smb.conf
    sudo vi /etc/samba/smb.conf

2. Add as many volumes as you want following this template:
[share]
comment = Pi shared folder
path = /share
browseable = yes
read only = no
writeable = Yes
only guest = no
create mask = 0640
directory mask = 0750
valid users = pi
#valid users = one, two, three, four
#Public = yes
#Guest ok = 
#force user = userA
#force group = groupA

3. Create Samba user and set password
  	sudo smbpasswd -a pi

4. Restart Samba
    sudo /etc/init.d/samba restart
    #sudo service smbd restart

Press any key to continue or ctrl-c to finish
EOF
read


