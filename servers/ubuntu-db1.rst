.. _server_ubuntu-db1:
.. index:: database, data

=========================
ubuntu-db1.bullardisd.net
=========================

Ubuntu :doc:`Database </cluster/db>`/:doc:`Data </cluster/data>` Server

Specifications
==============

    * Mission Critical: Yes
    * OS: Ubuntu 11.10 x64
    * CPU: 16 (4 Quad-Core) @ 2.13GHz
    * RAM: 64GB
    * HD: 2TB RAID5

Services
========

    **ssh:** tcp/22

    **nfs:** tcp/111, tcp/2049

    **mysql:** tcp/3306

    **system5 backup:** tcp/55555

Specifics
=========

    * :doc:`mysql </cluster/db>`:
       * accessible from:

           * :doc:`ubuntu-web1.bullardisd.net <ubuntu-web1>`
           * :doc:`ubuntu-web2.bullardisd.net <ubuntu-web2>`

                * :doc:`moodle </cluster/moodle>` databases
                * apps database

            * :doc:`ubuntu-monitor.bullardisd.net <ubuntu-monitor>`
                * :doc:`monitor_cacti <../monitor/cacti>`
                * monitor_handbook
                * monitor_piwik

    * :doc:`nfs </cluster/data>`:
        * accessible from:
            * :doc:`ubuntu-web1.bullardisd.net <ubuntu-web1>`
            * :doc:`ubuntu-web2.bullardisd.net <ubuntu-web2>`
        * exports:
            * /var/moodledata

    * :doc:`phpmyadmin </cluster/db_manage>`:
        * accessible only from 127.0.0.1:80

            *  ``$ ssh -L 8080:localhost:80 administrator@ubuntu-db1``
            * Browse to http://localhost:8080/phpmyadmin/

        * Users:

Backup
======

   * system5 backup:
        * runs snapshot service

    * cacti database backup:
        * /home/administrator/cactibackup.sh
            * run weekly
            * backed up to ubuntu-kory2 weekly
              
    * inventory database backup:
        * /home/administrator/invbackup.sh
            * run daily
            * backed up to ubuntu-kory2 weekly

    * :doc:`moodle </cluster/moodle>` database backup:
        * /home/administrator/moodlebackup.sh
            * run daily
