---
layout: post
title: "5 Things I Learned About Big Systems"
share-img: /img/content/test-containers-boot-real-database_share.jpg
image: /img/content/test-containers-boot-real-database_share.jpg
bigimg: /img/content/test-containers-boot-real-database_title.jpg
permalink: /5-things-learned-about-big-systems
tags: [developers]
excerpt: "In my past few projects I had the chance to participate in building big systems. My experience with those is ..."
---

In my past few projects I had the chance to be part of teams that built and operated big software systems.
One of them was building the backend of a popular mobile app the other was a central service providing user data for a big german automotive company.

I learned a lot - still I try to boil everything down into 5 important points.

1. With big impact comes big responsibilities

Let's move fast and break things ... or move as fast as possible without breaking stuff.
What I learned the hard way was that with a big user-base, even small hiccups can be a big thing.

An App Update breaks 0,1% of your installs? If you build an app in your spare-time you probably don't care too much since it is at best affecting a few dozen users. How about having more than a few million monthly active users?
This could boost your 0,1% to around half a million angry users that rush to the App Store in order to write an angry 1 star rating :)

You get the picture - with stuff at scale even small inconveniences become big issues.
Don't get me started on issues temporarily affecting all users.

2. You can't know it all - at least not in all it's details

While building big systems you quickly reach a point where you can't know it all. And if you try to do so, you probably stop actively developing new features and start managing teams/other developers in the progress.

I always try to keep the big picture in my head but don't stress the exact details too much.
If you need detailed knowledge there is a high probability you will just pair with an expert on the feature - or alternatively you can always start digging down the source code in case needed.

In my experience knowing which services your system is interacting with is sufficient to figure out most of the things on your own.
Just try to have answers to questions like:
* Which systems are interacting with your service?
    * Either consuming directly via APIs, or asynchronous using Events
    * Getting called by your service
* What are the big use-cases your system is involved in? Which role does your service play?
    * Is the use-case mission-critical?
    * Will the use-cases safely degrade when your system is having issues?

Things like that will give you enough room

3. You are creating legacy code every day

4. Scaling is easy - until it isn't

5. Code is not your main problem
