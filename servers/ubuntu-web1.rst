.. _server_ubuntu-web1:
.. index:: web, nginx

==========================
ubuntu-web1.bullardisd.net
==========================

Ubuntu :doc:`Web Server </cluster/web>`

Specifications
==============

    * Mission Critical: Only if :doc:`ubuntu-web2.bullardisd.net <ubuntu-web2>` goes down
    * OS: Ubuntu 11.10 x64
    * CPU: 8 (2 Quad-Core) @ 2.27GHz
    * RAM: 18GB
    * HD: 257GB RAID1

Services
========

    **ssh:** tcp/22

    **http:** tcp/80

    **nfs:** tcp/111

Specifics
=========

    * :doc:`nfs </cluster/data>`:
        * maps /var/moodledata to :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`:/var/moodledata
    * :doc:`nginx </cluster/web>`:
        * runs on port 80, :doc:`Load balanced </cluster/lb>` by :doc:`ubuntu-lb1.bullardisd.net <ubuntu-lb1>`
        * accesses php-fpm on local port 9000 for .php extension
        * :doc:`moodle </cluster/moodle>`:
            * web directory /var/moodlewww:
                * updated via git
                * system links to /var/moodlewww:
                    * /var/www/district
                    * /var/www/elementary
                    * /var/www/high
                    * /var/www/intermediate
                    * /var/www/middle
                    * /var/www/primary
                    * /var/www/test1
            * :doc:`data </cluster/data>` directory /var/moodledata:
                * :doc:`nfs </cluster/data>` on :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`
                    * each :doc:`moodle </cluster/moodle>` has separate directory in /var/moodledata
            * :doc:`database </cluster/db>`: moodle_<moodlename>
                * :doc:`mysql </cluster/db>` on :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`
                    * each :doc:`moodle </cluster/moodle>` has separate database
        * apps:
            * :doc:`web </cluster/web>` directory /var/www/apps
            * :doc:`database </cluster/db>`: apps 
                * :doc:`mysql </cluster/db>` on :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`


Backup
======

None
