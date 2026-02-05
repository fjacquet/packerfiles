#!/bin/bash -eux

echo '==> Configuring settings for vagrant'

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
VAGRANT_KEY_FILE="/tmp/vagrant.pub"

if [ "$INSTALL_VAGRANT_KEY" = "true" ] || [ "$INSTALL_VAGRANT_KEY" = "1" ]; then
  # Add vagrant user (if it doesn't already exist)
  if ! id -u "$SSH_USER" >/dev/null 2>&1; then
      echo '==> Creating vagrant user'
      /usr/sbin/groupadd "$SSH_USER"
      /usr/sbin/useradd "$SSH_USER" -g "$SSH_USER"
      echo "${SSH_USER}:${SSH_USER}" | chpasswd
      echo "${SSH_USER}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
  fi

  echo '==> Installing Vagrant SSH key'
  mkdir -p "${SSH_USER_HOME}/.ssh" && chmod 700 "${SSH_USER_HOME}/.ssh"
  # Vagrant insecure public key (uploaded by Packer file provisioner)
  cp "$VAGRANT_KEY_FILE" "$SSH_USER_HOME"/.ssh/authorized_keys
  chmod 0600 "${SSH_USER_HOME}"/.ssh/authorized_keys
  chown -R "${SSH_USER}":"${SSH_USER}" "${SSH_USER_HOME}"/.ssh
fi
