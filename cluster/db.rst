.. _cluster_db_howto:
.. index:: Cluster, mysql

========================
Cluster Database Service
========================

Installs MySQL database.

Install software
================
::

	$ sudo apt-get update
	$ sudo apt-get dist-upgrade
	$ sudo apt-get install mysql-server

Optionally install :doc:`phpmyadmin <db_manage>` management.

Configure Software
==================

Allow access to mysql from :doc:`web servers <web>` (ubuntu-web1, ubuntu-web2, etc)::

	mysql> GRANT ALL PRIVILEGES ON <database>.* TO '<user>'@'<server>' IDENTIFIED BY '<password>';

Where <database> is the database that is to be shared,

<user> and <password> account that will access the database, and

<server> is the IP of the :doc:`web server <web>` that will access the database

This needs to be done for each :doc:`web server <web>` that will access the database.

Maintenance
===========

MySQL comes with several utilities to maintain databases. Here are some examples::
 
    # Check tables and repair if needed
    $ mysqlcheck -u<user> -p<password> --all-databases --auto-repair
    # Optimize tables
    $ mysqloptimize -u<user> -p<password> --all-databases

*Note that innodb database (such as those used by* :doc:`moodle <moodle>` *cannot be recovered easily. In the case that an innodb table becomes corrupt, consult the MySQL manual.*

It is not recommended that you run these commands while there are many users using the server as it is processor and disk intensive.

Backup
======

The simplest way to backup your databases (the way we do it here at Bullard ISD) is to use the :file:`mysqldump` command. The command::

    $ mysqldump -u<user> -p<password> <database> >/path/to/backup

Will backup <database> to the path specificed.

A simple script with the above command for each database could be run daily with the cron line::

    @daily /path/to/script

*Note: Use* :file:`crontab -e` *to edit a user's cron tasks.*

Our backup system backs up the filesystem, so each day's backups are backed up that way. See Brackup for backing up the MySQL dumps.

Ken Task has also made his scripts available for use at http://moodle.tcea.org/mysqldbscripts.tar . Simply untar the scripts to an executable location (like :file:`/usr/local/bin/` ) and edit them with the proper username and password. They are meant to be run as root.
