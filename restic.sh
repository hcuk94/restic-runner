#!/bin/bash -l

# Variables
MAIL_FROM=restic@example.com
MAIL_TO=restic@example.com
SMTP_SERVER=server:587

# Timestamp Function
timestamp() {
date "+%b %d %Y %T %Z"
}

# Log Start
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a restic.log
echo -e "$(timestamp): restic.sh started\n" | tee -a restic.log

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
echo -e "$(timestamp): restic.sh finished\n" | tee -a restic.log

# Mail Results and clear log/mail files
echo -e "Subject: Restic backup report for $HOSTNAME\n\n" >> mailcontent.txt
cat restic.log >> mailcontent.txt
curl smtp://$SMTP_SERVER --mail-from $MAIL_FROM --mail-rcpt $MAIL_TO -T mailcontent.txt
rm restic.log mailcontent.txt
