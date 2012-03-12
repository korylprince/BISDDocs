#!/bin/bash

#########################################
# MySQL Backup Script by Kory Prince    #
# Fill out configuration below.         # 
# Databases must be separated by spaces #
# backupdir must have a trailing /      #
# Change compress to anything other     #
# than yes to turn off compression.     #
# the first argument to the script will #
# be included in the filename.          #
#########################################


dbs=(phpmyadmin moodle_1 moodle_2)
user=<user>
pass=<password>

days=7
compress="yes"

backupdir=/path/to/backup/folder
datestamp=`date +%m.%d.%y_%I.%M%P`

if [ ! -d $backupdir ]
then
    echo Creating $backupdir
    mkdir -p $backupdir
fi

for db in ${dbs[*]}
do
    if [ ! -d $backupdir$db/ ]
    then
        echo Creating $backupdir$db/
        mkdir -p $backupdir$db/
    fi
    echo Dumping $db to $backupdir$db/$datestamp$1.sql
    mysqldump -u$user -p$pass $db >$backupdir$db/$datestamp$1.sql

    if [[ "$compress" == yes ]]
    then
        echo Compressing $backupdir$db/$datestamp$1.sql
        gzip -f $backupdir$db/$datestamp$1.sql
        echo Compressed to $backupdir$db/$datestamp$1.sql.gz
    else
        echo Not Compressing
    fi

    echo Removing files older than $days days
    echo Removing:
    find $backupdir$db/*.sql* -type f -mtime +$days 2>/dev/null
    rm `find $backupdir$db/*.sql* -type f -mtime +$days 2>/dev/null` 2>/dev/null
    echo Done
    echo
done
