#!/usr/bin/env bash

set -e

function _updateOSMC(){

    sudo apt-get update
    sudo apt-get dist-upgrade -y

    sudo apt-get install -y git
}

function _setupBashrc(){

    # Set for the following processes
    export ON_INIT_FILE="${HOME}/.on_init_gen"

    # Update .bashrc only the first run of this setup script
    [[ -f "${ON_INIT_FILE}" ]] && return

    mv on_init ~/.on_init_gen

    cat >> ~/.bashrc <<-EOF

#### ADDED by osmc-setup process - START    
if [ -f ~/.on_init_gen ]; then
. ~/.on_init_gen
fi

export PATH=.:$PATH
#### ADDED by osmc-setup process - END

EOF
}

function _runSetupScripts(){

    # First Docker
    ./_docker.sh

    # YACReader
    ./_yacreader.sh

    cat <<-EOF
Samba and TimeMachine are disabled by default as they required manual steps.
To enable them => just uncomment
Press any key to continue or ctrl-c to finish
EOF
read

    # Samba
    ###./_samba.sh

    # TimeMachine
    # Requires MANUAL STEPS
    ###./_timeMachine.sh
}

function _main(){
    
    # Update system
    _updateOSMC

    # Extend .bashrc
    _setupBashrc

    # Find setup scripts
    _runSetupScripts
}

# Main
_main

