#!/bin/sh -u

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_PASS=${SSH_PASSWORD:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
VAGRANT_KEY_FILE="/tmp/vagrant.pub"

# Packer passes boolean user variables through as '1', but this might change in
# the future, so also check for 'true'.
if [ "$INSTALL_VAGRANT_KEY" = "true" ] || [ "$INSTALL_VAGRANT_KEY" = "1" ]; then
    # Create Vagrant user (if not already present)
    if ! id -u "$SSH_USER" >/dev/null 2>&1; then
        echo "==> Creating $SSH_USER user";
        /usr/sbin/groupadd "$SSH_USER";
        /usr/sbin/useradd "$SSH_USER" -g "$SSH_USER" -G wheel -d "$SSH_USER_HOME" --create-home;
        echo "${SSH_USER}:${SSH_PASS}" | chpasswd;
    fi

    pw usermod "$SSH_USER" -G wheel;

    # Set up sudo
    if [ -x /usr/local/bin/sudo ]; then
      echo "==> Giving ${SSH_USER} sudo powers";
      echo "${SSH_USER}        ALL=(ALL)       NOPASSWD: ALL" >> /usr/local/etc/sudoers;
    else # Asume using doas
      echo "==> Giving ${SSH_USER} doas powers";
      echo "permit nopass keepenv { ENV PS1 SSH_AUTH_SOCK } ${SSH_USER}" >> /etc/doas.conf;
    fi

    echo "==> Installing vagrant key";
    mkdir "$SSH_USER_HOME"/.ssh;
    chmod 700 "$SSH_USER_HOME"/.ssh;
    cd "$SSH_USER_HOME"/.ssh || exit;

    # Vagrant insecure public key (uploaded by Packer file provisioner)
    cp "$VAGRANT_KEY_FILE" "$SSH_USER_HOME"/.ssh/authorized_keys;
    chmod 600 "$SSH_USER_HOME"/.ssh/authorized_keys;
    chown -R "$SSH_USER":"$SSH_USER" "$SSH_USER_HOME"/.ssh;
fi
