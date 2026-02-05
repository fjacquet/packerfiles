#!/bin/bash -eux

echo "==> Clear out machine id"
rm -f /etc/machine-id
touch /etc/machine-id

echo "==> Cleaning up temporary network addresses"
rm -rf /etc/udev/rules.d/70-persistent-net.rules

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

echo "==> Clean up zypper cache to save space"
zypper --non-interactive clean --all

echo "==> Removing temporary files used to build box"
rm -rf /tmp/*

# delete any logs that have built up during the install
find /var/log/ -name "*.log" -exec rm -f {} \;

echo '==> Clear out swap and disable until reboot'
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
	2|0) ;;
	*) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

echo '==> Zeroing out empty area to save space in the final image'
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

sync

echo "==> Disk usage before cleanup"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "==> Disk usage after cleanup"
df -h
