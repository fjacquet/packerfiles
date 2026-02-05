#!/bin/sh -u

export PATH=/sbin:/usr/sbin:/bin:/usr/bin

date > /etc/vagrant_box_build_time

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
VAGRANT_KEY_FILE="/tmp/vagrant.pub"

# Packer passes boolean user variables through as '1', but this might change in
# the future, so also check for 'true'.
if [ "$INSTALL_VAGRANT_KEY" = "true" ] || [ "$INSTALL_VAGRANT_KEY" = "1" ]; then

    echo "==> Installing vagrant key";
    mkdir -p "$SSH_USER_HOME"/.ssh;
    chmod 700 "$SSH_USER_HOME"/.ssh;

    # Vagrant insecure public key (uploaded by Packer file provisioner)
    cp "$VAGRANT_KEY_FILE" "$SSH_USER_HOME"/.ssh/authorized_keys;
    chmod 600 "$SSH_USER_HOME"/.ssh/authorized_keys;
    chown -R "$SSH_USER":"$(id -g "$SSH_USER")" "$SSH_USER_HOME"/.ssh;
fi
