#!/usr/bin/env bash

# Based on https://pimylifeup.com/raspberry-pi-torrentbox/

echo "Installing Torrent (Transmission)..."

#sudo apt-get update
#sudo apt-get dist-upgrade -y

# Install software
sudo apt-get install -y hfsprogs hfsplus
sudo apt-get install -y transmission-daemon

# Prepare mount points [torrent-inprogress - torrent-complete]
sudo mkdir -p /media/torrent

# MANUAL STEP ----- START

cat <<-EOF

This is a MANUAL STEP

1.Make sure you know the disk to be used as TimeMachine

2.Edit /etc/fstab and add the disk => 
    sudo vi /etc/fstab

    It should be like (the data to change is --->>>/dev/sda2<<<---):
        /dev/sda2 /media/torrent hfsplus force,rw,user,auto 0 0

3. Mount the disk => 
    sudo mount -a

4. Press any key and continue or ctrl-c to finish
EOF
read

echo "Are sure to continue? (press a to continue or ctrl-c to finish)"
read
# MANUAL STEP ----- STOP

# Update Torrent settings
# MANUAL STEP ----- START

cat <<-EOF

This is a MANUAL STEP

1.Edit /etc/transmission-daemon/settings.json  => 
    sudo vi /etc/transmission-daemon/settings.json

    The values for the settings should be:
        "incomplete-dir": "/media/torrent/torrent-inprogress",
        "incomplete-dir-enabled": true,
        "download-dir": "/media/torrent/torrent_complete",
        "rpc-username": "osmc",
        "rpc-password": "####----THE PASSWORD----####",
        "rpc-whitelist": "192.168.*.*",

2. Press any key and continue or ctrl-c to finish
EOF
read

echo "Are sure to continue? (press a to continue or ctrl-c to finish)"
read
# MANUAL STEP ----- STOP

# Start service
sudo service transmission-daemon reload

# Remember
#http://your_pi_ip:9091



