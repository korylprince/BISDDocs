#!/bin/bash
#set all output to go to logs
logtime="`date '+%m_%d_%Y_%H_%M'`"
logfile=~/backup/logs/$logtime.log
exec > $logfile 2>&1
echo "Backup Started `date '+%c'`"
echo "Mounting SMB Share..."
mount //path/to/share
echo "Copying files"
rsync -va ~/share/mount/location ~/backup/files/
echo ""
echo ""
echo "Unmounting SMB Share"
umount //path/to/share
echo "Sending files to Backup Location..."
brackup -v --from=backup --to=remote --output=~/backup/backup_files/$logtime.brackup
echo ""
echo ""
echo "Removing old Backups..."
brackup-target -v remote prune
brackup-target -v remote gc
echo ""
echo ""
echo "Current Backups:"
brackup-target -v remote list_backups
echo "Checking Space:"
sftp <remote host> <<EOF
df -h
exit
EOF
echo ""
echo ""
echo "Backup Ended `date '+%c'`"
#Uncomment for text notifications
#echo "Sending Texts"
#python /home/administrator/backup/notify.py /home/administrator/backup/logs/$logtime.log
echo "Sending Email Reports"
cat ~/backup/logs/$logtime.log|mutt -s "Backup - $logtime"<email to send to>
