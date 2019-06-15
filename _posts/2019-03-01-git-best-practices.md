---
layout: post
title: Git Best Practices
image: /img/content/git-best-practices_title.png
bigimg: /img/content/git-best-practices_title.png
permalink: /git-best-practices/
redirect_from: 
    - /2019/03/01/git-best-practices/
    - /index.php/2019/03/01/git-best-practices/
tags: [best-practices, git]
---

Over the years I learned a lot about git. Most of the parts I learned the hard way by using it on a regular basis. Here I summarize a lot of the things which I would consider Git Best Practices for using git in a team.

# Use the force Luke – use the CLI
At least give it a real try! Like the young Skywalker you at least once should limit yourself to the bare minimals. Use the force Luke – let go!

Over the years I got used to the terminal interface of git in a way that all other interfaces now are more often annoying me. They are not per se bad, it is just that I feel you need to learn the fundamentals of git.

Even with a lot of experience I sometimes have troubles to understand what a graphical tool is trying to do when you click something.
Especially bad it is for me when something goes wrong while using a GUI.

For what I really like graphical tools: Staging and reviewing changes you are about to commit and resolving conflicts. In my opinion nothing is beating a side-to-side view on a big screen for that. For these tasks I nowadays mostly use one of my IDEs (either IntelliJ IDEA or Android Studio) which are quite good in this department.

# One commit. One change
A lot of these things I have already pointed out in another article about Code Review Best Practices. Still I want to mention here, what kind of qualities a commit should have.

A commit should be atomic. In practice this means that the source base works with or without it. Each commit should be able to get built. Also if a commit is breaking the build, it should be easily revertible by just looking at the commit itself.

In practice it often comes down to not mixing refactorings with new features. There are a few reasons for that:

By mixing both things you increase the chance of having conflicts which are hard to resolve – not only for your code but also for code which is developed in parallel.
Your code becomes harder to review: A Reviewer has to think about if a change is related to the new feature or just a rewrite of the existing code.
Reverting your changes is becoming harder. Two atomic commits are much better: If there is an issue with the refactoring – Just revert it. If there is an issue with your new feature – Just revert it!
A commit indicating “just did some cosmetic changes” might be a good hint to look further in the history.
# One Pull request. One Concern
Basically the same as above. When you raise a Pull Request make sure that it only about one feature. If possible keep the same rules as above in place.

You could have two atomic commits: One adding functionality and the second refactoring a lot of things. This would not violate the principle of atomic commits. Still it could make reviewing your code harder in comparison to have the two things spread across two Pull requests.

In my experience, Pull Requests containing a feature or a Bug Fix are approved much faster if not cluttered with refactorings or cosmetic changes (e.g. fixing whitespaces). The same speed-up applies to Pull Requests only containing non functional changes. These get also approved faster when separated from changes done to the functionality.

# Proper commit messages
> “How does a proper commit message look like?”
 
This is a question I discussed a lot in the past. I definitely will write an article about my opinion of well written commit messages sooner or later. From my experience a commit message should give you what the code alone can not give – **CONTEXT**.

The commit message should be containing a short summary WHAT was done. This should be followed about the WHY this specific commit is necessary.

A commit message I kind of wrote today was (replaced some things to not expose sensitive things):

```
FIX: Update FEATURE A to be based on VAR_A instead of VAR_B

We found a bug when there was an existing VAR_B from FEATURE C.
This caused FEATURE A to not properly update when FEATURE C was used before.
The UI reacts in this case by never finishing the loading process, this is due to the
endpoint returning "updating" instead of "finished".
```

When you are familiar with the code base you should have a good picture of what the commit should contain and also what the reason for it was. If you see later some odd behaviour introduced by it, you definitely know this was not the intention of the commit.

# Commit often, Squash and Publish
By doing this you will have a lot of benefits (the following points are very opinionated).

1. You can just by tracking your commits history see what you tried to achieve
1. These commits must not be perfect, in my opinion they do not even need to compile
1. Feel free to push these changes to your remote branch, so you have a backup in case you do something stupid (or your machine dies).

> “But isn’t this just the opposite what you said before!?”.

Yes it is.

To my defense: This should only be temporary. Before you create your Pull Request make sure to try to squash everything into one single commit. With a bit of practice you will see that this one commit will fulfill all the requirements I discussed in the part about commits.

A term I discovered while doing a little research on the topic is **“Sausage Making”** (see: [article by Set Robertson](https://sethrobertson.github.io/GitBestPractices/)). This is a reference I really like.

Like we already have realized, atomic commits are what we want to achieve. Still there are all these benefits of committing often, which are just the exact opposite of that.

The production of sausages is a really non-appealing process. I don’t want to get into detail there. But when you see sausages, the producers tries everything to hide how they were produced.

The same should be valid for our commits which are part of a pull request. They look polished and shiny, fulfilling all the requirements we had on atomic commits.

Think we have already covered a lot of things. But there are some additional points on how to be a good git repository citizen.

# About merge commits
Personally I don’t use them at all – but they have their fans which also have a valid point.
But since I have a feeling that this is a similar debate like favorite editor or “tabs vs spaces”, I will leave it out of here. When you want to hear an advice here: Define a process within your team and stick to it.

# Don’t rewrite history on shared branches
**This is a must!** If you are rewriting history, you make life harder for everyone else working on that branch. People working on that branch will easily have conflicts and because of that their usual workflow is interrupted.

Please don’t do this on branches you are sharing. I usually solve this by communicating with other developers when we are working on a feature branch together. Mostly we just commit on top since our branch will get squashed before merging anyway.

# Protect your important branches from rewriting
There is one branch a lot of people will share. **MASTER**. Do yourself and your team a favor and set up branch protection.

By branch protecting the master branch, nobody should be able to rewrite history for it. If you want to take it a step further, you can even disable all contributions to master. This means that every contribution has to be merged using the Code Review process (e.g. Pull Requests) and therefore needs to pass at least another pair of eyes.

# Do not commit large binaries
I don’t want to get into the downsides of DCVSs (Distributed Code Version Systems), but git is not really designed to keep binary files. If you have big binaries maybe look for an alternative to storing them in your repository directly.

Adding binaries in general makes cloning your repository slower and the general performance of git could degrade. In case you need your binaries versioned, look into solutions to this problem like git LFS or maybe even switch over to SVN.

# Do not commit generated files
This is somehow related to the previous point. Committing generated files is not helping your repository size. Especially since they bring no additional value. The effect of these files is especially bad if they get regenerated very often.

# Summary
This list probably will get extended in the future.

But for now, this is it. I really hope this list of git best practices did cause more head nodding than facepalming on your side. I think following this advices might help you on finding the things in git which work for you and your team.

If you have some ideas for extending the list, feel free to reach out via [twitter](https://twitter.com/eiselems).