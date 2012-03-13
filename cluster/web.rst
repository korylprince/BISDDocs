.. _cluster_web_howto:
.. index:: Cluster, nginx

===================
Cluster Web Service
===================

Installs a web server with PHP and eAccelerator.

Install Software
================
::

$ sudo apt-get install python-software-properties
$ sudo add-apt-repository ppa:nginx/stable
$ sudo apt-get update
$ sudo apt-get dist-upgrade
$ sudo apt-get install nginx php5-fpm php5-gd php5-mysql php5-intl php5-curl php5-xmlrpc php5-ldap git htop php5-dev build-essential
$ sudo mkdir /var/www
$ sudo chmod 755 /var/www
$ sudo chown www-data:www-data /var/www

Configure Software
==================

Edit `/etc/nginx/sites-available/default <web_files/nginx/sites-available/default>`_ to set up hosts.

Edit `/etc/php5/fpm/pool.d/www.conf <web_files/php5/fpm/pool.d/www.conf>`_ to add more php processes

Edit `/etc/php5/fpm/php.ini <web_files/php5/fpm/php.ini>`_ to increase the upload limit.

**Install eAccelerator** ::

$ cd /tmp
$ wget -O eaccelerator-0.9.6.1.tar.bz2 http://downloads.sourceforge.net/project/eaccelerator/eaccelerator/eAccelerator%200.9.6.1/eaccelerator-0.9.6.1.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Feaccelerator%2Ffiles%2Feaccelerator%2FeAccelerator%25200.9.6.1%2F&ts=1323470334&use_mirror=cdnetworks-us-2
$ tar xfj eaccelerator-0.9.6.1.tar.bz2
$ cd eaccelerator-0.9.6.1
$ phpize
$ ./configure
$ make
$ sudo make install
$ sudo mkdir /var/cache/eaccelerator

Create `/etc/php5/conf.d/eaccelerator.ini <web_files/php5/conf.d/eaccelerator.ini>`_ .

Create /var/cache/eaccelerator as tmpfs in `/etc/fstab <web_files/fstab>`_ .

References
==========

https://help.ubuntu.com/community/eAccelerator

`Browse configuration files <web_files/>`_
