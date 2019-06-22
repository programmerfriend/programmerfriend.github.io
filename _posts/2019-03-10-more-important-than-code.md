---
layout: post
title: The Things more important than Code
image: /img/content/more-important-than-code_title.jpg
bigimg: /img/content/more-important-than-code_title.jpg
permalink: /the-things-more-important-than-code/
redirect_from: 
    - /2019/03/10/the-things-more-important-than-code/
tags: [soft-skills, developers]
---
There are Programmers living in ivory towers built from their own egos ruling over their systems. Technical solutions for the sake of technical solutions are not the things you should be building. Your code has to solve a problem. It is not beneficial to build a solution and start to look for matching problems. There is this saying:

> “If all you have is a hammer, everything looks like a nail” 
> 
> – Maslow’s Hammer, Abraham Maslow

So make sure you work hard at solving a problem and not building a “solution without a problem”.

# The Software Developer
Your part in this, as a software developer, is to build these kind of solutions. Try to validate them with real customers as early as possible. Trashing a project after a month is much better than realizing, later down the road, that you don’t have a market fit.

There is a reason that developers seem to be to a certain degree obsessed with building clean solutions. For non technical people this is sometimes hard to grasp. I like to tell them a projection on a job everybody can image.

<figure>
  <img src="{{site.url}}/img/content/more-important-than-code_roll.jpg" alt="Painter roll with white color against white wall to represent problem solving in software engineering."/>
  <figcaption>Painter roll with white color against white wall
</figcaption>
</figure>

Ask if they think a painter would like to work in a place where everything is clean and protected from your paint or a place where there is no such protection and saw dust everywhere.

**Keeping this image on our minds:** We have the wall the painter wants to paint, the door which was just installed by another worker and some saw dust which was not yet cleaned up. Wouldn’t it be frustrating to paint the wall and then ruin the freshly installed door? Or getting your work damaged by someone forgetting he needs to keep the window shut to not have the saw dust on the freshly painted wall?

Last time when I told this I got a quick reply that this comparison is not working. 
A painter would just setup the protection itself. Then he can always work in a clean environment.

After he said it, I smiled, nodded and said “See, that is the point”. He smiled and understood.

*Short notice:* I am really into Clean Code. I value code which is easy to understand, easy to test and easy to read above quite a few other things. Since this is what is protecting you and allows you to make changes much quicker.

Coming back from the short notice: I think you shouldn’t over do it.

> Is it working? Does it need to get extended in the (near) future? Are you sure it is really necessary to build it that way?
>
> Questions you should be asking yourself before starting a refactoring

# YAGNI! (You Aren’t Gonna Need It)
Over the past few years, I have seen a lot of things being overthought and over engineered.
Stuff was too complicated, it was not clear what it was supposed to do and there was barely test coverage.
**Plot Twist:** I am not totally innocent myself. But I am on road to recovery 🙂

There were systems where we added a layer to really make it easy to add additional features in the future – but guess what? These features newer came. Instead I spent almost a week until this abstraction layer was working and another two days to fix the only feature added after introducing the abstraction half a year later.

I feel like quoting Donald Knuth with his famous words:

> “Premature Optimization is the root of all evil”.
> 
> Donald Knuth

Having a look at my experience with it, I am agreeing. Personally I would add a comment about using appropriate data structures while following the advice, since this most of the times ensures that your performance is overall in the right ballpark.

# But what should we do instead?
Being a developer honoring his craft, you tend to have cravings to get rid of things which are not the way they are supposed to be.
Bloaters, Duplicated code, Duplicated Code, Change Preventers, Couplers … the list could go on for a while.

## Take a step back
In reality these things are not hurting you right now! They are not urgent in a way that you are having problems running your software (in comparison to e.g. performance problems on production).

*Disclaimer: I am not advicing to introduce and accumulate as much technical debt as possible.*

I am just saying, think before you spent half a week on refactoring something without functional change.

Definitely you should go for the low hanging fruits: Try to not create technical debt to begin with. I am a big fan of the [Boy Scout Rule](https://www.oreilly.com/library/view/97-things-every/9780596809515/ch08.html), which tells to leave the code (the campground) cleaner than you found it.

A thing you shouldn’t compromise on: Writing meaningful and useful test cases – they really help your future self and other contributors to not fall into a lot traps.

Test cases could and should be seen as a way to specify your implementation. Tests are not solely verifying that your freshly written code is behaving according to your specification. Tests are also verifying that the next person touching the code (Attention: This person could be your future self) is not breaking the implementation. Think of test cases as your safety net. They prevent you from falling on your face in the future.

On top of verifying that every thing is working as it should, Test Cases also can give *intent*.
Giving *intent* in test cases is most often done via having proper name for the test methods, but in case that is not possible you can always fall back to use comments.

But your work as a software developer is not only about creating code. Like I already pointed out a bit in my article [“What nobody tells you when you get your first job as a developer”]({% post_url 2019-02-09-nobody-tells-about-first-job %}) there are also other important activities. One of your duties is also to figure out requirements and refine how and which features could and will be added to your Application.

# Communicate and Work together on your Product!

> “Ok, seriously. You advice to just build feature after feature. Your codebase will be a mess! This will not work!”
> 
> Some reader of this post

Been there, done that. One of the challenges is to more often say **“NO!”**.

In every project there is this so called *Project Management Triangle* of *“Scope, Time and Cost”* which are constraining the quality. Simply put, quality can be adjusted by changing Scope, the time or the costs of the project.


<figure>
  <img src="https://upload.wikimedia.org/wikipedia/commons/8/88/Project-triangle-en.svg" alt="The project triangle from Wikipedia."/>
  <figcaption>The project triangle from Wikipedia - Showing Quality to be constrained by Scope, Cost and Time.
</figcaption>
</figure>


Most things I discuss with Product Owners or Feature Owners is not the feasibility of a feature, but its value to the customer.

> No matter if we can build it: It should always have a positive customer value!
>  
> Myself

After we are sure that it is a good idea to actually build something, we think about it if is technical possible. And here begins your part of building a feature: You have to communicate.

# Different stakeholders always want to get an estimate of you.
**Steve**: “Hey Dan, how long will this thing we talked about take?”

**Dan**: “Phew, you know what I think we did something like that in the past. Last time it took us 3-4 weeks if I remember correctly”

___

**Steve** next day: “No problem! Our team will ship it in three weeks”

**Dan** is a bit confused how his friend Steve can put him up with such a deadline even though he needs to work on other things right now. He still manages to finish the feature within four weeks and introduces a lot of technical debt by copying big parts of the other existing solution. The other things he worked on were also implemented really sluggish.

After all **the customer** is not so happy about the delay and that the feature is working well.

## So what did go wrong here?

Steve might be working in Sales or might be a Manager. It seems, him and Dan have different ideas of estimations. In my experience estimations are always wild guesses and can be really imprecise. Often when we provide estimations, we consider that we have time to work on the estimated task which is not always the case.

So how could have it went instead?

**Steve**: “Hey Dan, how long will this thing we talked about take?”

**Dan**: “Phew, you know what I think we did something like that in the past. Last time it took us three or four weeks, but to be honest, I think it could even not be finished after four weeks. It was rushed during the last release and we cut some corners back then”

**Steve**: “Dan, see: We promised it to our biggest customer and we already have the contract in place and everything. We need to have it at least four weeks, the customer is even pressuring for three”

Coming back to our triangle. Since Dan wants to keep the quality high, he could suggest the following:

**Dan**: “That is not so good. Currently we are already busy working on this other feature. You need to think about shifting priorities. On top of this: We definitely can not do it in four. It would have probably a lot of bugs and the customer wouldn’t be too happy about it. Does he really need that Slack and E-Mail Integration?”

**Steve**: “Mhm, would probably nice to have. But we didn’t pitch or sell it to him.”

**Dan**: “Oh thats nice actually, maybe we could leave this out for the first version and bring it later. This would I guess save us at least two weeks, including the setup”

**Steve**: “Alright, sounds like a plan!”

**Dan**: “Can you make sure that our postponing of our other feature gets announced? We need to start as soon as possible”

**Steve**: “Of course, I will bring it up in the Management Round tomorrow”

___

**Steve** the next day pitched to the customer that they will drop another feature to build their new one as soon as possible. He also convinced the customer that it will be released in four weeks since he had good arguments.

**The customer** also learned how things are affecting each other and was discussing priority together with Steve.
He liked how he was involved and his wishes got respected.

So what was different here? 

**Dan** used the word **“NO”** a single time. He learned that the scope was not fixed and could based on this give an alternative.
**Steve** is now on the same page and knows what the developers are doing. He is also aware that he can’t pull another PR Stunt and sell another thing for the next 3 months due to the team being occupied with this feature and probably the other feature after that.
For **the customer**, he is aware that his feature will have top priority because another feature will not make it because of his requirement. Not so nice if he planned to have both but you can not eat the cake and have it I guess. Still he liked how he was involved in the decision and is happy when the feature will work out as it was planned.

If you want to avoid these misunderstandings and the associated frustration, you need to create a shared vision of your development cycle. You need to talk. There is no way around it.

# Building things that matter
This is now not about meeting deadlines. Since we already figured that it is important to build things the right way, it is even more important to build the right things.

During the last year I saw a lot of engineering hours wasted on building things that were later not released in the final product. This had different reasons:

* Management didn’t like it.
* Other APIs were not having a good data quality and therefore the feature didn’t work well.
* Legal requirements made it impossible to ship.
* The solution was not perfect (somehow sad that they were often still an improvement over the existing solution which is now still inside the application).

## Validating your ideas early on
Try to build things incrementally and fail fast. Build some fake UI that is simulating it and show it to the stakeholders or possible customers.

If they don’t like it, you could refine your approach and continue to work on it or just drop it all together. Another thing is that pretty early you should really integrate your solution with the real data.
You should get a grasp on how it is performing and how the data quality is in order to not let your real users be the testers. All these things really save your time and allow you to build things that matter. Not that you are in a situation were you have to admit that it looked better while using your faked data.

# Lessons Learned
Software Development is involving a lot of different people and all these people have different demands.

Customers want to have features, Sales want to pitch how incredibly stable an application is and what kind of things you can do with it. Developers tend to care the most about stability and how easy it is to work with the code base.

As a developer you automatically value code quality high. Maybe higher than your business is justifying it. See this article as some food for thought to also keep the business cases in mind. Maybe you think about this article the next time you pickup a task.

By opening up the requirement process to all people and making it transparent, I really think everybody can be much happier. After all, Sales, Product Owners and Developers all can be friends – even thought they might be fighting a bit from time to time over different things.

*As always, I am really interested in hearing your opinion about this. 
Have you ever worked as a Developer who had no power in deciding what will be implemented next? Or were you working in a startup were you were basically deciding what to add next?*

Feel free to reach out via [twitter](https://twitter.com/eiselems).