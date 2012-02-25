.. _server_ubuntu-vpn:
.. index:: OpenVPN, PPTP

=========================
ubuntu-vpn.bullardisd.net
=========================

Ubuntu OpenVPN and PPTP server

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

    **http:** tcp/80

    **https:** tcp/443

    **openvpn:** udp/1194

    **pptp:** tcp/1723, GRE

    **system5 backup:** tcp/55555

Specifics
=========
    * :doc:`nginx </cluster/web>`:
        * Redirects non-FQDN to FQDN url(e.g. monitor instead of monitor.bullardisd.net)
        * accesses php-fpm on local port 9000 for .php extension
        * /logs:
            * access system logs from a web interface
        * /vpn:
            * create openvpn certificates from the web
            * only accessible from internal network
        * /wiki:
            * mediawiki for sossig
            * Not really in use
            * :doc:`mysql </cluster/db>` runs for this:
                * mediawiki database
    * openvpn:
        * See OpenVPN 
    * pptp vpn:
        * simple vpn for iphone clients
        * Not really used - not entirely reliable
        * User:
            * password file at /etc/ppp/chap-secrets
    * skyward backup:
        * /home/administrator/backup
        * See Brackup Backup
    * projects:
        * git repo for BISD code projects
        * /home/administrator/projects

Backup
======

system5 backup: runs snapshot service
