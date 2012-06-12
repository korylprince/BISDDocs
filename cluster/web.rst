.. _cluster_web_howto:
.. index:: Cluster, nginx

=======================
Cluster PHP Web Service
=======================

Installs a web server with PHP and APC (accelerator.)

Install Software
================
::

    sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get install nginx php5-fpm php5-cli php5-gd php5-mysql php5-intl php5-curl php5-xmlrpc php5-ldap php-apc
    sudo mkdir /var/www
    sudo chown www-data:www-data /var/www

Configure Software
==================

Edit `/etc/nginx/sites-available/default <web_files/nginx/sites-available/default>`_ to set up hosts.

Edit `/etc/php5/fpm/pool.d/www.conf <web_files/php5/fpm/pool.d/www.conf>`_ to add more php processes

Edit `/etc/php5/fpm/php.ini <web_files/php5/fpm/php.ini>`_ to increase the upload limit.

Edit `/etc/php5/conf.d/apc.ini <web_files/php5/conf.d/apc.ini>`_ to increase the cache size for APC (Be careful with this option if you have low server memory.)

References
==========

`fixperm.sh <web_files/fixperm.sh>`_ is a useful little script to repair permissions (edit it for your situation.)

`Browse configuration files <web_files/>`_
