.. _cluster_inventory_howto:
.. index:: web2py, python, inventory

==============
BISD Inventory
==============

Install in-house inventory system based on :doc:`web2py <web2py>`

**Requires**

:doc:`web2py`

:doc:`db`

**Recommends**

:doc:`db_manage`

:doc:`lb`

Install Software
================

First we want to create our :doc:`database <db>`. On the :doc:`database <db>` server, run::

    mysql -u<user> -p -e "create database inventory;"

Next we want to remove the example applications::
    
    cd /var/web2py/applications
    sudo rm -Rf examples/ welcome/

Now we install the inventory software::

    sudo git clone http://github.com/korylprince/pyInventory.git 
    sudo mv pyInventory init

*Note: the init application is automatically run if no application is specified in the URL.*

Next we need to patch :doc:`web2py <web2py>` as currently Active Directory groups do not work by default::

    cd /tmp
    wget https://raw.github.com/korylprince/web2py/master/gluon/contrib/login_methods/ldap_auth.py
    sudo mv ldap_auth.py /var/web2py/gluon/contrib/login_methods/ldap_auth.py
    sudo rm /var/web2py/gluon/contrib/login_methods/ldap_auth.pyc
    sudo chmod -R 755 /var/web2py
    sudo chown -R www-data:www-data /var/web2py/
    sudo service uwsgi restart

Finally you will want to edit `/var/web2py/applications/init/models/db.py <inventory_files/db.py>`_ to add your configuration details.

It is usually a good idea to compile your application after getting everything working as it will make performance better. You can do this from the :doc:`web2py <web2py>` admin interface.

Troubleshooting Database Issues
===============================

If you are installing this for a new database, you need to set migrate=True in the model db.py. After the tables are created set migrate back to False.

If you are installing over an existing database, but your database metadata got deleted, set migrate=False,fake_migrate_all=True to create metadata then remove the fake_migrate_all.


References
==========

https://github.com/korylprince/pyInventory

http://www.web2pyslices.com/slice/show/1493/active-directory-ldap-with-allowed-groups

`Browse configuration files <inventory_files/>`_
