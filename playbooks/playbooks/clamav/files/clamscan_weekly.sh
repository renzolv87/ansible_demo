#!/bin/bash

DIR=/
QUARANTINE_DIR=/var/tmp/clamav_quarantine/
EXCLUDE_PATHS="/var/lib/lxcfs/cgroup/devices/system/|/sys/module/|/var/lib/waagent/|/var/tmp/clamav_quarantine/|/var/opt/microsoft/"

nice -n 15 clamscan -i -r "$DIR" --exclude-dir="$EXCLUDE_PATHS" --move "$QUARANTINE_DIR" 2>/dev/null
