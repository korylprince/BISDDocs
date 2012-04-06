.. _brackup_howto:
.. index:: backup, brackup

==============
Brackup Backup
==============

Brackup is an easily configurable incremental backup system. We use a bash script to create a nice log and give email reports.
In our case we back up two large Skyward Database files each night that we copy from an smb share. Our approach is easily fitted to other situations, however.

We recommend reading the brackup documentation at the link in References_ below.

Install Software
================
::

    sudo apt-get install build-essential libnet-sftp-foreign-perl
    sudo cpan

Enter yes for all prompts until you arrive at the cpan[1]>  prompt::

    cpan[1]> install Brackup

Enter yes for all prompts until done::

    cpan[1]> exit

Configure Software
==================

Host
^^^^

The host needs nothing more than an ssh server installed.

To automate the backup process, it is recommended that Public Key authentication be enable for the user. On Ubuntu this is as simple as running a few commands on the client::

    # To generate private key if one does not exist
    ssh-keygen
    # Take defaults
    ssh-copy-id user@host

You should then be able to log into the host without a password.

Client
^^^^^^

First, `~/.brackup.conf <files/brackup.conf>` must be configured correctly. At a basic level, there are sources - Where the files to be backed up are located, and targets - where the files are to be backed up to.

Next create the directory structure::

    mkdir ~/backup
    cd ~/backup
    mkdir bisdadmin2 #used for smb 
    mkdir bisdadmin2a #used for smb
    mkdir files
    mkdir backup_files
    mkdir logs

*Note that bisdadmin2 and bisdadmin2a are directories used for mounting smb shares. They may not be needed in your situation (and definitely not with those names.)*

Set up Script Dependencies
==========================

Install needed packages::

    sudo apt-get install mutt ssmpt

**Email Reports:**

:file:`ssmpt` is a simple program that allows you to send email from the terminal (send only), and mutt is a terminal email client that we interface with. First we need to install the programs::


    sudo apt-get install mutt ssmpt

Now just edit `/etc/ssmpt/ssmpt.conf <files/ssmpt.conf>` and add your mail server and host name.

**SMB Share Mounting**

Files are backed up directly from SMB shares, so we add these shares to `/etc/fstab <files/fstab>` to automate the process.

With this is place normal users can mount the SMB share (which we need for the script since it runs as a normal user.)

**Script**

`backup.conf <files/backup.conf>` is the simple bash script that ties everything together. Simply edit the file with parameters that match your situation and give it a go. If you want help with this script see contact information at the bottom of the screen.


**Create Cron Job**

To automate the backup, we use cron. Edit crontab and insert the line: ::

    crontab -e

    0	19	*	*	*	~/backup.sh

To have the script run every night at 7:00PM, for example.

Restoring
=========

So far we have the backup system running and making backups. Now we just need to be able to restore.

Brackup is very efficient at storing files, especially revisionable files. It stores files in chunks, so you cannot simply browse the server and retrieve files. Instead you must use the :file:`brackup-restore` command.

To restore with brackup, you need a brackup file. The script saves them to :file:`~/backup/backup_files`, but you can also retrieve it from the server.

First we list available backups using::

    brackup-target <target_name> list_backups

Then, after choosing which backup we want, we run::

    brackup-target <target_name> get_backup <backup_name>

This will put the brackup file in your current directory. Finally we restore with::

    brackup-restore --from=<backupfile> --to=/directory/to/restore/to/ --all

*Note: you can replace --all with --just=<file or directory> to restore that file or directory only.*

References
==========

http://search.cpan.org/~bradfitz/Brackup-1.10/

`Browse configuration files <files/>`_
