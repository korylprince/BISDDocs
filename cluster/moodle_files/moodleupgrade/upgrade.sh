#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo Shutting Down nginx
service nginx stop

echo updating moodle files
cd /var/moodlewww
git checkout .
git pull origin MOODLE_22_STABLE

echo copying site file
cp /home/administrator/moodleupgrade/config.php.site /var/moodlewww/config.php
echo running upgrade
sudo -u www-data php /var/moodlewww/admin/cli/upgrade.php --non-interactive 

echo copying back original config
cp /home/administrator/moodleupgrade/config.php.multi /var/moodlewww/config.php

echo fixing permissions
/var/fixperm.sh

echo Starting nginx
service nginx start
