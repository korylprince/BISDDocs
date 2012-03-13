.. _server_monitor:
.. index:: cacti, ipcheck, piwik

=============================
ubuntu-monitor.bullardisd.net
=============================

Ubuntu Network Monitoring Server

Specifications
==============

    * Mission Critical: Not Entirely
    * OS: Ubuntu 11.04 x64
    * CPU: 2 (1 Dual-Core) @ 2.13GHz
    * RAM: 2GB
    * HD: 2 x 142GB (One not in use)

Services
========

    **ssh:** tcp/22

    **dns:** tcp/53

    **http:** tcp/80

    **system5 backup:** tcp/55555

Specifics
=========

    * dns:
        * See DNS
        * slave for :doc:`ns.bullardisd.net <ns>`
    * :doc:`nginx </cluster/web>`:
        * runs on port 80, :doc:`Load balanced </cluster/lb>` by :doc:`ubuntu-lb1.bullardisd.net <ubuntu-lb1>`
        * accesses php-fpm on local port 9000 for .php extension
        * :doc:`/cacti <../monitor/cacti>`:
            * :doc:`monitoring <../monitor/index>` software (used for switches)
            * uses :doc:`monitor_cacti <../monitor/cacti>` database on :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`
            * uses :doc:`spine <../monitor/cacti>`
        * /handbook:
            * online district handbook signing
            * users monitor_handbook database on :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`
        * /ipcheck:
            * ipchecker
        * /linux:
            * unfinished old linux howto
        * /logs:
            * access system logs from a web interface
        * /stats:
            * piwik - web analytics
            * uses monitor_piwik database on :doc:`ubuntu-db1.bullardisd.net <ubuntu-db1>`

Backup
======

    system5 backup: runs snapshot service
