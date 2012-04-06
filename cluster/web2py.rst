.. _cluster_web2py_howto:
.. index:: web2py, python

==============
web2py Service
==============

Installs `web2py <http://www.web2py.com/>`_, a python-based web framework. We use web2py for our in-house Inventory system.

*Note that web2py can be deployed without nginx, but it integrates nicely into our system this way.*

Install Software
================
::

    sudo apt-get install git unzip nginx uwsgi uwsgi-plugin-python python-ldap
    cd /tmp
    wget http://www.web2py.com/examples/static/web2py_src.zip
    unzip web2py_src.zip
    sudo mv /tmp/web2py /var/web2py
    sudo chmod -R 755 /var/web2py
    sudo chown -R www-data:www-data /var/web2py/

*Note that uwsgi is only available for Ubuntu 11.10 and later.*

Now edit `/etc/uwsgi/apps-available/web2py.ini <web2py_files/web2py.ini>`_ and `/etc/nginx/sites-available/default <web2py_files/default>`_ to add the needed configuration. Next run::

    sudo ln -s /etc/uwsgi/apps-available/web2py.ini /etc/uwsgi/apps-enabled/web2py.ini
    sudo service uwsgi restart
    sudo service nginx restart

Now we need to enable the admin interface for web2py. Run::
    
    cd /var/web2py
    sudo -u www-data ./web2py.py --nogui
    # (enter password, press enter then ctrl-c)
    sudo mv parameters_8000.py parameters_80.py

To disable the admin interface (for security reasons) run::

    sudo rm /var/web2py/parameters_80.py

This will leave you with a fully functional web2py. There are several ways to deploy web2py, but this will integrate with our :doc:`cluster <index>` the easiest. See :doc:`inventory` for an idea of how to deploy a web2py application.

References
==========

http://web2py.com/book

`Browse configuration files <web2py_files/>`_
