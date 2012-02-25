.. _server_ubuntu-lb1:
.. index:: lb, nginx

=========================
ubuntu-lb1.bullardisd.net
=========================

Ubuntu :doc:`Load Balancer </cluster/lb>`

Specifications
==============

    * Mission Critical: Yes
    * OS: Ubuntu 11.10 x64
    * CPU: 2 (1 Dual-Core) @ 2.13GHz
    * RAM: 2GB
    * HD: 2 x 145GB (One not in use)

Services
========

    **ssh:** tcp/22

    **http:** tcp/80
    
    **https:** tcp/443

Specifics
=========

    * :doc:`load balancer </cluster/lb>`:
        * DNS:
            * CNAMEs:
                * monitor.bullardisd.net
                * helpdesk.bullardisd.net
                * moodle.bullardisd.net
                * docs.bullardisd.net
                * vpn.bullardisd.net

        * :doc:`nginx </cluster/lb>`:
            * Redirects port 80 to 443
            * Redirects non-FQDN to FQDN url (e.g. monitor instead of monitor.bullardisd.net)
            * https frontend, http backend
            * Checks hostname for backend:
                * monitor.bullardisd.net or 
                * helpdesk.bullardisd.net or
                * docs.bullardisd.net
                    * :doc:`ubuntu-monitor.bullardisd.net <ubuntu-monitor>`
                * :doc:`moodle.bullardisd.net </cluster/moodle>`
                    * :doc:`ubuntu-web1.bullardisd.net <ubuntu-web1>` 
                    * :doc:`ubuntu-web2.bullardisd.net <ubuntu-web2>`
                * vpn.bullardisd.net
                    * :doc:`ubuntu-vpn.bullardisd.net <ubuntu-vpn>`

Backup
======

None
