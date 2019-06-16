---
layout: post
title: "Monolith vs Microservices"
bigimg: /img/content/monolith-vs-microservces_title.jpg
tags: [microservices, developers]
---

Over the years I read a lot of articles and stories about the differences between Microservices Architectures and Monolithic Architecture (Monoliths). Today I am about to tell you my own version.

## What is a Monolith i.e. a monolithic architecture?
*A monolithic application*, let's call it a *Monolith*, is an application delivered via a single deployment unit. Examples could be an application delivered as single WAR or a Node application with a single entrypoint.

### Example:

Let's make an example: A classic online shop.
Our business boundaries are *ORDERS, ITEMS, CUSTOMERS, SHIPPING* and *PAYMENT*.
Provided ways of interacting with the service are: A REST api and a web-frontend.

Building a Monolith, all these things would be managed within the same artifact.
I didn't write *"same process"*, since this wouldn't be true for scenarios where multiple instances of our artifact would be running to deal with higher loads.

See an example in the following figure, where all parts are within the same deployment unit:
<figure>
  <img src="{{site.url}}/img/content/monolith-vs-microservice_mono.png" alt="An example monolithic architecture"/>
</figure>


### Benefits:

A big benefit of a Monolith is that it is **easier to implement**.
In a Monolith you can quickly start to implement your business logic before spending your thoughts about interprocess communication.

Another thing are *End-to-End (E2E) Tests*. In a monolithic architecture these tests are easier to execute since the monolith brings everything.

Regarding operations: The Monolith is **easy to deploy** and **easy to scale out**. For **deploying** you could get away with a script uploading your artifact and just starting the application. **Scaling out** is achieved by putting a Loadbalancer in front of multiple instances of your application. 
As you can see a Monolith is pretty easy to operate.

After reading all these cool things about microservices, let's have a look at the not so sunny side ...

### Drawbacks:
Monoliths tend to degenerate from their clean state to a so called **"big ball of mud"**.
Shortly written this is a state were architectural rules were violated and over time the components grew together.

This degeneration slows down the development process - **every future feature will be harder to develop**. Due to the components grewing together, they also need to get changed together. Creating a new feature could mean to touch 5 different places, 5 places you have to write tests, 5 places which could have unwanted side-effects on existing features.

Earlier I said that scaling is easy within a Monolith. It really is - until it isn't. Scaling out can be problematic when only a single part of the system needs the additional resources. Within a monolithic architecture **you can't scale single parts of your system**.

There is **barely any isolation**. An issue or bug in a module can slow or bring down the whole application.

Building a Monolith often comes with choosing a framework. **Switching away or updating away from your initial choice can be hard** since it needs to be done at once and for all parts of your system.

## What is a microservice i.e. a microservice architecture?

In a Microservice architecture loosely coupled services interact with each other to fulfill the tasks belonging to their business capabilities.

Microservices pretty much got their name from the fact that the services are smaller than in a monolithical environment. Still the micro is more about cutting business capabilities and not just about the size.

In comparison to a Monolith, with Microservices you have multiple deployment units.
Each service gets deployed on its own. 

### Example:

Let's have a look at our previous example: The Online Shop.

Like before, we got the boundaries: 
*ORDERS, ITEMS, CUSTOMERS, SHIPPING* and *PAYMENT*.

The difference now is that these all have their own service and database.
They are loosely coupled and might interact with different protocols (e.g. REST, gRPC, messaging) across their boundaries.

The following figure shows the same example as before but decomposited as microservices. I left out the communication between each service since this could definitly clutter the chart, but I hope that you still get the idea:
<figure>
  <img src="{{site.url}}/img/content/monolith-vs-microservice_micro.png" alt="An example microservice architecture"/>
</figure>

But what are the benefits and cons of this variant?

### Benefits:
It is **easier to keep them modularized**. It is technically enforced by the hard boundaries between the single services.

In big companies different services can be owned by different teams. There services can be re-used across the whole company. It also allows teams to work on their services mainly independently. No need to coordinate deployments between teams. **Developing scales better with increasing number of teams**.

Microservices are smaller and have smaller scopes. Due to this they are in general **easier to understand and to test**.

Smaller sizes also helps when it comes to compilation times, startup times and time it takes to execute the tests. All of these factors benefit **developer productivity** since it means less time spent waiting in each phase of the development.

The shorter startup times and the possibility to deploy Microservices independently from each other really pay into **CI/CD**. It is much smoother in comparison to regularly deploy a monolith.

Each Microservices is **not bound to the technology used in other services**. Everywhere we can use the best fitting technology. Older services can be quickly rewritten to use newer technologies.

Better **fault isolation** in comparison to the monolithic approach. A well designed distributed system will survive the crash of a single service.

### Drawbacks:
Everything sounds too good to be true, but there are also some drawbacks to consider:


**Having a distributed system brings its own complexity**:<br>
In a distributed system you have to deal with **Partial failure**, a more difficult **Testing Interaction (E2E Tests)** and also often a **higher difficulty in implementing interaction between services**.

Another thing to consider is that **transactions are easier to handle in a monolith**. A solution to this issue is the Saga Pattern which is a good solution but still more cumbersome to implement in practice.

**Let's have a look at the operational side of things:**<br>
There is an operational overhead, a bunch of microservices are **more difficult to operate** than a few instances of a signle monolith.

Besides the difficulty, microservices can also **require more hardware** than traditional monoliths. Sometimes microservices can outperform a single monolith if there are parts of it which require scaling it out to the extreme.

**Changes affecting multiple services need to get coordinated between multiple teams**, this can be especially hard if the teams not yet had any contact before.

## Summary
*There are no silver bullets! Everything is trade-off.*

First of all it depends on your organizational structure. You have 6 teams which will be working on a single product? Microservices might be a good fit.

You have a team of 3 developers? Probably they will be fine building and maintaining a monolith (see: [Wikipedia: Conway's Law](https://en.wikipedia.org/wiki/Conway%27s_law))

The other factors are rate of change and complexity. A high rate of change and a high complexity would both be factors which move my decision more to the Microservice architecture.

In contrast, when you are not really familiar with the domain, starting out with a Monolith can be really beneficial. Just do yourself a favor and try your best on keeping it modularized. This will easen the way in case you ever decide to cut your Monolith into multiple services down the road.