---
title: "You still have to think"
date: 2026-08-17
description: "My view of agentic engineering: mental models, rambling, slop, and why the edges of the loop stay human."
slug: "you-still-have-to-think"
---

Since Claude Code became a thing in my day to day around June 2025, my workflow has gone through many changes on a monthly basis.

The old way of working is dead and there are some new recipes which become key for the AI new world.

## The mental model

Before I get started on my work recipes for the age of AI, I want to go back to the fundamentals of intellectual work and remind you of mental models.

Mental models are a really simple thing: how you represent reality in your mind. How you, essentially, carve the important things out of a problem and ignore the redundant parts (hence, modelling reality).

Your mental model or, more importantly, the shared mental model of your team or company about a given reality (customer problem, market goal, competitor dominance, technology stack, etc.) is the only thing that matters. AI can blast you and your company with an infinite number of generated models, but if you don't internalize the model yourself you will never be able to leverage on AI.

You still have to think. You still have to go deep and understand the problems you are working on. If you don't, you will never outpace your competence. **Using AI effectively is all about how quick you can update your mental model.**

## Start with voice

Voice is much quicker than typing and has the advantage of letting your hands (and legs) free to ramble across the room with your AirPods on.

> The important thing in rambling is crafting the questions rather than the answers.

## Work in a worktree

Worktrees are a really cool abstraction in the git version control system that allow you to create a copy of your repository files scoped to a feature branch. Worktrees are really cheap and are usually all you need to parallelize different tracks of work at once.

Since LLMs are very slow, you don't want to sit staring at the screen but rather you want to have two or three sessions in parallel each one with its isolated worktree.

## Rambling savepoints and a word of caution

MDs are like savepoints for Claude, but I will rarely read them because LLMs prose is really cumbersome and verbose, they are useful mostly for getting Claude up to speed in follow-up conversations on the same topic. And HTML artifacts are a good way of sharing some parts of your mental model updates with your team.

Imagine something worse than having to read all the MD files your LLM generates: reading the MD files that the LLM of someone else generated. Remember that keeping your mental model aligned with the rest of your team is one of your key responsibilities and if you start sharing all nonsensical MD artifacts everyone will stop paying attention to your updates after a while.

Or to say it in other words: *Don't make me talk to your chatbot*.

## Research or how to shape rambling

Congratulations! After your first rambling session you have made progress and moved to the point where you have discovered a lot of things you did not know about the problem and its constraints. You now know what you don't know.

Now, the next step is to start mapping out the existing shape of the system, its pieces, and start thinking of how new pieces of information and functionality will come to life to solve the problem.

I will read the artifact to update my mental model on what's currently implemented. What's the current state of the system? This is really key. Most of the time, to know the next step we need to visualize the transition between point A to point B.

Now your mental model is ready for an update, but nothing has changed yet.

## Beware of the rambling monster

A classic rookie mistake at this point would be taking the ramble and prompting Claude to "/goal Solve this problem, make no mistakes and make sure tests pass". YAGNI assured.

Even if Claude nails the problem, you will doubt at the code review step or ship it to production without looking at the code. Either option is awful. Remember you cannot ship things fast until you learn how to understand things fast.

## Now we are talking: plan time

You now understand the problem and have the context of the current state of the system in your brain. The next step is to start chunking the things you have to change and build into groups or phases with nested levels of abstraction.

This is your plan prompt and it is really unique to you. Do not waste a lot of time refining it or testing thousands of skills since harnesses and models evolve so quickly all your efforts will be wasted in less than six months. Focus on crafting a simple list of requirements that are common to all your code (style, commits, testing patterns, code strategies, etc).

If you feel lazy, just ask Claude to review your past commits or merge review comments and extract some of this behavior.

A new plan comes. Same thing. Another pass, round of feedback. I like to think really deeply about the solution here. Sometimes I might go and write some pseudo code in my head.

## How you cut your pie

If you've ever been tasked to cut a pie at a birthday party you know everyone has an opinion on how you should do it. Planning and scoping a complex feature is not an exception to that.

**I like to cut my feature pies in vertical slices.**

You can just ask Claude to provide you with the vertical slices itself but it's fun to do the thought experiment yourself.

## Implementation

The easy part. At this point my mental model has been updated by the whole rambling-research-plan loop and I've learnt many useful insights about the problem, its constraints and the different shapes of solutions.

## Fighting slop

After your first round of implementation on any decent-sized feature you are going to have some slop in your solution. We can define slop as low quality code.

Before opening a MR, you should open your IDE and review the code generated by the LLM as if you were reviewing a real diff request sent by a teammate.

Slop can be classified in two buckets:

1. Style slop: overcomplicated code, abuse of comments, shallow classes with no meaning, tests that do not test nothing, etc.
2. Functional slop: bugs or non-complete solutions to the problem.

You fight style slop with better CLAUDE.md or with prompting. You can have a "review" skill that checks for your different style smells and steers the model to fix them.

Functional slop is much harder to fight because it means your plan has a mental model gap. The good thing is that if you've done the rambling-research-plan loop well enough, you will spot these problems right away.

## Updating your mental model to the cloud

We've automated the whole process by using LLMs while learning a lot about the problem and developing a mental model around it that will compound over the next slices we'll ship and throughout the next few years we'll have to maintain the feature.

**But before you go, don't forget to upload your mental model to the cloud (e.g. share the knowledge with the rest of the team).** In engineering orgs knowledge is usually shared in code reviews or RFCs. If there's a stage in the whole loop where you should invest in doing your own writing and communication is in feature descriptions, RFCs or even MRs descriptions.

If you have understood the problem well enough (and, hopefully, the solution) you should be able to put together a decent description of the problem, the mental model around it, the solution you chose and its tradeoffs. Craft a decent two or three paragraphs about it and make sure your team invests 10 minutes in reading it.

> If you can't write a one-pager by hand, it means you probably need to reupdate your mental model.

## Keeping the house tidy

After you ship the feature, you are going to have to do lots of operations work to make sure it works, it behaves as expected, users are happy, your requirements are understood well, performance is between thresholds, and so on.

## Keep updates coming

Now you have a loop. Not a bullshit engineering loop technique but a mental model loop where you understand a domain and can iterate the next slices of the solution quicker.

If you invest the time upfront, after you ship the first slice you can ship the next slices or feedback and iterations changes very quickly, maybe tons of them a day coded with Claude between meetings.

And you can do it because you:

1. Used voice to ramble about a problem and let your thoughts swarm up.
2. Leveraged AI to organize your thoughts, find gaps and inconsistencies and show you facts and information about the domain and technologies involved.
3. Carved out a model out of the problem and solution with constraints.
4. Transformed that model into scopes.
5. Mapped those scopes into slices.
6. Planned those slices to the code level.
7. Implemented, shipped and observed those changes live in prod.

In this graph, nodes are automated with LLMs while edges remain human. You steer the model through the graph not because the model essentially needs it (that it does), but because you as a human need to build the mental model around the system.
