.. _fw_howto:
.. index:: OpenBSD, PF, Firewall, Router

======================
OpenBSD Firewall
======================

This is a basic summary for installing OpenBSD and setting it up as a firewall/gateway using PF.

Installing Server
=================
Use amd64 OpenBSD 4.9

**Accept all defaults except for the following:**

* At system hostname use fw
* Type in root password
* Type no for X window System
* Type administrator for setup user
* Type in administrator password
* When formatting the disk use (W)hole then (A)uto layout

Configuration
=============
**Log in as root and edit the following files:**

(See :ref:`config_files`)

* Add the line ``administrator ALL=(ALL) ALL`` in `/etc/sudoers <files/sudoers>`_ so administrator can use sudo
* Change DNS servers in `/etc/resolv.conf <files/resolv.conf>`_
* Edit `/etc/sysctl.conf <files/sysctl.conf>`_ to enable IP forwarding
* Edit `/etc/mygate <files/mygate>`_ to add default gateway
* Set up the firewall rules in `/etc/pf.conf <files/pf.conf>`_ and `/etc/pf/ <files/pf/>`_
* Set up network interface configurations in `/etc/hostname.bge0 <files/hostname.bge0>`_ and `/etc/hostname.bge1 <files/hostname.bge1>`_ (Interfaces may be different.)
* Remove services not needed from `/etc/inetd.conf <files/inetd.conf>`_

PF Configuration
================
The PF configuration makes use of PF anchors. The file tree is:

* :file:`/etc/pf.conf` - Main PF Configuration file
* :file:`/etc/pf.conf`.old - Old Main PF Configuration file for reference
* :file:`/etc/pf/` - folder containing the rest of the configuration

	* :file:`global.txt` - contains some global options and definitions
	* :file:`anc/` - contains anchors for PF
		* :file:`core_bullard/` - firewall specific rules
			* :file:`pf.txt` - rules about passing firewall traffic
			* :file:`tab/self.txt` - contains fw's IP
		* :file:`net/` - rules for all traffic
			* :file:`pf.txt` - Rules for passing allowed ports
			* :file:`ports.txt` - file describing what each port is used for
		* :file:`<server>/` - anchor for each public IP
			* :file:`pf.txt` - PF rules for specific anchor
				* :file:`tab/` - Tables for specific anchor
					* :file:`admin.txt` - specific table for ssh access
					* :file:`blacklist.txt` - specific blacklist
					* :file:`whitelist.txt` - specific whitelist
	* :file:`tab/` - contains global tables
		* :file:`admin.txt` - global table to allow ssh access
		* :file:`blacklist.txt` - global blacklist
		* :file:`nat_for.txt` - table containing all NATed addresses
		* :file:`whitelist.txt` - global whitlist

Management
==========
To restart the networking (in case something gets unplugged) run in the following order::

	sudo pfctl -f /etc/pf.conf
	sudo sh /etc/netstart

To view loaded rules (to use in conjunction with Monitoring below) run::

    sudo pfctl -g -s rules

And to view the rules in an anchor run::

    sudo pfctl -a "<anchor name>" -g -s rules

where <anchor name> would be ubuntu-lb1 for example.

To check if an address is in a table, first list tables with::

    sudo pfctl -s Tables

Then list the addresses in a table with::

    sudo pfctl -t <table name> -T show

Where <table name> is a table from the previous command.

**How the Template Works**

Anchors are used for efficiency. Only packets that apply to an anchor go into it, so not all rules are read for each packet. Normal traffic is handled with the net anchor. All open outbound ports for normal traffic are listed here.

Each external IP (i.e. a server) has it's own anchor (TEMPLATE.)
Each anchor has its own separate whitelist, blacklist, and admin tables.
Each anchor also has its own outbound and inbound ports (the net anchor does not affect the IPs in these anchors.)

**Monitoring:** 

Monitoring can be done with :file:`tcpdump` 
To look at all traffice going through the firewall run::

	sudo tcpdump -eee -n -i pflog0

To look at a single host::

	sudo tcpdump -eee -n -i pflog0 host <ip address or dns name>

To look at a single port::

	sudo tcpdump -eee -n -i pflog0 port <port>

These and more options can be chained with :file:`and` and :file:`or`::

	sudo tcpdump -eee -n -i pflog0 net 192.168.100.0/24 and port 80

View the man page for :file:`tcpdump` for complete filtering usage.


References
==========
http://www.openbsd.org/faq/


.. _config_files:

`Browse configuration files <files/>`_
""""""""""""""""""""""""""""""""""""""
