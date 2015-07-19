---
layout: post
title: Gluing Airplay to Sonos - or "How to use Apple Music on Sonos" via a Raspi
date:  2015-07-18 12:00:00
categories: misc
tags: hacks sonos airplay node raspi
comments: true
twitter: true
author: Chris
---
# All the ways you love music.  All in one place. (Except Sonos) 

I'm not sure what to think of Apple Music, but I'm a huge fan of [Beats 1](https://twitter.com/beats1?lang=en)'s music selection.

The problem is, I've got a decent sized [Sonos](http://www.sonos.com) system at home, and Sonos does not currently support Apple Music. Quite unfortunate, but supposedly this support [is on the way](https://ask.sonos.com/sonos/topics/so-any-discussions-with-apple-about-apple-music). 

Enter [airsonos](https://medium.com/@stephencwan/hacking-airplay-into-sonos-93a41a1fcfbb). Someone wrote node.js glue that wraps AirPlay's mDNS bits into an Icecast server to generate MP3s and automatically tell your Sonos to begin playing audio once a client connects.

## But you hate node.js!

I do, but I'm willing to tolerate it for small things. After trying to get it installed on my FreeBSD server (which looked something like):
{% highlight bash linenos %}
CXXFLAGS='-I/usr/local/include -I/usr/local/include/lame'  npm install -g --unsafe-perm airsonos
{% endhighlight %}
... I ended up with weird libmp3lame symbol issues. Furthermore, getting the correct version of dns-sd installed was a pain.

## When all else fails, use a raspi 
I had a raspberry pi model 2 B laying around gathering dust, so I figured I'd start with a minimal Raspian install and go from there.

### OS Installation
Grab [raspbian-ua-netinst](https://github.com/debian-pi/raspbian-ua-netinst) and dd the resultant image to your microSD card. Plug in your Raspi to ethernet and power (and HDMI if you want to watch the non-interactive install), wait 15 minutes, and minimal raspian is installed.

Once up on the network, ssh in as root (password `raspbian`) and you've got a shell. The distro is smart enough to send its DHCP hostname, so I was able to just `ssh root@pi` and get a shell. This, of course, assumes you've got DHCP and dynamic DNS set up on your network.

Once in, do the standard raspian stuff:
{% highlight bash %}
passwd # Change the root password, eh?
dpkg-reconfigure tzdata # Optional, if you don't want UTC
useradd -m profit # Create a local user
date # Hey, NTP actually worked out of the box
apt-get install raspi-copies-and-fills rng-tools  # Recommended for perf
echo "bcm2708-rng" >>  /etc/modules 
modprobe bcm2708-rng
/etc/init.d/rng-tools start # We now have better RNG
{% endhighlight %}

### Installing node.js and getting airsonos running

`airsonos` is a node.js app that needs a few node libraries that have to be compiled via node-gyp. This mandates that we have a few development libraries and tools installed:
{% highlight bash %}
wget http://node-arm.herokuapp.com/node_latest_armhf.deb # Yank the latest node
sudo dpkg -i node_latest_armhf.deb # Node / NPM are installed
apt-get install libmp3lame-dev libavahi-compat-libdnssd-dev # Development libraries
apt-get install git build-essential python # Needed to actually node/npm install/node-gyp
npm install -g airsonos
{% endhighlight %}

That's basically it. Running it, you get something like...
{% highlight text %}
$ airsonos
*** WARNING *** The program 'node' uses the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/avahi-compat?s=libdns_sd&e=node>
*** WARNING *** The program 'node' called 'DNSServiceRegister()' which is not supported (or only supported partially) in the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/avahi-compat?s=libdns_sd&e=node&f=DNSServiceRegister>
Searching for Sonos devices on network...
Setting up AirSonos for Living Room {10.40.0.227:1400}
Setting up AirSonos for Master Bedroom {10.40.0.237:1400}
Setting up AirSonos for Master Bedroom {10.40.0.237:1400}
Setting up AirSonos for Living Room {10.40.0.227:1400}
{% endhighlight %}

And on the iPhone side, we see: ![AirPlay with beats1 to my sonos]({{ site.url }}/img/beatsone.png)

I'm not sure why my speakers show up twice, but picking the first listed seems to work fine.

## Closing thoughts

Going into this, I was mildly afraid of raspi performance, but a minimal raspian install on the raspi 2 model b seems to be fine performance-wise. I haven't had any dropouts, but YMMV. After all, this is transcoding to MP3 and shipping it to the Sonos player so it could be mildly cpu intensive.
