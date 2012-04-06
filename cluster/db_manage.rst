.. _cluster_db_manage_howto:
.. index:: Cluster, mysql, phpmyadmin

===================================
Cluster Database Management Service
===================================

Installs phpmyadmin - web-based :doc:`database <db>` management.

Install software
================
::

	sudo apt-get install python-software-properties
	sudo add-apt-repository ppa:nginx/stable
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get install nginx php5-fpm php5-mysql php5-mcrypt

**phpmyadmin** ::

	cd /tmp
	wget <url - see http://www.phpmyadmin.net/home_page/downloads.php >
	tar xzf <php downloaded file>
	mv <unzipped folder> /var/www/phpmyadmin
	sudo chmod -R 755 /var/www/phpmyadmin
	sudo chown -R www-data:www-data /var/www/phpmyadmin 

Configure Software
==================

Edit `/etc/nginx/sites-available/default <db_manage_files/nginx/sites-available/default>`_ to run web only on localhost.

Edit `/etc/php5/fpm/pool.d/www.conf <db_manage_files/php5/fpm/pool.d/www.conf>`_ to only run a few php processes.

Edit `/etc/php5/fpm/php.ini <db_manage_files/php5/fpm/php.ini>`_ to increase the upload limit.

This will give you a basic install. To use more advanced features see http://www.phpmyadmin.net/documentation/#quick_install .

Management
==========

Using this setup makes the web server run only on localhost for security. To access phpmyadmin forward ports with ssh::

	ssh -L 8080:localhost:80 <user>@<database server>

Then browse to http://localhost:8080/phpmyadmin/

References
==========

`Browse configuration files <db_manage_files/>`_
