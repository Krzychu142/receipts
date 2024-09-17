#!/bin/bash

BACKUP_DIR="/home/krzysiek/projects/receipt-project-sql/backups/data"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.bak"

# DATA WAS LEFT ONLY FOR DOCUMENTATION PURPOSES
DB_NAME="receipts_project"
DB_USER="krzysiek"
DB_HOST="localhost"

pg_dump -U $DB_USER -h $DB_HOST -F c -b -v -f $BACKUP_FILE $DB_NAME
find $BACKUP_DIR -type f -name "*.bak" -mtime +7 -exec rm {} \;
echo "Backup completed at: $(date)" >> $BACKUP_DIR/backup_log.txt