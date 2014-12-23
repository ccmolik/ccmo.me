---
layout: post
title: Puppet Essentials e-book review
date:  2014-12-23 08:00:00
categories: puppet
comments: true
twitter: true
---

> Pakt Publishing was kind enough to provide me an e-book copy of *Puppet Essentials* for review, so I am writing this in thanks for the copy.

#### TL;DR
[Pakt Publishing's *Puppet Essentials*](http://bit.ly/1zoGxbW) is a pretty solid introduction to Puppet that merits a look for both newbies and Puppet veterans.

## Background
My work environment consists of over 1,500 Linux/Unix systems that my team is responsible for maintaining. Configuration management is essential in this environment to maintain sanity - both in our systems and in our mental state. Furthermore, empowering groups within the company to maintain a degree of control over their systems and rapidly apply configuration changes is key in the DevOps world.

Though I use puppet often in this environment, I by no means consider myself an expert. I can write manifests and modules, though the modules themselves aren't pretty and more often than not I've found myself wanting to go back and re-factor my code, only to be bitten by subtle Puppet-isms that cause me consternation and confusion.

When I saw a post in the [Google+ Puppet Users Community](https://plus.google.com/u/0/communities/114602515199520546716) discussing the new *Puppet Essentials* publication by [Pakt Publishing](https://www.packtpub.com/) I was intrigued as this might be a useful opportunity to gain some more SA on Puppet and improve my productivity at work.

## Content
I'll admit that I've become somewhat jaded when it comes to technical books. By the time I purchase a book on a technical subject (dead tree or otherwise), I often find the material out of date.
Furthermore, oftentimes I can google and derive almost the same material that's listed in the books, for free.

Felix Frank's [*Puppet Essentials*](http://bit.ly/1zoGxbW) isn't one of those publications.

Frank's publication provides solid coverage of Puppet that both newbies and Puppet veterans can appreciate. It provides a hands-on, "hit the ground running" approach to writing Puppet code to manage your environment. It doesn't dwell too much on the theoretical BS that plagues some technical publications, and provides working examples that the reader can expand on to apply to his or her setup.

For those of you who've deployed it, you're well aware of the numerous pitfalls and traps that can surface when using Puppet. Frank makes a point to bring up some of the gotchas that will burn you when you're writing code. Furthermore, the book provides some red flags about deploying Puppet that can lead to performance issues, some of which I wasn't even aware of. The "under the hood" chapters (though a bit dry) are actually pretty useful to understand how the Puppet DSL works and how it can lead to issues in the real world. There are useful mnenomics scattered throughout the publication which make it easy to remember some of the ways Puppet works (`subscribe`, `require`, `notify`, and `before` have always been somewhat confusing to me in how they differ.)

I'm also grateful that this book doesn't discriminate between the Puppet Enterprise and Puppet Open-Source versions. Both implementations are equally usable with material from this book.

Frank also isn't afraid to call out some of the Puppet Labs style guides. As many sysadmins know, vendor-provided style guides and best practices often don't make it to the real world implementation. I've taken issue with some of the Puppet Labs style guides, and Frank acknowledges that deviation from the standards sometimes make sense (with caveats.) 

Overall, this publication seems to be written for the Ops person who needs to get a job done, which I admire. I'm a no-nonsense kind of guy, so I appreciate that this book provides useful examples while still covering the basics needed for those who are new to Puppet. Furthermore, the attention to detail with the caveats of using Puppet is quite useful.

## Style
The grammar can be a bit wonky sometimes, but such is life with technical publications. It's a standard Pakt book, so code examples are mixed in with text. Sometimes it reads like a math textbook, with "This is left as a reader exercise with no dedicated depiction" surfacing a few times.

Though it's a book on the ever-compelling subject of configuration management, there's actually a bit of dry humor in it which breaks the monotony nicely.

One such example:

> The dependency circle in this manifest is somewhat hidden (as will likely be the case for many such circles that you will encounter during regular use of Puppet).

I will note that the screenshots in the PDF version I was reading were occasionally a bit dodgy, but this can happen with electronic publishing, and it's a minor nitpick. Sometimes syntax styles are mixed which might cause confusion to people who are new to the Puppet DSL, but this seems to clear up after the first few chapters or so.  The first chapter might seem kind of confusing for those new to Puppet, but plowing through the book clarifies what's going on.

## What the book didn't cover

The biggest thing about Puppet (and configuration management in general) that needs to be stressed is this: *Keep your tree in source control.* This wasn't stressed enough in this publication, and actually talking about deploying the code wasn't covered (inasmuch as how a puppetmaster can be updated to track a Git repository, for example.) No matter if you use Git, SVN, or any other source control mechanism, you're going to want a way to roll back and track changes to your codebase. I've drunk the Git kool-aid, and I find that it's the most efficient way to work with devs to allow access and branching to the codebase.

I also wish that it spent a bit of time describing how Puppet Server is moving to [a clojure and jRuby-based infrastructure](https://github.com/puppetlabs/puppet-server).  That being said, it calls out the need to run an Apache/Passenger-based setup as opposed to trying to use the built-in WEBrick server in production. 

## Bottom line
[Felix Frank's *Puppet Essentials*](http://bit.ly/1zoGxbW) by Pakt Publishing is a useful publication for both Puppet veterans and newbies. The no-nonsense style and plethora of useful examples explaining how to use Puppet in the real world cement it in the list of literature I'd recommend to those using Puppet. Pakt is running a sale on all e-books for $5 until 6 Jan 2015. At this price, it's totally worth grabbing. Even at the regular price of $26.99 for an e-book copy and $44.99 for dead tree + ebook, I think it's worthwhile. 

Side note: if you've never used Pakt before, they provide e-books in formats that'll work with most e-readers and tablets (PDF, ePub, Mobi, and Kindle.) These all come without DRM, and you can download the files via your Pakt account whenever. 

I hope you found this review useful, as this is my first 'formal' book review. Feel free to leave comments in the Disqus panel below!
