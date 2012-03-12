#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
chown -R www-data:www-data /var/www/
chown -R www-data:www-data /var/moodlewww/
chmod -R 775 /var/www/
chmod -R 775 /var/moodlewww/
