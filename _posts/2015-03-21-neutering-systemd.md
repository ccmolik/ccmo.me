---
layout: post
title: Neutering systemd services, or how to prevent accidental hilarity
date:  2015-03-21 12:00:00
categories: systemd
comments: true
twitter: true
---
## Why?
When spinning up a `named` server on CentOS 7, a coworker and I realized that forcing the stock `bind` package on EL7 to run in a chroot isn't obvious.
It turns out there's a seperate package called `bind-chroot` that enables `bind` to run in a chroot jail.

Specifically, let's take a look at the [systemd unit file](http://www.freedesktop.org/software/systemd/man/systemd.unit.html) for `bind`:
{% highlight ini %}
$ cat /usr/lib/systemd/system/named.service
[Unit]
Description=Berkeley Internet Name Domain (DNS)
Wants=nss-lookup.target
Wants=named-setup-rndc.service
Before=nss-lookup.target
After=network.target
After=named-setup-rndc.service

[Service]
Type=forking
EnvironmentFile=-/etc/sysconfig/named
Environment=KRB5_KTNAME=/etc/named.keytab
PIDFile=/run/named/named.pid

ExecStartPre=/usr/sbin/named-checkconf -z /etc/named.conf
ExecStart=/usr/sbin/named -u named $OPTIONS

ExecReload=/bin/sh -c '/usr/sbin/rndc reload > /dev/null 2>&1 || /bin/kill -HUP $MAINPID'

ExecStop=/bin/sh -c '/usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID'

PrivateTmp=true

[Install]
WantedBy=multi-user.target
{% endhighlight %}
Note that the `ExecStart` line doesn't specify the `-t` flag that tells `named` to run in a chroot jail.

After installing `bind-chroot`, we end up with a systemd unit file that contains the correct flag...
{% highlight ini %}
$ cat /usr/lib/systemd/system/named-chroot.service
# Don't forget to add "$AddUnixListenSocket /var/named/chroot/dev/log"
# line to your /etc/rsyslog.conf file. Otherwise your logging becomes
# broken when rsyslogd daemon is restarted (due update, for example).

[Unit]
Description=Berkeley Internet Name Domain (DNS)
Wants=nss-lookup.target
Requires=named-chroot-setup.service
Before=nss-lookup.target
After=network.target
After=named-chroot-setup.service

[Service]
Type=forking
EnvironmentFile=-/etc/sysconfig/named
Environment=KRB5_KTNAME=/etc/named.keytab
PIDFile=/var/named/chroot/run/named/named.pid

ExecStartPre=/usr/sbin/named-checkconf -t /var/named/chroot -z /etc/named.conf
ExecStart=/usr/sbin/named -u named -t /var/named/chroot $OPTIONS

ExecReload=/bin/sh -c '/usr/sbin/rndc reload > /dev/null 2>&1 || /bin/kill -HUP $MAINPID'

ExecStop=/bin/sh -c '/usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID'

PrivateTmp=false

[Install]
WantedBy=multi-user.target
{% endhighlight %}
...but the original `named.service` file exists.

Though we can easily `chkconfig named off; chkconfig named-chroot on` or the systemd-equivalents, starting both `named` and `named-chroot` will totally "work." And as the `ExecStop` command is just an `rndc` call, stopping the service will kill both instances.

If this is a standalone system, maybe your memory's good enough to remember to run `named-chroot` not `named`.

In our case, it isn't, and mine isn't.  The `bind-chroot` package needs the `bind` package, so removing the latter isn't an option. Let's just disable the `named` service from starting... ever; but how?

## Prevent the service from running... ever
[ArchLinux's wiki page](https://wiki.archlinux.org/index.php/systemd#Drop-in_snippets) suggests that overriding a unit file by creating 'drop-in snippits' is an option. However, el7 does not contain the `systemctl edit` command.

Reading the above link, it says:

> To create drop-in snippets for the unit file /usr/lib/systemd/system/unit, create the directory /etc/systemd/system/unit.d/

OK, so we create `/etc/systemd/system/named.d/` right?

...Wrong.

The unit name is `named.service`, so you'll need to create `/etc/systemd/system/named.service.d/`.

###How do we prevent the service from running, then?
We simply override the ExecStart by.. setting it to nothing. `Systemd` will refuse to start a service that doesn't contain a valid `ExecStart`.

For example:
{% highlight ini %}
$ cat /etc/systemd/system/named.service.d/disable.conf
# Hello!
# You'll note that named fails to start here.
# You really want named-chroot.
[Service]
ExecStart=
{% endhighlight %}
After editing this file, you need to tell systemd to reload the list of services by running `# systemctl daemon-reload`.
So what happens when we try to start named?
{% highlight text %} 
# systemctl start named
Failed to issue method call: Unit named.service failed to load: Invalid argument. See system logs and 'systemctl status named.service' for details.
# systemctl status named.service -l
 named.service - Berkeley Internet Name Domain (DNS)
    Loaded: error (Reason: Invalid argument)
   Drop-In: /etc/systemd/system/named.service.d
           └─disable.conf
   Active: inactive (dead)

Mar 21 08:44:15 series.of.tubes systemd[1]: named.service lacks ExecStart setting. Refusing.
{% endhighlight %}
All is therefore well. No chance of running named accidentally.
