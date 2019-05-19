---
layout: post
title: Code Review Best Practices
image: /img/content/codereview_title.jpg
bigimg: /img/content/codereview_title.jpg
permalink: /code-review-best-practices/
redirect_from: 
    - /2018/12/10/code-review-best-practices/
tags: [codereview, best-practices]
---

At work, we are using Code Reviews. Everybody knows what a Code Review is, everybody does them (at least I hope you all do).

If you spent some time to talk with people about Code Reviews, everybody has its own opinion on what a good Code Review should include or how to do Code Reviews. What are the obligations of each participant? What are well known Code Review Best Practices? But before we start talking about Principles of Code Reviews or which Code Review Best Practices there are – start slow and talk about the basics.

## The Basics

<figure>
  <img src="{{site.url}}/img/content/codereview_code_quality_xkcd.png" alt="A codereview"/>
  <figcaption>An webcomic how code of a self-taught developer may get reviewed. <br />Source: <a href="https://xkcd.com/1513/">XKCD: Code Quality</a><br />
(licensed under <a href="https://creativecommons.org/licenses/by-nc/2.5/">Creative Commons Attribution-NonCommercial 2.5 License</a>.)</figcaption>
</figure>

Let’s take a step back. What are Code Reviews? According to Wikipedia, a Code review is defined by the following quote:

>Code review (sometimes referred to as peer review) is a software quality assurance activity in which one or several humans check a program mainly by viewing and reading parts of its source code, and they do so after implementation or as an interruption of implementation. At least one of the humans must not be the code’s author. The humans performing the checking, excluding the author, are called “reviewers”
>
>Wikipedia

The paragraph after this quote is about the goals of Code Reviews. The main goal of Code Reviews is to find quality issues in the reviewed code. Other goals which are also reached by performing these reviews are:

* Improved code quality
* Keep consistency in your projects
* Finding bugs
* Learning (by getting code reviewed) and Teaching (by reviewing other’s code)
* Creating a sense of mutual responsibility
* Have just a second pair of eyes watching out for small misalignments which accumulate over time and let your code rot
* In general finding way better solutions to problems

So what did we learn from this definition? Code Reviews are a great way for teams to keep their software maintainable and also find bugs before they make it into production. On top of it, they also help to teach new members of the team. Code Reviews allow to pass neat tricks around without investing in formal training or boot camps.

But isn’t this definition missing something? If I would just use this definition and start a code review – I would be lost. What am I supposed to do? I want to cover in the next few passages what, in my opinion, the obligations of each participant are and which Code Review Best Practices we can extract from it.

## The reviewee
First things first: **A code review is not judging or reviewing a persons ability to code.**

“It is ALL about the code”, no matter if the code was written by THE senior developer in the team or the new intern. The duties of the reviewee start way before the review.

In my opinion, the reviewee should make it as easy as it can be for the reviewers. Just try to empathize with them. But what does that mean?

From the top of my head some things that really make reviews REALLY hard for me:

* Mixing refactorings with the implementation of new code
* Reformatting the whole code base in a commit containing also some functional changes
* Not writing a relevant commit message (A topic I might be covering on its own in the future)
 *Adding multiple features in one single code review (or even commit)

### Things to consider
After writing this, I think the most annoying factors in code reviews are, how I would call it, “NOISE” and SIZE. By noise, I mean unrelated changes to the ones mentioned in the commit message. They are a mental burden because during the review you are always not sure whether the changes you look at are just cosmetic or functionally important. 

Second is the size: A commit should add one single thing. If you run into issues that your commits become too big. A solution to this problem might be to split them and let each commit be reviewed on its own. These separated commits then could be merged on an interim feature branch, which later then, could be merged onto master. Keeping these annoyances in mind, I created the following Best Practices for Code Reviews:

#### Do cleanups (e.g. reformatting, fixing typos) and refactorings in own commits.
I would even advice to don’t mix reformatting with refactorings at all. If you are touching the lines with your refactoring, format it correctly and that’s it. It is much easier to review your code if there are just differences in the lines in which you made changes relevant to your refactoring. Sometimes small changes can be easily overlooked when there are a lot of other changes which are basically just cleaning up (remember the noise I talked about). In general Noise just adds complexity to your Code Reviews.

#### Write a relevant commit message
Make sure that your commit message is giving the reviewer a good idea about what the commit is supposed to do and especially why it is done. If there is a heavy limitation which influenced your design a lot – mention it also there.

How does a relevant commit message look like? What I like to do here is using the following format for all my commit messages at work. We as a team agreed on using it.

```
XXX: Add some new feature (short description not too long)

Some more text which is describing the implementation in more detail.
This is a multi-line text but it could also have:
* Bullet points
* For different details
* If there are points with more than one line intend the following
  lines to make them easier to spot

refs #the issue it is relating to
```

Where XXX is an indicator which is linking to an issue (e.g. JIRA-007: some text) or just a keyword like FIX, BUG or MAINT (maintenance) when there is no tracked issue for the code change.

This advice about relevant commit message is not only for Code Reviews, I guess it is a general Best Practice. I already felt an urge to verbally slap people  at work because of commit messages which were missing important information. In comparison to good commit messages where I was really happy when reading them.

Often you come back to commit  messages when you are looking for some answers. Most of the times, when something looks fishy to me I have a look at the commit which introduced the line. What is better than reading your answer just in the commit message and probably having a link to the issue in the issue tracker? (Ok, I admit a comment in the code itself would be probably even better, but this is not so feasible in all cases).

#### Only submit Code which is ready for Code Review
This is also about respect. When I want to have an opinion from another person I should not burden him with unnecessary work. Therefore make sure that your Code is passing all the tests you have for code artifacts. Also, it is not a bad idea to self-review the code which you are about to pass to the reviewers. Have a good look at the Diff of your commit.

#### During the review don’t change the Code
This is also bad, it causes more stress on the reviewer. Often he can easily lose his progress during his code review. If you want to start updating your Code because of findings in the review, make sure to create a commit on top of the commit in review.
By this you allow the reviewers to finish there work and then check the new commit you made for the changes. In the end, when you got all review approvals, all commits can be squashed into a single commit anyway.

### Recap for people looking for Code Reviews – Code Review Best Practices for Reviewers: Don’t put unnecessary work onto your reviewers: 
* Make sure that your code is already self-reviewed and you don’t see obvious flaws why you would not merge it (if you do and want to discuss something, mention it upfront what this review is about).
* The code is not clustered with unrelated changes and therefore unnecessarily long and hard to read.
* Give your change a proper commit message which is clearly giving away the intent of your change.

<figure>
  <img src="{{site.url}}/img/content/codereview_wtf.png" alt="Code Quality Measurement: WTFs per minute "/>
  <figcaption>WTFs/Minute as Code Quality Measurement. <br />Source:  <a href="http://commadot.com/wtf-per-minute/">commadot.com</a><br />
(Original by <a href="http://www.osnews.com/editor/11">Thom Holwerda</a>.)</figcaption>
</figure>

## The reviewer
First thing first: A code review is not judging or reviewing a persons ability to code … 😉

This is I guess even more relevant for the reviewer of a code change. When you word your comments, I would suggest to be more defensive. Often it is possible that you are not seeing issues the creator of the code was facing during the implementation.

But what are we actually doing during a code review? I always fall back to check the same things. These things will later lead to Code Review Best Practices:

##### Purpose:
My first check is always to just check if the code is doing what the commit message says it does. If there is already a discrepancy it is hard for others to validate if the code is correct.

##### Implementation:
After verifying the purpose of the implementation I go for the implementation itself. The first question I ask myself after having read the commit message is “How would I have implemented it myself?“.
After that, I compare the code I have to review with my own imaginary solution. When there is a big difference between my first thoughts and the code to review, I often check out the  commit itself or the one before the change and quickly try my own version.
After a few minutes, I normally know if my own solution is feasible. Things to consider for this phase are factors like:

##### Performance
often not so important – if it is in the same ballpark of the perfect/better solution

##### Readability (IMHO almost the most important)
Covering more edge-cases than the reviewed solution
Whether the same purpose can be achieved with a better code style (e.g. more code reusability)
Often you may have it the other way around – you think about a solution and are surprised how clever the one you have to review is. In this case, it is quite cool since learned something and you more or less have just to check if it is matching formatting and code style guides.

##### Maintainability
For me, Maintainability is one of the biggest factors. This might be biased because I am currently developing on a long-term project. But still, it is quite nice to not slow down your future implementation.

For Maintainability reasons, I always go directly for the tests.
If there are not any, I got bad news. This often means a direct “needs work – write some tests”.
When there are some tests, I verify if they are testing the correct thing and also how the API of the new change is used and whether it makes sense. The unit tests mostly give away how the implementation is supposed to be used. If it is hard to read or hard to use, most of the time the implementation is also not perfect.

##### Compatibility:
Next thing I watch out for are breaking changes on the API level. If there is a modified REST-Controller, it is something really concerning because I don’t want to couple deployment of other services to our change.

In an ideal world, this would be not an issue since we would just deploy both versions, but most often I avoid to do that and go for a version which is not breaking old clients. The same goes for changes in DTO (Data Transfer Objects) which are used for communication between services. When a new value is introduced there, then we need also to be extra cautious about it.

##### Security
Normally your code has a certain security mechanic in place when you need it (e.g. an OAUTH layer or BASIC AUTH for REST controllers). When new code is introduced I verify that it is protected correctly.

##### Understandability
Afterwards, I mostly have an overall look at the implementation. Just checking if it is straightforward or hard to understand. If it is hard to understand, I try (similar to the alternative implementation attempt before) to make it more readable and easier to understand. If my attempts are successful I ask the creator of the code what he thinks about my attempt. Most of the times there is an instant agreement or you meet each other in the middle.

##### Documentation
The last check is about external documentation. When I am aware of existing external documentation (e.g. external wiki or just the README.md), I quickly check if the changes in the code are also reflected there.

### Way to leave comments
I already mentioned it before, but really: Be friendly and make your comments precise but as short as possible. Make sure that it is about the Code and not about the Author. Avoid possession words like your, mine, my, they are easy to misinterpret and it really should be about the code.

Make it clear if your comment is a request for change or an opinion, on which you probably need to discuss. Also if you wrote a lot of nit-picking comments in a really good code contribution, give the author some praise. Long-term this will keep the motivation high – since if you always get a lot of small comments it feels worse than it really is.

## Code Review Best Practices for Code Reviewers
* Be friendly
* Review the code not the coder
* Give short and precise comments about your findings
* Mention at the end when your done (make sure to not forget to praise the good parts)
* If your tools are not supporting it, also indicate whether you want to have another look when the changes are done

## How to do Code Reviews
My personal recommendation is to first establish shared Code Review Principles and Best Practices within your team. It is important to have consent in order to get a commitment by each developer. The next step once these Code Review Principles are established is to create a Code Review Checklist which can be used as a quick check-off list to ensure you covered everything during the review. By using a Code Review Checklist you will make sure that no steps are forgotten. This Checklist is also handy when you have new team members which are really wondering what they are supposed to do during a Code Review. How could such a checklist look like?

## Simple Code Review Checklist
This here is just a guideline on what kind of things your checklist could include.
In order to make it efficient we distinguish here also between code reviewer and code reviewee.

### Code Review Checklist for the reviewee
* Have you cleaned up your Code and is is following the guidelines?
  * You checked the formatting
  * You checked your code for unnecessary whitespace / unused imports
  * You ran your linter locally and it was not seeing any issue?
* Did you use a proper commit message?
  * You wrote about the changes and the reasons
  * You put a reference to the correlating issue in your issue tracker (if existing)
* Is your code easy to understand?
  * Did you name your variables properly?
  * Did you make it too complicated in order to save a few lines of code?
  * Are some comments needed?
  * Can some comments be replaced by better designing your code?
* Are sure your change is effective?
  * If it is a bug fix, you wrote a test which is explicitly reproducing the bug. Your code is making the test green.
  * You are sure that if you touched any existing tests that you did not change what they are supposed to test
* Did you respect the DRY (Don’t repeat yourself)-principle?
  * Could parts be re-used instead of duplicated?
* Is your implementation easy to extend without touching existing code (Open-Closed Principle)?
* Does your solution scale (especially for a lot of users)?
* If you are really going for it: Review the code yourself and go check the Code Review Checklist for Reviewers

### Code Review Checklist for Reviewers
* Remember: It is about the code!
* Check the code formatting (hopefully some tool is already taking care of that)
* Is the supposed change aligning with the rest of the architecture?
* Are Coding Best Practices followed?
  * No magic numbers or hardcoded Strings. Instead Constants or Enums are used.
  * No comments of what the code is doing (most of the times this is a code Smell – Exceptions confirm the rule). Comments about WHY something is done are encouraged.
* Are the Changes respecting Security guidelines?
* Is the written code easy extensible?
* Is the code easy to understand?
  * You will probably have less context the next time you read it as part of your code base.
* Does the change include all the necessary tests?
* Check if the error handling is done properly
* Do you have any concerns regarding the performance?

----

## Code Review Best Practices: A Recap
I really hope the article here could help you to wrap your head about what “Code Review Best Practices” could be and how to conduct Code Reviews. 
We talked about Code Review Best Practices, which duties each participant has and also created a quick outline for two possible Code Review Checklists. For me personally, I live these Principles each day at work. It helps me and I hope also my teammates.

----

*If you have any alternative views on this topic or any improvements to this article – please let me know. I am really curious to hear from all of you.*
