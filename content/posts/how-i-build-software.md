---
title: How I build software
date: 2026-08-17
description: My personal workflow after working with AI agents for two years
slug: how-i-build-software
---
Since Claude Code became a thing in my day to day around June 2025, my workflow has gone through many changes on a monthly basis.

## 0. The mental model

Mental models are a really simple thing: how you represent reality in your mind. How you, essentially, carve the important things out of a problem and ignore the redundant parts.

Your mental model or, more importantly, the shared mental model of your team or company about a given reality (customer problem, market goal, competitor dominance, technology stack, etc.) is the only thing that matters. AI can blast you with an infinite number of generated artifacts, but if you don’t internalize the model yourself you will never be able to leverage AI.
  
AI, when used properly, will allow you to update your mental model quicker than before. But you still have to think and internalize the things you build.

## 1. Rambling

### Embrace voice

I start every project by using voice mode either directly in Claude Code or through a local STT model using Muesli, a desktop app for MacOS.

Voice is much quicker than typing and has the advantage of letting your hands (and legs) free to ramble across the room with your AirPods on.

Then I sent that transcription to Claude Code without any edits with a prompt like “Here’s my ramble about XYZ, try organizing my thoughts and craft a few questions to pull some threads: [Transcript].”

I read Claude questions, ramble a few more minutes, sometimes I stop and search for something on the Internet, etc.

Let’s say, to put up an example, I’m rambling about how to create an MCP over my API to provide to my clients. In the same rambling session I can touch many different topics such as: pricing, OAuth, LLM clients, tools surface, agentic tools, observability, auditability, how I should deploy it, etc. **The important thing in rambling is crafting the questions rather than the answers.**

After rambling, I just ask Claude to save everything to RAMBLING.md in whichever folder I'm in.
## 2. Organize yourself

When tackling long projects I like to create my worktrees upfront. Worktrees are a really cool abstraction in the git version control system that allow you to create a copy of your repository files scoped to a feature branch.

I usually just ask Claude "Create a folder in my ~/Workspace for project XYZ, start setting up the worktrees for the different repositories involved, move my RAMBLING.md file as well.".

Worktrees are cool because you can have many different copies of your repositories and work in many branches at the same time while you wait other agents to finish.

## 3. Research

At this point, I know what the problem looks like and I've identified the different scopes of work I have to do. While I fidget with the PRD in my main agent I tell Claude to go inspect the whole codebase and make a RESEARCH.md file with all the relevant code pieces it found, how the codebase is structured, how tests work, how code is deployed, etc.

After Claude finishes a new RESEARCH.MD is saved. This file is usually correct because LLMs are really good at documenting and you probably don't need to read it. I tipically just skim it to get my mind up to date or when I'm working on a new codebase.

## 4. Planning

This is the big piece, at least when working with complex codebases. When you are 

## Rambling savepoints and a word of caution

After a few turns at this mechanic, I ask Claude to create a dump of everything that we discussed in a MD file and a Claude HTML artifact. Why both and what do I use them for? MDs are like savepoints for Claude, but I will rarely read them because LLMs prose is really cumbersome and verbose, they are useful mostly for getting Claude up to speed in follow-up conversations on the same topic. And HTML artifacts are a good way of sharing some parts of your mental model updates with your team.

  

Imagine something worse than having to read all the MD files your LLM generates: reading the MD files that the LLM of someone else generated. Remember that keeping your mental model aligned with the rest of your team is one of your key responsibilities and if you start sharing all nonsensical MD artifacts everyone will stop paying attention to your updates after a while.

  

Or to say it in other words: [Don’t make me talk to your chatbot](https://raymyers.org/post/dont-make-me-talk-to-your-chatbot/).

  

## Research or how to shape rambling

Congratulations! After your first rambling session you have made progress and moved to the point where you have discovered a lot of things you did not know about the problem and its constraints. You now know what you don’t know.

  

Now, the next step is to start mapping out the existing shape of the system, its pieces, and start thinking of how new pieces of information and functionality will come to life to solve the problem.

  

At this point, I just open a new Claude session, reference the old MD rambling savepoint and tell Claude to research the existing codebase and find which pieces of functionality are there and which pieces aren't. I usually prompt this step by voice but you can write too ([Dex research skill is great for this](https://github.com/humanlayer/humanlayer/blob/main/.claude/commands/research_codebase.md)).

  
The goal at this point is to have Claude generate another important piece of context and save it to an MD file. I also ask it to provide an HTML artifact with the pieces of the codebase I need to know.

  

Following the MCP example, at this point I will get a list of all the API operations my codebase allows, how authentication and authorization is currently handled, what failure modes and error handling are implemented, and so on. 

  

I will read the artifact to update my mental model on what’s currently implemented. What’s the current state of the system? This is really key. Most of the time, to know the next step we need to visualize the transition between point A to point B.

  

Now your mental model is ready for an update, but nothing has changed yet. 

## Beware of the rambling monster

A classic rookie mistake at this point would be taking the ramble and prompting Claude to “/goal Solve this problem, make no mistakes and make sure tests pass”. YAGNI assured. 

  

Even if Claude nails the problem, you will doubt at the code review step or ship it to production without looking at the code. Either option is awful. Remember you cannot ship things fast until you learn how to understand things fast.

## Now we are talking: plan time

You now understand the problem and have the context of the current state of the system in your brain. The next step is to start chunking the things you have to change and build into groups or phases with nested levels of abstraction.

  

At this point, I start a new session with Claude and reference the research and rambling MD savepoints. I tell Claude to give me a high level overview of the components.

  

So now, I have three big phases: OAuth support for my API (so clients can connect over MCP), the MCP server scaffold and the MCP tools surface design.

  

In a single prompt, I will tell Claude to go make both an MD file and an HTML artifact explaining how each phase will be built. I tell it to be very specifics of the code lines that he will change, new dependencies that will be introduced, behaviors that might break, how clients are gonna consume this E2E, what definitions of done are, how I want the testing to be made, how I want my commits, how I’m gonna be in the loop, and so on.

  

This is your plan prompt and it is really unique to you. Do not waste a lot of time refining it or testing thousands of skills since harnesses and models evolve so quickly all your efforts will be wasted in less than six months. Focus on crafting a simple list of requirements that are common to all your code (style, commits, testing patterns, code strategies, etc). 

  

If you feel lazy, just ask Claude to review your past commits or merge review comments and extract some of this behavior.

  

At this step, I like to use Claude with either ultracode or effort xmax and tell Claude to spawn as many subagents as he wants. After a while, the HTML artifact will be done hopefully containing all the details that I asked.

  

I will start rambling mode again, put on my AirPods and start looking at the plan and pointing out things I don’t like or that are wrong. The key here is to go very direct:

  

“At point 1.1: Always use handler base abstraction for new routes”

“At point 1.2.: Mock as little as possible in your tests”

“At point 1.3.: Don’t introduce this new dependency and rather code the functionality by hand”

  

Often, a point will feel wrong but I won’t have a clear direction to take to solve it. So, in that case, I like to just say “At point 1.4. It feels weird having so many classes that share very similar behavior. Can you come up with 2 or 3 different ideas on how to design this layer of the code with new abstractions?”.

  

When I have a first pass at the plan, I tell Claude to make amendments to the plan.

  

A new plan comes. Same thing. Another pass, round of feedback. I like to think really deeply about the solution here. Sometimes I might go and write some pseudo code in my head.

  

## How you cut your pie

If you've ever been tasked to cut a pie at a birthday party you know everyone has an opinion on how you should do it. Planning and scoping a complex feature is not an exception to that.

  
I like to cut my feature pies in vertical slices.

  

![](https://docs.google.com/u/0/docs-images-rt/APuouOfB32MT1rt1VPGdYg9CDPR1DVCFgl2LCfAmrbC-o00HwyRrz7yWqHMnoAx5aqeQ5lVVY98SfgLNc0hzevn4QSzWqMbKdufdIu50zRRIHcR7lDAbnntis5D5U4Q61mCiySyKFLy9zVyR1dlClLryF95qTXuDyXrg2KuI1mlo1VCI=s2048)

  

You can just ask Claude to provide you with the vertical slices itself but it's fun to do the thought experiment yourself, so you need to:

  

1. Visualize the whole pie. Think of the whole feature with all the details (the full MCP product, in the example).
    
2. [Map the scopes](https://basecamp.com/shapeup/3.3-chapter-12) (OAuth Setup, OAuth multi-merchant, OAuth consent screen, MCP server spinup, MCP server authorization, MCP tools, MCP tools auditability, etc).
    
3. Identify phases or slices of work you can ship by making increments at different scopes (OAuth + MCP server with 2 read tools).
    

## Implementation

The easy part. At this point my mental model has been updated by the whole rambling-research-plan loop and I’ve learnt many useful insights about the problem, its constraints and the different shapes of solutions.

  

At this step, when the plan is solid, I just open a brand new Claude session and prompt it to “/goal Implement slice 1 of docs/[plan-XYZ.md](http://plan-xyz.md)”. I will have a global [CLAUDE.md](http://claude.md) file with my checklist of how I like my code.

  

My global [CLAUDE.md](http://claude.md) file looks like this:  
  
  

1. Do not include comments unless there's a non obvious decision that cannot be explained through method or variable names.

2. Work in small, atomic commits. Do not include commit descriptions unless there's something important about WHY the change was made.

3. Run tests and linters on every commit.

4. Test E2E following project conventions after each commit.

5. Avoid ultra defensive code. When faced with a hyphotetical edge case, ask the user about it rather than implementing a super special edge case handling code.

6. Use ENV vars for configurable parameters.

7. Do not push to remote branches unless told explicitly.

  
  

And in the [CLAUDE.md](http://claude.md) or [AGENTS.md](http://agents.md) file at the repository I’m working on, I will usually have project specific conventions. I like, for example, to spin up dedicated databases for each worktree in a shared docker container in my computer (Apple Silicon is really powerful these days and you can do dozens of logical DBs in a single container with no memory or CPU issues).

  

## Fighting slop

After your first round of implementation on any decent-sized feature you are going to have some slop in your solution. We can define slop as low quality code.

  

Before opening a MR, you should open your IDE and review the code generated by the LLM as if you were reviewing a real diff request sent by a teammate. There are agentic IDEs like Warp or Orca that can fast-forward this process or you can just use something like VS Code or nvim.

  

At this point, I spin up voice mode again and start pointing out all the problems I see with the code focusing on slop.

  

Slop can be classified in two buckets:

  

1. Style slop: overcomplicated code, abuse of comments, shallow classes with no meaning, tests that do not test nothing, etc. E.g.: if the LLM decides to put together a lib/mcp/tools/fudo/[base.rb](http://base.rb) and a lib/mcp/tools/[base.rb](http://base.rb) and make all tools inherit from those useless base classes.
    
2. Functional slop: bugs or non-complete solutions to the problem. E.g. if my MCP first slice has no authorization.
    

  

You fight style slop with better [CLAUDE.md](http://claude.md) or with prompting. You can have a “review” skill that checks for your different style smells and steers the model to fix them.

  

Functional slop is much harder to fight because it means your plan has a mental model gap. The good thing is that if you’ve done your rambling-research-plan loop well enough, you will spot these problems right away.

  

## Updating your mental model to the cloud

When you are done with the code, it is always a good idea to automate the whole E2E testing. I always tell Claude to record a video of himself testing the feature whether it is by using CURL over an API or navigating a browser with Playwright and put that evidence into an HTML artifact.

  

I just take a final look at it to verify, and then I open the MR(s).

  

We’ve automated the whole process by using LLMs while learning a lot about the problem and developing a mental model around it that will compound over the next slices we’ll ship and throughout the next few years we’ll have to maintain the feature.

  

But before you go, don’t forget to upload your mental model to the cloud (e.g. share the knowledge with the rest of the team). In engineering orgs knowledge is usually shared in code reviews or RFCs. If there’s a stage in the whole loop where you should invest in doing your own writing and communication is in feature descriptions, RFCs or even MRs descriptions.  
  
If you have understood the problem well enough (and, hopefully, the solution) you should be able to put together a decent description of the problem, the mental model around it, the solution you chose and its tradeoffs. Craft a decent two or three paragraphs about it and make sure your team invests 10 minutes in reading it.

  

You can include an appendix with LLM-style documentation where all low level details are referenced.

  

If you can’t write a one-pager by hand, it means you probably need to reupdate your mental model.

## Keeping the house tidy

After you ship the feature, you are going to have to do lots of operations work to make sure it works, it behaves as expected, users are happy, your requirements are understood well, performance is between thresholds, and so on.

  

Connect your agentic harness to your observability tools, OpenSearch, Langfuse, Grafana, Sentry or even Slack or ClickUp to get feedback. Setup a scheduled task to run once a day based to proactively find exceptions, bugs, slow queries or user complaints and triage them eagerly.

  

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

**