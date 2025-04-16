
# Backup Nexus data
sudo systemctl stop nexus
tar -zcvf nexus-data-backup.tar.gz /opt/sonatype-work/nexus3
sudo systemctl start nexus

# Restore Nexus data
sudo systemctl stop nexus
tar -zxvf nexus-data-backup.tar.gz -C /opt/sonatype-work/nexus3
sudo systemctl start nexus
