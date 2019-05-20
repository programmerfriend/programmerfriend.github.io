---
layout: post
title: What Two Years With Microservices Taught Me
image: /img/content/two-years-microservices_title.jpg
bigimg: /img/content/two-years-microservices_title.jpg
permalink: /what-two-years-with-microservices-taught-me/
redirect_from: 
    - /2019/02/05/what-two-years-with-microservices-taught-me/
tags: [microservices, developers]
---

When I joined my current employer we were operating a full blown Monolith with around 20k lines of code. The Monolith was serving an Android and iOS Application which both were also developed within the team. We migrated from that Monolith to Microservice architecture. This article is about our Journey.

Also: This is my first programming gig after graduating from university (despite having a formal 3 year education to programming before), so maybe it is better if you keep this in mind while reading this article.

# The Project
Speaking about the Team: In case my mind is not playing tricks on me, we were around 25 Developers split into 4 Scrum Teams with Product Owners, Scrum Masters and Designers added to the mix. I don’t want to take a trip down the memory lane but kind of impressive what changed and what stayed the same.

During the peak time of the project, the core team of the project was consisting of 50 people being spread across 4 teams (~30 developers), with additional teams for UX design and integration with other contributors.

The App had been rolled out across the globe. I estimate we are live in around 40 countries. During that time teams in other regions were also working on the project. They develop market specific features and operate the Apps within other regions of the world. Within the core team, we had shared code ownership – nobody was owning a particular piece of code or service. Most of the times there was an implicit feeling of ownership. This was nothing written down – It was more about that the easiest way to find something out is probably talking to the person who implemented it.

Hope you did’t mind me giving you a bit of context about the project. But I think it is finally time to come back to the topic leading you here: **Microservices**.

When I joined, the team already started to move some functionality from the Monolith into other services. If I remember correctly we had around 3 services back then (including the Monolith).

Fast forward to today: Just recently we buried the Monolith. We scaled it down to one single instance. It is now a shadow of its former self, not seeing any remarkable traffic.

If you would have a look at our production environment you would see a bit more than 30 different services. These services have somewhere around 2 and 16 instances. That’s quite a bit.

# The Journey
When I joined, the team just finished a phase with a BIG deadline. A lot of features which made it into the Apps probably shouldn’t have made it. This is not about technical or functional aspects. It is just about usability. In retrospective a lot of these features were half-baked and not really used by the majority of users. Overall they dragged us down.

## So what happened over these weeks, months and finally years?
In the beginning we already felt the common pain points people describe while working with a lot of people on a single application. It was kind of a mess.

Boundaries where not respected and vanished. Overall performance was degrading from release to release since some times features were added on top of features.

To be fair: I guess this was not solely a problem of the architecture and I think everybody needs to evaluate for themselves what kind of architecture makes sense in a project. 

I don’t want this article to be a discussion about the pros and cons of a Microservice Architecture. See this as some kind of story being told.

From my perspective we started to create more and more services which were cutting out application logic from our Monolith. What we really liked that this allowed us to scale specific parts of our application independently. Also failure isolated much better, so the Application was available even when parts of it had issues.

Previously we had workflows with different database access patterns working on the same database. We had write and read heavy workflows on the same tables.
This was causing us real headaches. After a while we moved these workloads to independent services and could therefore extract these workflows from the critical path.

## Scaling the project to other parts of the globe – Gathering experience:
Like previously mentioned we rolled the app out into different parts of the globe. During that period we had to onboard other teams in the US and India. A lot of these people visited us, a few of us were visiting them. It was nice to get to know each other and not only interact using video and text messaging tools.

This part was actually harder than we expected. It was not as easy to teach how things worked within the architecture. This was due to, I would say, the lack of experience with the technology and also because of the different time zones. Overall this was twice the burden we were used to have. We had to commit to our new features, while teaching other people how to operate and continue to develop the app. There have been workshops, we wrote down Best Practices we already had in our minds. We wrote Integration Guidelines, on the best way to integrate into our existing ecosystem. We helped setting up the Backend Environments for them.

Overall this really hit our velocity. We were not as fast as we used to – the quality suffered.

After a while, it got better again. The other contributors learned pretty quick and were able to deliver their own features.

Looking at the global distribution: We had 3 independent backend installations across the globe. The customers are locked into their availability zone. A frontend for a specific market is only interacting with its dedicated backend.

## Getting back on track: Focus
Finally when we were again able to focus on a single region (since the other regions were being maintained and developed by other contributors).
We started again to go faster. During this time we had other issues. We struggled a bit since we started to glue the services too much together.

*Example given:* Once I was deploying a service to Production and missing another service on which it was relying on. To be more specific, the latest version was not deployed on Production yet.

**Ah snap!** After figuring out that I would need to update that service. I realized that in order to do this, I had to update and deploy three other services. I was basically drawing a dependency graph between the services and their depending versions. After deploying all of it, I had luck that I didn’t wreck the whole production stage by deploying a lot of changes with which I was not too familiar with.

## Feeling the Pain
For me this felt even worse than having a single Monolith in place. I guess if you read different blogs and articles this is the so called “Distributed Monolith (Anti)Pattern”.

We tried multiple approaches to that problem: One approach was to not merge a code change as long as the other change is not yet rolled out on production. Another was to reference the service version and compare it with the one deployed on production. When the production version was lower, the new service would fail on boot. At least now we know before going live that there will be issues down the road.

> “Hey this guy is talking about approaches … but these are not real solutions to the issue.”

Yes I hear you, and you are right. These are not real solutions since in either way you will be sitting there and having to update multiple services at once.

What we are currently working on is to create another mindset to deal with the situation.
Coming from a 3 month release circle, we realized that deployments hurt. Like described before there were many issues when we had to deploy multiple services at once.

We now wanted to see each deployment more atomic. It must be independent from other deployments. So what is our current approach?

# Our Solution
We deploy much more often. Nowadays we stage our changes within hours or days.
This helps a lot. Let me tell you what I think the reason behind this is:

We changed to a mindset where every commit now really needs to be shippable. No compromises! No “I will deploy it tomorrow when the other thing has been merged”.

Early, we often had version conflicts where we couldn’t ship a version because it was already containing features for the next release. Still there was an urge to deploy some urgent fix for Production. This ended in a lot of hotfixes and custom versions.

Nowadays, most of the time we are on Production only 2 to 3 commits behind master.

If your change is not yet shippable – build it in a way it can be temporarily switched off or your code can not yet be merged. Easy as that. Also it may not interfere with the current function of other services.

# Take-Away
Our development was not a sprint. It was a journey.
We had to explore quite a bit until we found our way.

Looking back, the key decisions we made: On the one hand to only build features that make sense. Yes, I think we are slowly getting better at it. On the other hand we ship now more often. Shipping more often helps us by introducing less changes at once.

This makes life a lot of easier. Since when you change something and it breaks you are really aware of the change which introduced the failure.
Did our uptime suffer from this approach? I think if we would measure it critically, probably. But I guess not too much. Most of the times when we had failures, it was only visible for less than one minute. Blue/Green deployments for the win!

Introducing more frequent deployments was really hard. We are involved in a “4 times a year release cycle” with other components and our external quality assurance team had some hesitations about us wanting to break free from that process.

Today we release our Backend continuously and our Frontends get an update each 14 days in the App Stores. It took us a while, but after while it feels like we arrived somewhere.

___

Hope you enjoyed the read and could learn a bit from it. For me it was a nice way to reflect about the last two years. In case you made some similar transformations or have anything for feeding a discussion: Just reach out via [twitter](https://twitter.com/eiselems) or any other platform. Also feel free to just leave a comment at the bottom. Would love you to share your experiences.
