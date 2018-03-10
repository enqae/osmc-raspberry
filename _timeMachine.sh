#!/usr/bin/env bash

# Based on https://www.howtogeek.com/276468/how-to-use-a-raspberry-pi-as-a-networked-time-machine-drive-for-your-mac/

# DOCS => http://netatalk.sourceforge.net/3.1/htmldocs/

echo "Installing TimeMachine Server..."

# Base software
sudo apt-get install -y hfsprogs hfsplus

# Install Netatalk
mkdir ~/netatalk
cd ~/netatalk

sudo apt-get install -y \
    build-essential \
    libevent-dev \
    libssl-dev \
    libgcrypt11-dev \
    libkrb5-dev \
    libpam0g-dev \
    libwrap0-dev \
    libdb-dev \
    libtdb-dev \
    avahi-daemon \
    libavahi-client-dev \
    libacl1-dev \
    libldap2-dev \
    libcrack2-dev \
    systemtap-sdt-dev \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libglib2.0-dev \
    libio-socket-inet6-perl \
    tracker \
    libtracker-sparql-1.0-dev \
    libtracker-miner-1.0-dev

# MANUAL STEP ----- START
cat <<-EOF

This is a MANUAL STEP

1.Update sources.list: sudo vi /etc/apt/sources.list
ENABLE Jessie & DISABLE stretch =>

    deb http://ftp.debian.org/debian stretch main contrib non-free

    deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free
    
    deb http://security.debian.org/ stretch/updates main contrib non-free
    
    deb http://apt.osmc.tv stretch main

    ##deb http://ftp.debian.org/debian jessie main contrib non-free
    
    ##deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free
    
    ##deb http://security.debian.org/ jessie/updates main contrib non-free

2.Update apt & install mysql libs =>
    sudo apt-get update
    sudo apt-get install -y libmysqlclient-dev

3.DISABLE Jessie & ENABLE stretch
4.Update apt =>
    sudo apt-get update

5. Press any key and continue or ctrl-c to finish
EOF
read

echo "Are sure to continue? (press a to continue or ctrl-c to finish)"
read
# MANUAL STEP ----- STOP


# Get Netatalk
wget http://prdownloads.sourceforge.net/netatalk/netatalk-3.1.11.tar.gz
tar -xf netatalk-3.1.11.tar.gz
cd netatalk-3.1.11

./configure \
        --with-init-style=debian-systemd \
        --without-libevent \
        --without-tdb \
        --with-cracklib \
        --enable-krbV-uam \
        --with-pam-confdir=/etc/pam.d \
        --with-dbus-daemon=/usr/bin/dbus-daemon \
        --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
        --with-tracker-pkgconfig-version=1.0

make
sudo make install

# Verify installation
#### netatalk -V

# Configure Netatalk 

# MANUAL STEP ----- START
cat <<-EOF

This is a MANUAL STEP 

1. EDIT FILE and Change /etc/nsswitch.conf

    sudo /etc/nsswitch.conf

2. Add or modify the line => 
    hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4 mdns 

3. Press any key and continue or ctrl-c to finish
EOF
read

echo "Are sure to continue? (press a to continue or ctrl-c to finish)"
read
# MANUAL STEP ----- STOP

sudo cat >> /etc/avahi/services/afpd.service <<-EOF

<<!-- ## ADDED in setup - START -->
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
    <name replace-wildcards="yes">%h</name>
    <service>
        <type>_afpovertcp._tcp</type>
        <port>548</port>
    </service>
    <service>
        <type>_device-info._tcp</type>
        <port>0</port>
        <txt-record>model=TimeCapsule</txt-record>
    </service>
</service-group>
<<!-- ## ADDED in setup - END -->
EOF

sudo mv /usr/local/etc/afp.conf /usr/local/etc/afp.conf.ORIGINAL
sudo cat >> /usr/local/etc/afp.conf <<-EOF

[Global]
  mimic model = TimeCapsule6,106

[PI Time Machine]
  path = /media/tm
  time machine = yes
EOF

# Mount point
sudo mkdir -p /media/tm

# MANUAL STEP ----- START

cat <<-EOF

This is a MANUAL STEP

1.Make sure you know the disk to be used as TimeMachine

2.Edit /etc/fstab and add the disk => 
    sudo vi /etc/fstab

    It should be like (the data to change is /dev/sda2):
        /dev/sda2 /media/tm hfsplus force,rw,user,auto 0 0

3. Mount the disk => 
    sudo mount -a

4. Press any key and continue or ctrl-c to finish
EOF
read

echo "Are sure to continue? (press a to continue or ctrl-c to finish)"
read
# MANUAL STEP ----- STOP


# Startup and make service-able
sudo service avahi-daemon start
sudo service netatalk start

sudo systemctl enable avahi-daemon
sudo systemctl enable netatalk

# Cleanup
cd 
rm -rf netatalk

