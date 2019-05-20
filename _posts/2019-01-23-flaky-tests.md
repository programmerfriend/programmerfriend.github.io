---
layout: post
title: Flaky Tests and other Demons
image: /img/content/flaky-tests_title.jpg
bigimg: /img/content/flaky-tests_title.jpg
permalink: /flaky-tests-and-other-demons/he-and-spring-aop/
redirect_from: 
    - /2019/01/23/flaky-tests-and-other-demons/
tags: [tests]
---

> What have Demons and flaky Tests in common?

I think a lot. Demons haunt you while you are living your life. They also corrupting the soul of their targets. Ok, maybe I exaggerated just a bit. Still if you think more deeply about this comparison, there is a grain of truth in it.

____

## Corrupting Tests are haunting you while you do your work:
Just imagine following scenario:
You modify some code and wait for the tests to finish and then out of a sudden there are test fails.

Yikes. Ok, alright. Probably you did some mistakes while refactoring or you just made some logical mistake somewhere in your code. No biggie.

### What you gonna do now?
Of course you will have a look and spent quite some time figuring out if your changes are the reason for the regression. If you are lucky, the fail is totally unrelated to your change.


> At least you are now sure it wasn’t you, are you?
> 
> Voice in your head


Probably not to 100%. At least your gut feeling is already telling you that it was not your code. But you are still not sure. The other scenario is when you have changed the code which is directly related to the failing tests. After thinking really hard, you come to the conclusion it does not make any sense at all.

## But what now?
You revert your changes and build the code again … and again … and again.
Every thing works fine. So it seems again that your code is to blame.
You set up breakpoints because you don’t understand how your code is affecting it at all.<br>
No hits.<br>
Ok, back to the master revision and another build.<br>
It is red. You are clueless.<br>

<figure>
  <img src="{{site.url}}/img/content/flaky-tests_jenkins.png" alt="Builds of a Jenkins Pipeline - a few greens with a few reds"/>
  <figcaption>This is what it could look like
: Jenkins with a lot of flaky tests
</figcaption>
</figure>

## The Tests are flaky
At least you now know that the test seems to be flaky.
Personally I really hate this situation. In order for them to be effective, you need to trust your test cases. If you don’t have a lot of trust in your test cases, why then even write them?

If they turn red, you will ignore them anyway. If you don’t ignore them, you will always be spending a lot of time thinking about something which is not really beneficial to neither you nor your application.

### They are not corrupting your soul, but they are corrupting the core of your tests
If you have some flaky tests, you will lose the ability to trust your test cases. In case this initial trust is lost, it may be hard to recover it. Not trusting the tests leads to sloppy behaviour. People will start merging Pull Requests despite the build not being green and overall people might really be the motivation to write good tests.

Why should they care, probably it was a false positive anyway. It works on their machine. This will definitely hurt and come back to bite you.

### But what we gonna do about these flaky tests?
Well, to be totally honest I am writing this after spending quite a while today sitting on such a test. I am not really sure. What I am gonna do is probably test the functionality manually to be sure it works.

The next step tomorrow could be to sit there and rewrite the test in another way. I am also considering to give it to a fellow Developer:

Not because I am already a bit annoyed about the situation *(ok that might be part of it)*, but more because I could tell him to write a new test without seeing the old one.

With his fresh approach we might get a totally different test which is not having this issue then.

Let’s hope the best and see if we end up ignoring the test or fixing it.
Like with demons, I guess you can either exorcise them or live with them 🙂

____

*How are you dealing with them personally? Would really love to hear back from you.*
