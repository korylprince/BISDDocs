.. _monitor_ipcheck_howto:
.. index:: Monitor, IPCheck

=======
IPCheck
=======

IPCheck is an in house PHP application written by Kory Prince. It is a simple intface that checks if an IP is up or down. It can also do some Ping tests. It's goal is to be simple and usable.

IPCheck uses `KAuth <https://github.com/korylprince/KAuth>`_, also written by Kory. This allows for Active Directory single sign on.

We use IPCheck on our :doc:`../servers/ubuntu-monitor` server which is part of our :doc:`web cluster <../cluster/index>`.

**Requires**

:doc:`../cluster/web`

**Recommends**

:doc:`../cluster/lb`

Install IPCheck
===============

::

$ cd /var/www/
$ sudo git clone https://github.com/korylprince/IPCheck.git
$ sudo mv IPCheck/ ipcheck
$ cd ipcheck/auth/
$ sudo cp options.php.def options.php
$ sudo cp users.list.def users.list

At this point fix permissions (with `fixperm.sh <../cluster/web_files/fixperm.sh>`_).

You now have a working installation you can go to. To change the default password run::

$ php mkpasswd.php <password>

And edit :file:`users.list` with the new hash.

To change your IPs, edit `options.php <ipcheck_files/options.php>`_ and add your IPs to the $iplist array. (See References_ for help.)

Active Directory Logins
=======================

To enable active directory logins, we need to edit `options.php <ipcheck_files/options.php>`_.

As an overview, our options look something like ::

    $types = array('ldap_ad','session');
    $options['auths_location'] = '';

    /* ldap_ad */
    $options['ldap_ad_server'] = 'server.example.com';
    $options['ldap_ad_port'] = 389; 
    $options['ldap_ad_domain'] = 'example.com';
    $options['ldap_ad_allowed_groups'] = array('CN=Allowed Group,OU=Goups,DC=example,DC=com');

So all you should have to do is take the provided `options.php <ipcheck_files/options.php>`_ , change the types to have :file:`ldap_ad` instead of :file:`password_file`, and then change the ldap options to match your server. We use the :file:`ldap_ad_allowed_groups` option to only allow Domain Admins to use IPCheck.

References
==========

https://github.com/korylprince/IPCheck

`Browse configuration files <ipcheck_files/>`_
