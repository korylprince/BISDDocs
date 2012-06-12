.. _cluster_data_howto:
.. index:: Cluster, data, nfs

====================
Cluster Data Service
====================

Installs NFS for file sharing.

Install Software
================
::

    sudo mkdir <datadir>
    sudo chown -R www-data:www-data <datadir>
    sudo apt-get install nfs-kernel-server

Note: Replace <datadir> with data directory. For instance with moodle use :file:`/var/moodledata`

Configure Software
==================

Edit `/etc/exports <data_files/server/exports>`_ to export <datadir> to the :doc:`web servers <web>` (ubuntu-web1, ubuntu-web2, etc.)

Configure Client Software
=========================

On :doc:`Web Servers <web>`:

::

    sudo apt-get install nfs-common
    sudo mkdir <datadir>

Edit `/etc/fstab <data_files/client/fstab>`_ to add the NFS share permanently to the filesystem.

References
==========

https://help.ubuntu.com/community/SettingUpNFSHowTo

`Browse configuration files <data_files/>`_
