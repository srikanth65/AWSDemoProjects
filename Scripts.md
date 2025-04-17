
# Backup Nexus data

sudo systemctl stop nexus

tar -zcvf nexus-data-backup.tar.gz /opt/sonatype-work/nexus3

sudo systemctl start nexus

# Restore Nexus data

sudo systemctl stop nexus

tar -zxvf nexus-data-backup.tar.gz -C /opt/sonatype-work/nexus3

sudo systemctl start nexus


**Backup Script Example**

#!/bin/bash 

#Backup Jenkins Home Directory 

BACKUP_DIR="/path/to/backup/$(date +%F)" 

mkdir -p $BACKUP_DIR

cp -r /var/lib/jenkins/* $BACKUP_DIR

Automated Backups: Use plugins like ThinBackup or JobConfigHistory for automated backup and job history tracking





