---
layout: post
title: "Pillars of a Successful Software Project"
image: /img/content/successful-softwareproject_share.png
bigimg: /img/content/successful-softwareproject_title.jpg
permalink: /pillars-successful-software-project
tags: [developers, soft-skills]
excerpt: "Each software project is different. Despite this variance, there are still things that you as a Developer can contribute in the early days of a project. Your contribution might setup the project for success or at least make your work on it more fun."
---

Lately, I had time to think a bit about work.
Due to the crisis, I will be switching to a new project again. I had a few weeks off work and was trying to wrap my head around past projects and things I liked or disliked about them. In this article, I try to showcase factors that, in my opinion, contribute to the success of a Software Project.

## A Vision

To be successful, you need to know **WHAT** you want to achieve. Your product has to be the solution to a problem - Not a solution for which you diligently search a fitting problem.

A lack of vision is a big long-term demotivator for all project members. This lack of purpose is also causing issues when thinking about what to do next. Hard to find the right way, when you don't know the destination.

Things change, you can adjust the vision if needed, but please start with an initial version.

## Functional Team
What do I mean by *"functional"*?

The team has to be aligned. They need to look in the same direction. This is where a clear vision really shines.
Enough with all this motivational speech, most importantly, they need to work and deliver together. I think this section could be material for a whole book and I might not be the expert you are looking for.

As a developer within the team, I think you can contribute a lot by having a positive attitude. Spend some time with each team member and get to know each other better. If you want to influence the team in a good way, try to be the change you want to see. You want to have good automated tests in your project? Write good tests. You don't want people to break the build? Don't break it yourself. 

Humans learn by observation and reinforcement. Show them the behavior you want to see and praise once they start showing it themselves. Most of the times, praise is not even needed if the behavior has its own benefits.
For example, other programmers could implement something really fast because of test cases - they might start writing some themselves next time.

## Processes and Tools

For a successful project, you and your team need established processes and tools.
Common tasks which can cause problems for teams are:

### Product Management / Product Development
* How are new features or requirements planned?
* How are these new things implemented then?
* How often can new versions get deployed?
* How is the team dealing with bugs on production?
* ... many more

### Communication
* Asynchronous: Communication that not needs your immediate attention. Think about just using e-mails here or agree that with Chat Tools it is ok to take some time to answer.
* Synchronous: People sometimes need to directly interact with each other. Be it for having a planned meeting or ad-hoc collaboration (e.g. Pairing for solving a production issue). Here you can differentiate between audio-only solutions, like the simplest solution a phone call, and video solutions. A special requirement here could be that the remote counterpart can take over control, a mandatory thing for real remote pair programming.

Here, I don't want to provide an answer to all these questions or solve all the decisions about tooling. The important thing here is that these questions get addressed and permanently answered by you and your team - some sooner than later.

## Developer Experience

You might be asking what I mean by Developer Experience.
I would summarize Developer Experience as all things that developers could hate or love when they develop within the codebase.
A lot of these things are really basic. Missing or having them can make all the difference in the world.

### Version Control with Collaboration Features
To work effective as a developer, I need some kind of VCS (Version Control System) with some additional collaboration features.
Personally, I don't care as long the underlying VCS is *git*. For me, it doesn't matter which "wrapper" is around it (e.g. Github, Bitbucket, or Gitlab). All of them should have features like Pull Requests, Code Reviews, and Branch Protection.

### Automated CI/CD Pipeline
Another thing which I find quite essential is a proper CI/CD pipeline.
Again, I am not rooting for any of the vendors. Pick one you like and start to automate the shit out of your project.
Testing, Building, and Deploying should really be done regularly and fully automated.

Automating anything allows you to do such tasks more often. By doing them more often they become more robust.
Issues affecting automated tasks are getting discovered much faster.

### Quality Analysis Tools
Establish automated quality measurements and put them in the faces of your developers.
There is no point of running analyses regularly and hiding them. When a change is merged into your shared branch the deed is already done.

Fixing something before it is getting merged is much better. So, why we don't provide the developer with bugs he might have caused or how bad his new implementation is tested before he merges his changes.

## Recap

TLDR:

* Know what you should be doing
* Have a team that delivers
* Establish processes everybody loves
* Have a shared communication model with defined tools
* Establish a codebase that is fun and effective to work with

I hope you liked the article and could learn something from it.
What are necessary factors from your experience?