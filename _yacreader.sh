#!/usr/bin/env bash

# Based on http://www.yacreader.com/45-yacreaderlibraryserver-on-raspberry-pi-raspbian

echo "Installing YACReaderLibraryServer..."

export YAC_WK="${HOME}/yac"

# Base Tools
function _getBaseTools(){
    sudo apt-get install -y mercurial
    sudo apt-get install -y qt5-default
    sudo apt-get install -y libpoppler-qt5-dev
    sudo apt-get install -y gcc g++ make
    sudo apt-get install -y sqlite sqlite3
    sudo apt-get install -y libqt5sql5-sqlite
}

# Get YacReader
function _getYACReader(){
    mkdir -p "${YAC_WK}/yacreader_hg"
    cd "${YAC_WK}/yacreader_hg"
    hg clone https://bitbucket.org/luisangelsm/yacreader .
}

# unarr
function _get_unarr(){
    mkdir -p "${YAC_WK}/yacreader_hg/compressed_archive/unarr/" 
    cd "${YAC_WK}/yacreader_hg/compressed_archive/unarr"
    wget github.com/selmf/unarr/archive/master.zip
    unzip master.zip
}

# Build & install YACReaderLibraryServer
function _buildYACReader(){
    mkdir -p "${YAC_WK}/yacreader_hg/YACReaderLibraryServer/"
    cd "${YAC_WK}/yacreader_hg/YACReaderLibraryServer/"
    qmake YACReaderLibraryServer.pro
    make
    sudo make install
}

# Set startup process
function _configStartupProcess(){

    # ON_INIT_FILE is set in 'setup.sh'
    cat >> "${ON_INIT_FILE}" <<-EOF

### Added by YACReaderLibraryServer - START

pgrep -i yacreader
if [ "$?" -eq "1" ]
then
    nohup YACReaderLibraryServer start &>/dev/null &
fi

### Added by YACReaderLibraryServer - END

EOF
}


# Cleanup
function _cleanup(){
    cd 
    rm -rf "${YAC_WK}"
}

# Prepare, Build, Install 
function _setupYACReaderLibraryServer(){

    # Prepare build environment
    _getBaseTools
    _getYACReader
    _get_unarr

    # Build & Install
    _buildYACReader

    # Config & exit
    _configStartupProcess
    _cleanup
}

# Main
_setupYACReaderLibraryServer
