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

This needs to be done for each web server that will access the database.
