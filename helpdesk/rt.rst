.. _helpdesk_howto:
.. index:: rt, request tracker, helpdesk, perl, sms

========================
Request Tracker Helpdesk
========================

Installs `Request Tracker 4.0.5 (RT4) <http://bestpractical.com/rt/>`_ helpdesk system with some extras.

*Note: This install assumes you have Ubuntu 11.10, and may not work on other versions.*

**Requires**

:doc:`../cluster/db`

**Recommends**

:doc:`../cluster/db_manage`

:doc:`../cluster/lb`

Runs on :doc:`../servers/ubuntu-monitor` with a :doc:`database <../cluster/db>` on :doc:`../servers/ubuntu-db1` and :doc:`load balanced <../cluster/lb>` by :doc:`../servers/ubuntu-lb1`.

.. _rationale:

Rationale
=========

RT can be used for a wide variety of areas. With a little work, it can become very useful.

We use RT for our IT and Maintenance tickets. We have two emails, itsupport and maintenance. Emailing the itsupport email will create a ticket in the Technology queue, and emailing the maintenance email will put the ticket in the Maintenance queue.

There are also two user groups in RT, Technology and Maintenance.

Each only sees their respective queue. This way it's like the helpdesk system is two totally separate helpdesks, both visible only to the root user (or anyone you make a superuser.)

There are also several other queues for each group - Campus/Network/Warranty/etc for Technology and Electrical/Plumbing/etc for Maintenance.

Users are authenticated from Active Directory for Single Sign On. We allow logins from users in a Domain RT Users group.

These users are allowed to log in and manage tickets in their respective queues.

All other users (those who create tickets) interact with the helpdesk only though email, and have no idea these separate queues even exist.

We use an almost default system, only adding queues, and permissions for anyone to create a ticket.

We currently use one script to send SMS messages when a user has been assigned a ticket.

Install Software
================

Ubuntu does not currently have the needed RT packages to work with nginx. However Debian packages exist that work nicely::

    sudo apt-get install nginx fetchmail ssmtp libfcgi-perl mysql-client
    mkdir /tmp/debs
    cd /tmp/debs
    wget http://ftp.us.debian.org/debian/pool/main/r/request-tracker4/rt4-clients_4.0.5-1_all.deb
    wget http://ftp.us.debian.org/debian/pool/main/r/request-tracker4/rt4-fcgi_4.0.5-1_all.deb
    wget http://ftp.us.debian.org/debian/pool/main/r/request-tracker4/rt4-db-mysql_4.0.5-1_all.deb
    wget http://ftp.us.debian.org/debian/pool/main/r/request-tracker4/request-tracker4_4.0.5-1_all.deb
    sudo dpkg -i *.deb

This will spit out a bunch of errors. We need to install the dependencies now::

    sudo apt-get install -f --no-install-recommends

*Note: The --no-install-recommends option prevents apt-get from installing apache.*

Eventually a configuration screen for RT will come up and you can enter configuration values. Don't worry, you can change these later.

If you don't have mysql-server installed on the RT server (because you want the :doc:`database <../cluster/db>` to be on another machine) the install will fail, because it does not allow you to put in the :doc:`database <../cluster/db>` server option. 

This is okay! Select ignore and finish the install out.

Make sure the appropriate permissions exist for a user from the RT server, and run::

    sudo dpkg-reconfigure request-tracker4

Now you will be able to enter all the options needed and the installer will create the initial :doc:`database <../cluster/db>` for you.

*Note: If the install fails again, you must abort the reconfigure before you try again. Retrying will silently fail.*

Configure Software
==================

RT is tied heavily to email. We can get around setting up a dedicated email system using fetchmail and ssmtp. This setup does assume a few things:

    * You have an account setup in your email system for RT

    * This account has privileges to use your email server as a relay (this account can send messages to any email from smtp.) It is also possible to allow this for the RT server instead.

    * This account can access it's email from POP3 (or IMAP.)

First we set up ssmtp for outgoing mail. Simply edit `/etc/ssmtp/ssmtp.conf <files/ssmtp.conf>`_ with the options you need.

Next we set up incoming mail. First we enable the daemon in `/etc/default/fetchmail <files/fetchmail>`_. Next you add your account details in `/etc/fetchmailrc <files/fetchmailrc>`_.

You can add multiple accounts so different emails go to different queues. Just duplicate the last line and change the parameters.

Next we need to correct permissions. ::

    sudo touch /var/log/fetchmail.log
    sudo chown fetchmail /etc/fetchmailrc
    sudo chmod 600 /etc/fetchmailrc

Now we edit RT's configuration. Open `/etc/request-tracker4/RT_SiteConfig.d/50-debconf <files/RT_SiteConfig.d/50-debconf>`_. You will probably want it to look similar to our file.

Now you need to run::

    sudo update-rt-siteconfig-4
    sudo service rt4-fcgi restart

You will need to run these commands every time you update the RT config.

Next we want to tell nginx how to run RT, so edit `/etc/nginx/sites-available/default <files/default>`_ with your information.

Finally we need to start all our services::

    sudo service nginx restart
    sudo service fetchmail restart

You should now be able to log into your RT system with the root login you created.

If you have trouble, have a look at :file:`/var/log/nginx/error.log` or :file:`/var/log/request-tracker4/rt.log`.

Once logged in, you will probably want to give people permission to create tickets from email, so go to Tools->Configuration->Global->Group Rights

And add CreateTicket and ReplyToTicket rights for the Everyone group.

Now send an email to the email you set up and see if a ticket is created.

If nothing happens take a look at :file:`/var/log/fetchmail.log` to see what went wrong.

Once you can get a ticket in the system, reply to it from RT to test outgoing mail.

If you have issues here, check :file:`/var/log/syslog` and :file:`/var/log/request-tracker4/rt.log`.

If everything works correctly, congratulations - you have a working RT instance!

If you want to enable the RT Shredder you need to run::

    sudo mkdir /var/cache/request-tracker4/data/RT-Shredder
    sudo chown www-data /var/cache/request-tracker4/data/RT-Shredder

You can create Queues, Users, Groups, and tickets now. Keep going if you want more...

Active Directory Logins
=======================

To get AD logins working, we need to install an extra module::

    sudo apt-get install build-essential
    sudo cpan
    #take defaults
    cpan> install RT::Authen::ExternalAuth

If it asks you for a path to RT.pm use :file:`/usr/share/request-tracker4/lib`.

For some reason, it will not necessarily ask you, but instead put it in the wrong place. In our case it installed the plugin to :file:`/usr/local/plugins/`

To fix that run::

    sudo cp -R /usr/local/plugins/ /usr/share/request-tracker4/

Next we will need to create the ldap configuration. Copy over `/etc/request-tracker4/RT_SiteConfig.d/52-ldap-auth <files/RT_SiteConfig.d/52-ldap-auth>`_ and edit it for your settings. Once satisfied reload RT::

    sudo update-rt-siteconfig-4
    sudo service rt4-fcgi restart

At this point you should be able to log into RT with an AD user (as long as that user is in the allowed group if you specified one.)

Check the RT log if things don't go how you plan.

Particularly, if you are getting messages like::

    Couldn't create user <user>: Email address in use

You probably sent an email from that user's email already. Just go into Users and search for that email (make sure to check Include disabled users in search.)

You can change the email, or change the username to the right one and then you should be able to log in.

You can add AD users to the system (so you can assign permissions without them having to log in first) by creating their username in the system without a password. You can then assign permissions, and they can log in later with those permissions applied.

You will probably want to give :ref:`rationale` another read on create Groups and Queues.

SMS Notifications
=================

Email notifications are great, but what if you could have RT text a user when they are assigned a ticket. And what if that text contained a link to the mobile interface where they could check out the ticket where ever they are?

We can do this with RT Scrips, `twilio <http://twilio.com/>`_, and a bit of python.

First we need to make sure we have everything we need. You need to make sure :file:`api.twilio.com` is not blocked in your firewall or internet filter. Next run::

    sudo apt-get install python-pip
    sudo easy_install twilio
    sudo easy_install TinyUrl

Next copy `notify.py <files/notify.py>`_ to :file:`/opt/notify.py` and edit with your twilio information. We need to fix permissions::

    sudo chmod 600 /opt/notify.py
    sudo chown www-data:www-data /opt/notify.py

Next we create the Scrip. Go to Tools->configuration->Global->Scrips->Create and set the following options::

    Description:    On Owner Change Notify Owner by SMS
    Condition:  On Owner Change
    Action: User Defined
    Template:   Global Template: Blank
    Stage:  Transaction Create

Finally, fill in Custom action preparation code with the following code::

    #Taken in part from http://kermit.yaxs.net/post/2061563927/request-tracker-quick-n-dirty-sending-sms-on-change

    # don't send if user makes self owner
    if ($self->TicketObj->Owner == $self->TransactionObj->Creator) {
      $RT::Logger->info ( 'Not sending notification SMS - Creator made change');
      return 1;
    }

    # load the ticket, owner and user object 
    my $Ticket = $self->TicketObj;
    my $OwnerID = $self->TicketObj->Owner;
    my $user = RT::User->new($RT::SystemUser);

    # set the requestor email and ticket subject - will be used in the SMS
    my $Requestor = $Ticket->RequestorAddresses;
    my $Subject = $Ticket->Subject;

    # load owners details and grab the mobile number from RT
    $user->Load($OwnerID);
    my $OwnerMobileNumber = $user->MobilePhone;

    # check if we have a mobile number for the new owner, leave a log message and quit if we dont
    if ( !$OwnerMobileNumber ) {
      $RT::Logger->info ( 'Not sending notification SMS - no mobile number found for owner');
      return 1;
    }

    # some logging so we can check it's working
    $RT::Logger->info ( 'Sending SMS to '.$OwnerMobileNumber.', ticket subject is '.$Ticket->Subject.' requested by '.$Ticket->RequestorAddresses );

    # ticket id
    my $url = $RT::WebURL . "m/ticket/show?id=" . $Ticket->Id;

    # and backticks to exec the sms script 
    `python /opt/notify.py \"$OwnerMobileNumber\" \"Ticket assigned:\n $Requestor: $Subject\" \"$url\"`;

    # add system comment
    $self->TicketObj->Comment(
    Content=>"Outgoing SMS Sent:\nTicket assigned:\n $Requestor: $Subject"
    );
    return 1;

Go ahead and save the Scrip.

Now add a Mobile number for a user and try changing the owner of a ticket to that user. If nothing happens, check the RT log for troubleshooting.

If you have any issues with any of the setup, contact us below and we will help in any way we can!

References
==========

https://help.ubuntu.com/community/Request%20Tracker

http://requesttracker.wikia.com/wiki/ExternalAuth

`Browse Configuration Files <files/>`_
