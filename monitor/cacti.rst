.. _monitor_cacti_howto:
.. index:: Monitor, cacti

=====
Cacti
=====

Cacti is a monitoring software that we use to monitor bandwidth on our switches as well as keep track of mac addresses.

We use cacti on our :doc:`../servers/ubuntu-monitor` server which is part of our :doc:`web cluster <../cluster/index>`.

Ubuntu provides packages for cacti and spine, but they require apache, and don't include the Plugin Architecture. Luckily, it's not very hard to set up on our own.

We use the `Realtime <http://docs.cacti.net/plugin:realtime>`_, `Weathermap <http://docs.cacti.net/userplugin:weathermap>`_, and `Mactrack <http://docs.cacti.net/plugin:mactrack>`_ plugins.

**Requires**

:doc:`../cluster/db`

:doc:`../cluster/web`

**Recommends**

:doc:`../cluster/db_manage`

:doc:`../cluster/lb`

Install Cacti
=============
::

    sudo apt-get install libdbd-mysql-perl libdbi-perl libnet-daemon-perl libplrpc-perl mysql-client php5-snmp rrdtool snmp ttf-dejavu ttf-dejavu-extra php5-cli snmp libmysqlclient-dev debhelper libsnmp-dev po-debconf dh-autoreconf unzip quilt snmp-mibs-downloader
    cd /var/www/
    wget http://www.cacti.net/downloads/cacti-0.8.7i-PIA-3.1.tar.gz
    tar xzf cacti-0.8.7i-PIA-3.1.tar.gz
    rm cacti-0.8.7i-PIA-3.1.tar.gz
    mv cacti-0.8.7i-PIA-3.1 cacti
    cd cacti/plugins
    wget http://docs.cacti.net/_media/plugin:mactrack-v2.9-1.tgz 
    wget http://docs.cacti.net/_media/plugin:realtime-v0.5-2.tgz
    wget http://www.network-weathermap.com/files/php-weathermap-0.97a.zip
    unzip php-weathermap-0.97a.zip
    mv plugin\:mactrack-v2.9-1.tgz mactrack.tar.gz
    mv plugin\:realtime-v0.5-2.tgz realtime.tar.gz
    tar xzf mactrack.tar.gz
    tar xzf realtime.tar.gz
    rm php-weathermap-0.97a.zip mactrack.tar.gz realtime.tar.gz

*Note: During this process it may be easiest to run* ::

    chmod -R 777 /var/www/

*and then use* `fixperm.sh <../cluster/web_files/fixperm.sh>`_ *afterwards to fix permissions.*

This gets all the php files set up. Now we need to configure the :doc:`Database <../cluster/db>`. Using whatever method you desire (we used :doc:`phpmyadmin <../cluster/db_manage>`) create a new database named cacti and import :file:`/var/www/cacti/cacti.sql` into it.

You could use something like::

    cd /var/www/cacti
    mysql -u<user> -p<pass> -h<db-host>
    mysql> create database cacti;
    mysql> quit;
    mysql -u<user> -p<pass> -h<db-host> cacti<cacti.sql

*Note: if your <db-host> is remote, you might need to add* :file:`--port 3306` *to the command.*

Now you need to edit `/var/www/cacti/include/config.php <cacti_files/config.php>`_ and replace the database name, host, username, password, and url path to match your configuration.

Finally, all that's left is to add a cron job for cacti. Run::

    sudo -u www-data crontab -e

Then insert the following line::

    */5 * * * * php /var/www/cacti/poller.php > /dev/null 2>&1

Now restart nginx and php5-fpm::

    sudo service nginx restart
    sudo service php5-fpm restart

And open a web browser and point to your new installation. Run through the first few steps, then log in with admin/admin. You will be asked to change your password.

Next go to Utilities->User Management->admin and select the Plugin Management checkbox and save.

Next go to Configuration->Plugin Management and install/enable the three plugins.

Now go back to Utilities->User Management->admin and select the 3 mactrack checkboxes and save.

At this point you have cacti that is ready to be filled with information.

One step you will want to take is to create a directory for the realtime plugin. :file:`/var/www/cacti/rra/realtime/` would be a good choice.

It would also be good to block some cacti directories from prying eyes. See `/etc/nginx/sites-available/default <cacti_files/default>`_ for more information. 

Also, don't forget to fix permissions on your web directory (use `fixperm.sh <../cluster/web_files/fixperm.sh>`_.)

Install Spine
=============

Now cacti is set up, but if you have a lot of switches, the php poller can get bogged down. `Spine <http://www.cacti.net/spine_info.php>`_ is a better alternative. 

To install run::

    cd /tmp
    wget http://www.cacti.net/downloads/spine/cacti-spine-0.8.7i.tar.gz
    tar xzf cacti-spine-0.8.7i.tar.gz
    cd cacti-spine-0.8.7i
    ./configure --prefix=/usr --sysconfdir=/etc
    make

You may have issues with the configure command. (This seems to happen on Ubuntu Precise currently.) If that is the case then run::

    mkdir /tmp/build
    cd /tmp/build
    apt-get source -b cacti-spine
    cd cacti-spine-0.8.7i

Now after doing one of the above, run::

    sudo make install
    sudo cp spine.conf.dist /etc/spine.conf
    sudo rm /etc/spine.conf.dist
    sudo chmod 640 /etc/spine.conf
    sudo chown root:www-data /etc/spine.conf

And edit `/etc/spine.conf <cacti_files/spine.conf>`_ with the same parameters as in `/var/www/cacti/include/config.php <cacti_files/config.php>`_.

Now in cacti go to Configuration->Settings->Paths and set :file:`Spine Poller File Path` to :file:`/usr/bin/spine`.

Next go to Configuration->Settings->Poller and change :file:`Poller Type` to :file:`spine`.

Monitor cacti to make sure it is updating correctly. Cacti is now ready for high traffic.

References
==========

http://www.cacti.net/

`Browse configuration files <cacti_files/>`_
