.. _cluster_moodle_howto:
.. index:: Cluster, moodle

======
Moodle
======

Installs Moodle in a clustered environment. With this setup multiple moodle installations use the same Web Codebase at :file:`/var/moodlewww`.

In this setup the moodle databases lie on an external server - ubuntu-db1.example.com.

The moodledata directory is an NFS share from ubuntu-db1.example.com and is mounted on :file:`/var/moodledata`.

Install Software
================

**Moodle** ::

	$ cd /var/
	$ sudo git clone git://git.moodle.org/moodle.git moodlewww
	$ cd /var/moodlewww/
	$ sudo git checkout origin/MOODLE_XX_STABLE
	$ sudo chown -R www-data:www-data /var/moodlewww
	$ sudo chmod -R 755 /var/moodlewww
	$ sudo mkdir /var/www
	$ sudo ln -s /var/moodlewww /var/www/primary
	$ sudo ln -s /var/moodlewww /var/www/elementary
	$ sudo ln -s /var/moodlewww /var/www/intermediate
	$ sudo ln -s /var/moodlewww /var/www/middle
	$ sudo ln -s /var/moodlewww /var/www/high
	$ sudo ln -s /var/moodlewww /var/www/district
	$ sudo chown -R www-data:www-data /var/www
	$ sudo chmod -R 755 /var/www
	$ sudo chown -R www-data:www-data /var/moodledata
	$ sudo chmod -R 755 /var/moodledata

(MOODLE_XX_STABLE should be replaced with current version, i.e. as of this writing it is MOODLE_22_STABLE)

Configure Software
==================

Edit `/var/moodlewww/config.php <moodle_files/moodlewww/config.php>`_ to allow multiple moodles to use the same codebase and to allow proxying.

See :doc:`web` for setting up web server.

See :doc:`db` for setting up database server.

See :doc:`data` for setting up shared moodledata directory.

See :doc:`lb` for load balancing more than one moodle server.

References
==========

`Browse configuration files <lb_files/>`_
