.. _server_ns:
.. index:: DHCP, DNS

=================
ns.bullardisd.net
=================

Ubuntu DHCP/DNS Server

Specifications
==============

    * Mission Critical: Yes
    * OS: Ubuntu 11.04 x64
    * CPU: 2 (1 Dual-Core) @ 2.13GHz
    * RAM: 2GB
    * HD: 2 x 142GB (One not in use)

Services
========

    **ssh:** tcp/22

    **dns:** tcp/53

    **dhcp:** udp/67

    **tftp:** udp/69

    **http:** tcp/80

    **ntp:** udp/123

    **https:** tcp/443

    **system5 backup:** tcp/55555

Specifics
=========

    * dhcp:
        * see documentation
    * dns:
        * see documentation
        * syncs with :doc:`ubuntu-monitor.bullardisd.net <ubuntu-monitor>`
    * pxe boot:
        * uses dhcpd and tftp server
    * ntp:
        * accessible ntp server
    * nginx:
        * Redirects non-FQDN to FQDN url (e.g. redirects monitor to monitor.bullardisd.net)
        * accesses php-fpm on local port 9000 for .php extension
        * /logs:
            * access system logs from a web interface

Backup
======

system5 backup: runs snapshot service
