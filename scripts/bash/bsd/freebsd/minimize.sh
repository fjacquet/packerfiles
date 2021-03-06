#!/bin/sh -ue

echo "==> Zero out the free space to save space in the final image";
COMPRESSION=$(zfs get -H compression zroot | cut -f3);

zfs set compression=off zroot/ROOT/default;
dd if=/dev/zero of=/EMPTY bs=1m &
PID=$!;

avail=$(zfs get -pH avail zroot/ROOT/default | cut -f3);
while [ "$avail" -ne 0 ]; do
  sleep 15;
  avail=$(zfs get -pH avail zroot/ROOT/default | cut -f3);
done

kill $PID || echo "dd already exited";

rm -f /EMPTY;
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync;
zfs set compression=$COMPRESSION zroot/ROOT/default;
