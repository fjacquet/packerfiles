#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing Open VM Tools"
    zypper --non-interactive install open-vm-tools
    systemctl enable vmtoolsd
    mkdir -p /mnt/hgfs
fi
