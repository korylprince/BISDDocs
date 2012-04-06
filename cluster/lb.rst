.. _cluster_lb_howto:
.. index:: Cluster, nginx, load balancer

=============================
Cluster Load Balancer Service
=============================

Installs an http load balancer.

Install Software
================
::

	sudo apt-get install python-software-properties
	sudo add-apt-repository ppa:nginx/stable
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get install nginx

Configure Software
==================

Edit `/etc/nginx/sites-available/default <lb_files/nginx/sites-available/default>`_ to set up upstream servers.

Make sure to copy SSL certs:
	* :file:`server.key` to :file:`/etc/ssl/private/` - Private Key
	* :file:`chained.pem` to :file:`/etc/ssl/` CA certificate

DNS Setup
=========

If the hostname clients go to is server.example.com and the load balancer is ubuntu-lb1.example.com, then set a DNS record like::

	server.example.com 300 IN CNAME ubuntu-lb1.example.com

Note: The webserver (nginx) handles the load balancing.

References
==========

`Browse configuration files <lb_files/>`_
