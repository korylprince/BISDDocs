.. _cluster_moodle_howto:
.. index:: Cluster, moodle

======
Moodle
======

Installs Moodle in a clustered environment. With this setup multiple moodle installations use the same Web Codebase at :file:`/var/moodlewww`. This allows for quicker upgrades, but does not allow moodles to be upgraded separately. Thus it is recommended that testing moodles are installed with a separate codebase.

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

`fixperm.sh <web_files/fixperm.sh>`_ is a useful script to fix the permissions of the moodle web and data files.

Configure Software
==================

Edit `/var/moodlewww/config.php <moodle_files/moodlewww/config.php>`_ to allow multiple moodles to use the same codebase and to allow proxying.

See :doc:`web` for setting up web server.

See :doc:`db` for setting up database server.

*Note: the database must use utf8_unicode_collation.*::

    mysql> ALTER DATABASE <datbase_name> DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci

*and must use innodb (should be default.)*

See :doc:`data` for setting up shared moodledata directory.

See :doc:`lb` for load balancing more than one moodle server.

Updating Setup
==============

To set up automatic updates each moodle site must have its own separate :file:`config.php` file. This is how we did it::

    $ cd /home/administrator/
    $ mkdir moodleupgrade
    $ cd moodleupgrade
    $ cp /var/moodlewww/config.php ./config.php.multi
    $ cp config.php.multi config.php.test1
    $ cp config.php.multi config.php.district
    $ cp config.php.multi config.php.high
    $ cp config.php.multi config.php.middle
    $ cp config.php.multi config.php.intermediate
    $ cp config.php.multi config.php.elementary
    $ cp config.php.multi config.php.primary

Edit each :file:`config.php` to remove the multi-site parts (Except for :file:`config.php.multi` - this is a copy of your current :file:`config.php` that needs to left alone.) See `config.php.site <moodle_files/moodleupgrade/config.php.site>`_ .

Make sure the `fixperm.sh <web_files/fixperm.sh>`_ is at :file:`/var/fixperm.sh` . And now copy `upgrade.sh <moodle_files/moodleupgrade/upgrade.sh>`_ to :file:`/home/administrator/moodleupgrade/upgrade.sh` and edit it for all your sites (simply copy, paste and edit.)

Do this on each moodle :doc:`Web <web>` server. 

Updating
========

After using the above method on each web server, you are ready to update. First, to be nice to your users, you should probably change your moodle site to point to a maintenance page.

Next shut down nginx on each of your :doc:`Web <web>` servers::

    $ sudo service nginx stop

Next, on **only** one of your :doc:`Web <web>` servers run::

    $ sudo /home/administrator/moodleupgrade/upgrade.sh

This will upgrade all the moodles non-interactively and start that web server. Next run the same command on all the other moodle :doc:`Web <web>` servers, one at a time. This will upgrade the moodle files on that server and start nginx. It won't "reupgrade" the database as the moodle upgrade script checks for that. After you have run the above command on all your :doc:`Web <web>` servers, the upgrade is finished.

*Note that this process is easily scriptable, but it is recommended that you run it manually each time to ensure nothing goes wrong. The process takes only a couple minutes max.*

If you would simply like to upgrade the moodle web files, and run the upgrade for each moodle in a web browser, run::

    $ cd /var/moodlewww
    $ sudo git checkout .
    $ sudo git pull origin MOODLE_XX_STABLE
    $ sudo /var/fixperm.sh

Then browse to your moodle sites with a browser to complete the upgrade for each moodle site.

References
==========

`Browse configuration files <moodle_files/>`_
