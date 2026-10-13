---
title: You might need a software workshop
date: 2026-10-12
description: What we learned in SF about software factories, and what I would build first
slug: you-might-need-a-software-workshop
---
Everyone is talking about software factories. I think most teams need a workshop first.

## The first time I heard the term agentic software factory

In April 2026, we traveled to SF to talk to folks over there and see how things were developing after Claude Code and agentic development bloomed at the end of 2025. We, being a small team from Argentina, wanted to know how far ahead things were compared to the local landscape.

We met with founders and engineers and asked all of them basically the same thing: are you still reviewing the code? Is all the code AI-generated? How many PRs are you shipping a week?

We polled from 2-guy startups to Google SWEs and the responses were in a similar range of “We use Claude Code/Codex a lot, still review the code, ~90% of code is auto generated”.

I remember that one of the first people we met was Antonio, who explained the matter very clearly. He basically stood up, grabbed his whiteboard and drew a diagram like this:

![A spectrum from cheap to expensive: Copilot and CodeRabbit, Claude Code, background agents, software factories](/img/agentic-spectrum.png)

And then, he explained to us that in his eyes most engineering teams were somewhere between the Claude Code and background agents phases.

Back then, the most powerful model in the world was Opus 4.7 and the word harness was beginning to catch on, along with other terms like loops and so on.

After our initial talk with Antonio we went on to meet with several more really smart fellows and drew a final conclusion: it did not make economic sense for us to build a software factory. Background agents? Maybe, but we weren’t really sure how to set them up in a way that would serve our 60+ engineers (or more people if we factor in product and design teams as well).

I remember that at the time we kept discussing what the hell the concept of “software factory” meant. An AI software factory, you mean? A dark factory? Which kind of factory? A tire factory in Argentina or an autonomous Toyota plant in Kentucky?

Since software is something that is hard to mass produce because it embeds lots of concepts, tradeoffs and choices that are really hard to model in a replicable way and is often a function of user requirements that are dynamic and possibly unknown at the time of manufacturing, we did not arrive at a good answer to those questions.

What was clear was that there were some folks in the industry that set out to build dark software factories: basically, systems that take user requirements and via LLMs transform them into a final piece of software that is verifiable. And this meant, obviously, that humans reading the code was no longer feasible. It would be like trying to have a human review every solder joint in a factory.

Months went by and the buzzword was slop. Everyone was full of slop, tech debt, code that is impossible to change in a quick way, an approach nobody could trust. No engineer could wrap his head around these new slop mountains.

So it became clear that dark software factories were not possible, or at least not the way most folks were building them, just basically setting one builder agent and one reviewer agent and making them ship to prod in a loop.

## What I realized about effective engineers

As an engineering manager, I have a deep curiosity about what makes an effective engineer. I measure impact as a function of both speed and quality.

So, a few years ago, the 10x engineers were basically the ones shipping code with more confidence. A regular guy would set up the environment locally, test everything e2e and then open the PR. The best engineers were not doing that. They developed a mental model of the codebase and just shipped straight to sandbox (in the best of cases). They were shipping in ⅕ of the time without breaking anything.

They had a way of verifying their changes quicker than the other engineers. This was half intuition and half really good unit and integration test tactics.

**So, to put it in basic terms, how fast you change production is a function of your confidence in the change.** The confidence of a change depends on its impact, reversibility, observability and verifiability, plus psychological factors like expertise, self-esteem and culture.

**Effective engineers are confident not because they live in YOLO mode but because they have learned to predict the impact a change will have on the system.**

## Before the software factory, build your workshop

I have not seen dark software factories run at scale and I think we need some time to see the results of the experiments that are being run in the wild right now ([like this one from Shopify](https://shopify.engineering/shop-app-migration)), since maintainability has always been a hard concept to measure and it takes months to see how an architectural decision will impact future cost of change or reliability.

So, to go back to Antonio’s model, I would say that **a level before agentic software factories we can build agentic software workshops.** Basically, find a way of creating all the tools and machines we would only have dreamed of before and put them close-by. Build the tools of your software workshop.

A factory turns requirements into software with no human in the loop. In a workshop, the engineer still owns the [mental model](/posts/how-i-build-software/) and keeps the tools within reach.

## How I would build my agentic workshop today

Most of these tools give everyone what the best engineers had: a quick way to verify a change.

### Background agents

During the SF trip I thought background agents were the future and I think they are now the present. Every good software company should use them to watch production logs, analyze user data, watch exceptions and fix them, debug issues before they occur and so on. Multiplayer agents like [Open SWE](https://www.langchain.com/blog/open-swe-an-open-source-framework-for-internal-coding-agents) or Claude Tag are really good but you need to give them access to your production codebase and observability tools. Without that, they are useless.

Cool things about background agents:

1. You can spin up work from Slack or Linear directly.
2. You can tag your agent on GitHub for a code review or for context.
3. You can play multiplayer in Slack or other channels.
4. You can develop some ontology or skills that can encapsulate your team’s work and conventions.

You can experiment with Open SWE or OpenCode and even try running those in Cloudflare Workers.

### Agentic code review

Background agents or even Claude Code usage will generate hundreds of PRs that are really not that meaningful but can help one user or fix one exception. **Without a good review agent they will sit there forever because you will never have the confidence to ship them.** Some of your code should be in auto-merge mode when it’s low stakes.

This can be baked into your own background agents by the way.

### Really good CI pipelines

Invest time optimizing your CI, make your tests run in parallel as much as you can, remove bloated tests (e.g. unit tests might no longer be relevant) and experiment with new ways of E2E testing your whole system.

### Architecture linters

If you want to limit the dependencies between different parts of your application, just enforce those boundaries in your CI. There are good tools in every language. For Ruby, we’ve been using this one: [ArchSpec](https://archspecrb.dev/).

![ArchSpec rules in Ruby: controllers can only use models and services, models cannot use controllers, services cannot call render or redirect_to](/img/archspec-boundaries.png)

### Third-party mock servers

Testing integrations with third parties always sucked because you don’t have a real API server and E2E testing is hard. But nowadays you can one-shot a realistic stub server that can run alongside your test suite or sandbox environments just by pointing your agent to their API docs. And if they don’t have an API doc you can always make your code running in production self-document those APIs’ behavior via logs.

### Cloud devboxes

Devboxes were always a really cool way to let your engineers set up new environments quickly. Now every one of your engineers can have dozens of agents running at the same time and all of them will need a way of testing their changes in an isolated environment. Move these devboxes to the cloud so your developers can run their agents while on the go or at night.

You can even spawn unattended work for observability, bugs or other proactive stuff.

### AI-shed

Hate to quote DHH but another way of experimenting with devboxes is grabbing an old machine or a beefy VPS and building an AI-shed for you or for a subset of your team:

{{< tweet "https://x.com/dhh/status/2106755814421565495" />}}

I’ve built mine using a Thinkpad I had laying around. It even has its own Grafana dash and builds over wifi. Took me 20 minutes to set it up with Ubuntu Server + Claude Code + Tailscale.

![Grafana dashboard of my AI-shed: uptime, CPU, RAM, disk, temperature, battery, load and memory over the day](/img/ai-shed-grafana.png)

## The factory can wait

Go back to Antonio’s whiteboard. Most teams sit somewhere between Claude Code and background agents, and a factory is still expensive and unproven. A workshop is how you move right on that line at a price you can pay. Every tool you add makes your engineers, and your agents, more confident in their changes. And confidence is what lets you ship fast.

## References

1. [Claude Code](https://claude.com/product/claude-code) and [Codex](https://github.com/openai/codex)
2. [GitHub Copilot](https://github.com/features/copilot) and [CodeRabbit](https://www.coderabbit.ai/)
3. [Migrating Shop app from React Native to native](https://shopify.engineering/shop-app-migration), Shopify Engineering
4. [Open SWE: An Open-Source Framework for Internal Coding Agents](https://www.langchain.com/blog/open-swe-an-open-source-framework-for-internal-coding-agents) and [its repo](https://github.com/langchain-ai/open-swe)
5. [Deep Agents](https://docs.langchain.com/oss/python/deepagents/overview), the LangChain harness Open SWE is built on ([repo](https://github.com/langchain-ai/deepagents))
6. [Claude Tag, Claude Code in Slack](https://code.claude.com/docs/en/slack)
7. [OpenCode](https://opencode.ai/)
8. [Cloudflare Workers](https://developers.cloudflare.com/workers/), plus [Agents](https://developers.cloudflare.com/agents/) and [Sandboxes](https://developers.cloudflare.com/sandbox/) to run agents on it
9. [ArchSpec](https://archspecrb.dev/), architecture linter for Ruby and Rails
10. [Pi Durable](https://earendil.com/posts/pi-durable/), Earendil
11. My AI-shed: [Ubuntu Server](https://ubuntu.com/download/server), [Tailscale](https://tailscale.com/) and [Grafana](https://grafana.com/)
