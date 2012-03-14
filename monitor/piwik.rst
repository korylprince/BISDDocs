.. _monitor_piwik_howto:
.. index:: Monitor, piwik, Web Analytics

===================
Piwik Web Analytics
===================

Piwik is a simple to install Web Analytics software. We use it to monitor the visitors to our Home Page.

We use Piwik on our :doc:`../servers/ubuntu-monitor` server which is part of our :doc:`web cluster <../cluster/index>`.

**Requires**

:doc:`../cluster/web`

:doc:`../cluster/db`

**Recommends**

:doc:`../cluster/db_manage`

:doc:`../cluster/lb`

Install Piwik
=============

::

$ cd /var/www/
$ sudo wget http://piwik.org/latest.zip
$ sudo unzip latest.zip
$ sudo mv piwik stats
$ sudo rm latest.zip How\ to* 

Now run `fixperm.sh <../cluster/web_files/fixperm.sh>`_ to fix permissions.

Next create a database named piwik on your :doc:`Database <../cluster/db>` server.

Finally browse to your website to do the Piwik installation.

Fill out the different parameters taking special care to fill in the correct URL. This should be the Fully Qualified Domain Name of your site. For instance our URL is https://monitor.bullardisd.net/stats

At the end of the installation you will be given javascript code that you need to copy to your website that you want to monitor. It will need to be on every page you monitor, so try to put it in a template that is on every page.

Once Piwik is installed you can add more websites to monitor. See References_ for more help.

References
==========

http://piwik.org/

