.. _cluster_server_howto:
.. index:: Cluster

====================
Cluster Server Setup
====================

Installs the Server OS.

Installing Server
=================
**Configure RAID with uEFI Configuration Wizard:**

	* Configure the Addons and use the web option

**Install Ubuntu Server 11.10 x64:**

	* Set Hostname
	* Select OpenSSH server from List

**Configure Networking:**

Install ifenslave::

	sudo apt-get install ifenslave

Update `/etc/network/interfaces <server_files/network/interfaces>`_ to use interface bonding for failover.

References
==========
https://help.ubuntu.com/community/UbuntuBonding

`Browse configuration files <server_files/>`_
