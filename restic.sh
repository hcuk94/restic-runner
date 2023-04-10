#!/bin/bash

# Timestamp Function
timestamp() {
date "+%b %d %Y %T %Z"
}

# Log Start
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a restic.log
echo "$(timestamp): restic.sh started" | tee -a restic.log

# Run Backups
restic backup /home /etc /root /var /usr/local/bin /usr/local/sbin /opt

# Remove snapshots according to policy
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 7  | tee -a restic.log

# Remove unneeded data from the repository
restic prune

# Check the repository for errors
restic check | tee -a restic.log

# Log End
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a restic.log
echo "$(timestamp): restic.sh finished" | tee -a restic.log