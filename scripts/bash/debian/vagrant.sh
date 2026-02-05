#!/bin/bash -eux

echo '==> Configuring settings for vagrant'

SSH_USER=${SSH_USER:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
VAGRANT_KEY_FILE="/tmp/vagrant.pub"

# Add vagrant user (if it doesn't already exist)
if ! id -u $SSH_USER >/dev/null 2>&1; then
    echo '==> Creating Vagrant user'
    /usr/sbin/groupadd $SSH_USER
    /usr/sbin/useradd $SSH_USER -g $SSH_USER -G sudo -d $SSH_USER_HOME --create-home
    echo "${SSH_USER}:${SSH_USER}" | chpasswd
fi

# Set up sudo.  Be careful to set permission BEFORE copying file to sudoers.d
( cat <<EOP
%$SSH_USER ALL=(ALL) NOPASSWD:ALL
EOP
) > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/

# Packer passes boolean user variables through as '1', but this might change in
# the future, so also check for 'true'.
if [ "$INSTALL_VAGRANT_KEY" = "true" ] || [ "$INSTALL_VAGRANT_KEY" = "1" ]; then
    echo '==> Installing Vagrant SSH key'
    mkdir -p "$SSH_USER_HOME/.ssh" && chmod 700 "$SSH_USER_HOME/.ssh"
    # Vagrant insecure public key (uploaded by Packer file provisioner)
    cp "$VAGRANT_KEY_FILE" $SSH_USER_HOME/.ssh/authorized_keys
    chmod 600 $SSH_USER_HOME/.ssh/authorized_keys
    chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME/.ssh
fi
