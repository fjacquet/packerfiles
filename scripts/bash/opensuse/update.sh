#!/bin/bash -eux

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    echo "==> Applying updates"
    zypper --non-interactive update

    # reboot
    echo "Rebooting the machine..."
    reboot
    sleep 60
fi
