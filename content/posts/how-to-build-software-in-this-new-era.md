---
draft: true
title: "How to build software in this new era"
date: 2026-08-17
description: "Eleven steps, the prompts I actually type, and real examples pulled from my own Claude sessions."
slug: "how-to-build-software-in-this-new-era"
---

*Eleven steps, the prompts I actually type, and real examples pulled from my own Claude sessions. The opinions live in [the other post](/posts/you-still-have-to-think). This one is the kitchen.*

The loop is always the same: ramble, research, plan, slice, implement, review, share, observe. Nodes are automated with LLMs while edges remain human. Every node leaves a savepoint behind, and that is what makes the next slice cheap.

{{< fig name="01-loop" caption="The whole recipe on one line. The dashed return is the point: the second slice costs a fraction of the first one because your mental model is already built." >}}

{{% step num="00" title="Mise en place" %}}

Set these up once. Everything else in this recipe assumes they are there.

- **Voice.** Either voice mode inside Claude Code, or a local STT model. I use Muesli, a desktop app for MacOS.
- **One folder per initiative** in your workspace, with worktrees inside it.
- **A global CLAUDE.md** with your checklist of how you like your code.
- **One docker container** with a logical DB per worktree. Apple Silicon is really powerful these days and you can do dozens of logical DBs in a single container with no memory or CPU issues.
- **Effort levels you actually switch.** Medium while shaping, ultracode or xmax for research and plan, high for review.

### My global CLAUDE.md

```text
1. Do not include comments unless there's a non obvious decision that cannot be
explained through method or variable names.
2. Work in small, atomic commits. Do not include commit descriptions unless
there's something important about WHY the change was made.
3. Run tests and linters on every commit.
4. Test E2E following project conventions after each commit.
5. Avoid ultra defensive code. When faced with a hyphotetical edge case, ask the
user about it rather than implementing a super special edge case handling code.
6. Use ENV vars for configurable parameters.
7. Do not push to remote branches unless told explicitly.
```

Do not waste a lot of time refining this. Harnesses and models evolve so quickly all your efforts will be wasted in less than six months. If you feel lazy, just ask Claude to review your past commits or merge review comments and extract some of this behavior.

{{% example chip="Real session · 11-08 · one container, a logical DB per worktree" %}}

> i boot it with docker pointing at a local container, on a logical db with a suffix of the worktree im on, so i always use the same container

Typed one handed on the phone, typos included. The rule underneath is what matters: same container always, and the DB name carries the worktree, so four sessions never fight over one schema.

{{% /example %}}

{{% /step %}}

{{% step num="01" title="Ramble, do not prompt" %}}

- Put on the AirPods and ramble for five to ten minutes. Walk around the room.
- Send the transcription with no editing at all. Typos and gibberish included.
- Read the questions Claude comes back with, ramble a few more minutes, sometimes stop and search for something on the Internet.
- Touch many topics in the same session: pricing, OAuth, LLM clients, tools surface, observability, auditability, how you should deploy it.

### The prompt

```prompt
Here's my ramble about XYZ, try organizing my thoughts and craft
a few questions to pull some threads: [Transcript]
```

{{% example chip="Real session · 04-08 · shaping the WhatsApp linking flow" %}}

> Oh, oh. And then all people like a seven. Right, let's think about the plan first at a technical level, from the point of view of the client. What I want you to do is create a folder called WhatsApp non oficial API in my workspace, and inside that folder we are going to start putting different worktrees where we will keep working on different features...

The first sentence is the STT losing its mind and I did not clean it up. Cleaning the transcript is wasted time: the model reads through it, and editing pulls you out of rambling mode.

{{% /example %}}

{{% done %}}
You have a list of good questions, not a list of answers.
{{% /done %}}

{{% /step %}}

{{% step num="02" title="Drop a savepoint" %}}

- Ask for a dump of everything you discussed in an MD file and a Claude HTML artifact.
- The MD is for Claude, to get it up to speed in follow-up conversations on the same topic.
- The artifact is for humans. Anything you have to review yourself should be an artifact too, not a wall of markdown in the terminal.

{{% example chip="Real session · 13-08 · dumping a research thread to disk" %}}

> For each thing you checked, build me a folder inside my vault structure and keep dumping it all in there: the references from the web artifact, a summary in notes, all the knowledge. All of this using subagents, so we do not occupy the main agent.

A savepoint is not a file, it is a shape you ask for while the context is still hot. The dumping goes to a subagent, so the thread that holds your mental model does not spend its tokens writing files.

{{% /example %}}

{{% example chip="Real session · 07-08" %}}

> ok how do we keep going? everything I have to review has to be an html artifact

Say it once per session and the rest of the thread respects it.

{{% /example %}}

{{% warn %}}
Never ship raw MD to your team. Remember: don't make me talk to your chatbot.
{{% /warn %}}

{{% /step %}}

{{% step num="03" title="Spin the worktrees" %}}

- One folder for the initiative, one worktree per track of work.
- Always a `research/` worktree that is just a clean copy of master. You read there, you never write there.
- Two or three sessions in parallel, each one in its own worktree, so you are not staring at a spinner.
- Cleaning up is also the agent's job.

{{< fig name="02-worktrees" caption="One folder, four worktrees, four sessions, one docker container with a logical DB per worktree." >}}

{{% example chip="Real session · 13-08 · a bug arrives while you are mid slice" %}}

> fix this ui error in a new worktree mr

Seven words and a screenshot. New idea, new worktree, and the MR is part of the ask, so the branch you were reading from stays untouched.

{{% /example %}}

{{% example chip="Real session · 14-08" %}}

> clean up the project worktrees that are not used and set me up an easier structure with symlinks

{{% /example %}}

{{% /step %}}

{{% step num="04" title="Research the existing shape of the system" %}}

- Open a new session, reference the ramble savepoint, and tell Claude to research the existing codebase: which pieces of functionality are there and which pieces aren't.
- Ask for the output as MD plus an HTML artifact with the pieces of the codebase you need to know.
- Demand evidence on every claim: `path:line`, a SHA or a URL. Verified versus inferred, marked, no exceptions.
- Ask explicitly for what it could **not** verify. That list is usually more useful than the findings.
- Big and branchy decisions get a brief, not a question.

### The research brief

```prompt
/goal  Decide how we deploy X in our infra.

## Questions        4 closed questions, numbered
## Context          the Slack thread, the links to review
## Read first       the previous doc, with its [V] / [I] marks
## Starting points  facts already confirmed, each with path:line or SHA
## Rules            HTML artifact, light and dark
                    one diagram per architecture
                    a comparison table with the same dimensions
                    mark verified vs inferred, no exceptions
                    an explicit recommendation and what to decide with N.
                    voice: my writing skill
```

{{% example chip="Real session · 07-08 · three infra options compared" %}}

> /goal Decide how we deploy unofficial WhatsApp in our infra. Compare three options: OpenWA, OpenClaw with multitenancy, and resurrecting our own Baileys gateway. Deliverable: an Artifact that answers the questions below, every claim with evidence (path:line, SHA or URL), having read the code of all three...

The Rules section is what makes the difference. Without it you get an essay. With it you get something comparable, with the uncertainty marked where it belongs. That research also recovered a deleted service from git history: an integration we had shipped, deleted a year later as dead code, and could resurrect instead of writing from scratch.

{{% /example %}}

{{% done %}}
You can describe the current state of the system in your own words, and you can see the transition between point A and point B. Nothing has changed yet.
{{% /done %}}

{{% /step %}}

{{% step num="05" title="Plan, then point at the wrong lines" %}}

- New session again, referencing the research and ramble savepoints. Ask for the high level overview of the components first.
- Then, in a single prompt, ask for an MD file and an HTML artifact explaining how each phase will be built: the code lines it will change, new dependencies, behaviors that might break, how clients consume this E2E, definitions of done, how you want the testing made, how you want your commits, and how you are going to be in the loop.
- Use ultracode or effort xmax here and let it spawn as many subagents as it wants.
- Read the artifact in rambling mode and go very direct, pointing at numbered items.
- Label every open decision (A1, D1, R7) so that later one line unblocks the whole implementation.
- Two or three passes. Think really deeply about the solution here.

### How I give plan feedback

```prompt
"At point 1.1: Always use handler base abstraction for new routes"
"At point 1.2: Mock as little as possible in your tests"
"At point 1.3: Don't introduce this new dependency and rather code the
 functionality by hand"
"At point 1.4: It feels weird having so many classes that share very similar
 behavior. Can you come up with 2 or 3 different ideas on how to design this
 layer of the code with new abstractions?"
```

{{% example chip="Real session · 12-08 · finding the gaps before writing code" %}}

> I want you to build a state machine with the flows at the center, representing every possible state of a phone line, both Meta official and WAPI. And in that artifact document every transition from one state to the other. Based on that machine stuff, find problems in the current logic where we are not respecting that state machine idea, and map them concretely to improvements.

Make the model draw your domain, then make it audit the code against the drawing. Every gap it finds is functional slop you did not have to debug later. "That machine stuff" is the STT mangling "state machine", and it still understood.

{{% /example %}}

{{% example chip="Real session · 06-08 · feedback on a plan, by surface" %}}

> Work these feedbacks in subagents: Frontend. Is the success screen aligned with the other success screens we already have? Same icons and layout? Any warning in the Chrome console we should pay attention to? Backend. Remove every Redis level lock, that does not make much sense. Let's simplify the job structure. I want this flow: 1. QR generation, resolved in a generic job that picks a provider behind the scenes. 2. QR scan, fires a notification event plus enqueues a job to create and configure the unofficial line. 3. Notification to the front that the line is configured.

Grouped by surface, one subagent per group. Notice the second half: instead of describing what is wrong, it describes the flow you want in three numbered steps. That is cheaper to act on than any critique.

{{% /example %}}

{{% /step %}}

{{% step num="06" title="Cut the pie in vertical slices" %}}

- Visualize the whole pie: the full feature with all the details.
- Map the scopes.
- Identify phases or slices of work you can ship by making increments at different scopes.

{{< fig name="03-slices" caption="Vertical, never horizontal. If the slice cannot go to production on its own, it is a phase of your plan, not a slice." >}}

{{% done %}}
Slice 1 has front end and back end in it, and you would be comfortable shipping it alone.
{{% /done %}}

{{% /step %}}

{{% step num="07" title="Implement slice 1" %}}

- Brand new session. One line: `/goal Implement slice 1 of docs/plan-XYZ.md`, plus the open decisions you already resolved.
- Give scope by artifact, never by adjective. "Everything described in this MR" is verifiable. "Improve the onboarding" is not.
- One subagent per file set. Each one owns its files, writes a `REPORT-X.md`, and declares what it broke for the others.
- Linter on each agent, full test suite once at the end over the integrated tree.
- No commits from the agents. You fold and amend at the end.
- Keep the parent thread clean. Anything that burns tokens without producing a decision goes down.
- Do not kill the subagents when they finish, so you can give them feedback.

{{< fig name="04-context" caption="The main thread holds your mental model, so it only gets short reports back. The expensive context burns below the line." >}}

### The implementation prompt

```prompt
Implement the changes described in the plan [artifact link]. For the open
questions follow path A1. Scope is everything described in this MR.
Use subagents to optimize the process, check every point of the plan and do
not stop until it is finished. To finish, run an end to end test of the whole
flow considering the other services too, until the QR shows up correctly on
the client screen, and film a video.
If you find an error that requires leaving the plan, do it, document it and
still get to the end to end part. Amend the existing commits of this merge
request rather than adding new ones. To run the linter and the tests, base
yourself on previous Claude Code sessions that already did it. Work in
subagents and keep the parent agent context as clean as possible.
```

That is the 12-08 prompt translated, near word for word. It is long because it front loads every decision the agent would otherwise come back to ask about.

{{% example chip="Real session · 07-08 · after the first round of reports" %}}

> ok resume each subagent with whatever is missing, in parallel

This is why you do not kill them when they report. Three agents worked in parallel on that MR, each owning a set of files. Every one came back with a numbered report, including the things it broke for the other two. Integration was reading three reports, not re-reading the diff.

{{% /example %}}

{{% /step %}}

{{% step num="08" title="Fight the slop" %}}

- Before opening the MR, open your IDE and read the diff as if a teammate had sent it.
- Spin up voice mode again and point at all the problems you see.
- Style slop is fixed with better CLAUDE.md or with prompting.
- Functional slop means your plan has a mental model gap, so it goes back up the loop.

{{< fig name="05-slop" caption="Two buckets, two different places to fix them. Mixing them up is why review feels endless." >}}

### The three prompts that do most of the work

```prompt
"scope down the changes to only what the app has, do not add anything new
 globally for example with etags, well handle those later, keep it as simple
 as possible"

"anything to simplify"

"spin up a subagent and fix as you go: do not include comments in the code,
 in none of the 3 projects"
```

{{% example chip="Real session · 14-08 · reviewing the front end diff" %}}

> mmm, list in a single table with /show-me the frontend changes, it looks complicated so lets simplify

When a diff feels complicated, do not read harder. Ask for the shape of it in one table, then cut.

{{% /example %}}

{{% /step %}}

{{% step num="09" title="Prove it end to end and film it" %}}

- Automate the whole E2E test. Tell Claude to record a video of himself testing the feature, whether it is CURL over an API or navigating a browser with Playwright.
- Boot every service involved, with the real credentials, not mocks. The agent prepares everything and you only show up for the step that needs a human.
- Put the evidence into an HTML artifact: the video, the log trace, the test results per commit, the scope ledger, the deviations from the plan, and the findings that fell out of scope.
- A blocker reported with its proposed fix is worth more than a silent workaround.

{{% example chip="Real session · 13-08 · linking a real phone" %}}

> you start the api-fr and everything, let me know when I can scan the QR

Three services up, one QR on screen, one real phone. Green tests are the floor, not the ceiling. The agent came back with two blockers it refused to work around: a token mismatch between two services and a route that did not exist on the checked out branch.

{{% /example %}}

{{% done %}}
You have taken a final look at the evidence yourself, and only then you open the MR.
{{% /done %}}

{{% /step %}}

{{% step num="10" title="Upload your mental model to the cloud" %}}

- Write the MR description by hand. Two or three paragraphs: the problem, the mental model around it, the solution you chose and its tradeoffs.
- Make sure your team invests 10 minutes in reading it. You can include an appendix with LLM-style documentation where all the low level details are referenced.
- Fold the commits into something readable before asking for review.
- For the parts that need pictures, ship a second artifact for the team: what the MR does, what was decided, in simple language.

{{% example chip="Real session · 14-08" %}}

> simplify the mr description and explain it clearly, fold all commits into a single commit with no body, rebase off master and then push to origin

Forty five minutes later, same thread: "you did not edit the description, simplify it a lot more". Shorter is almost always the right direction.

{{% /example %}}

{{% example chip="Real session · 13-08 · the explainer for the team" %}}

> explain to me in an artifact with visualizations, simple language and diagrams what the MR does and what decisions are taken, try to use my language

"Try to use my language" is doing real work there. The team should read you, not a model.

{{% /example %}}

{{% warn %}}
If you can't write a one-pager by hand, it means you probably need to reupdate your mental model.
{{% /warn %}}

{{% /step %}}

{{% step num="11" title="Keep the house tidy" %}}

After you ship, connect your agentic harness to your observability tools and let it do the triage. A scheduled task once a day, proactively finding exceptions, bugs, slow queries or user complaints.

| Where it starts | What I type | What comes back |
|---|---|---|
| Sentry | the issue URL, nothing else, plus "why could this error happen?" | root cause traced in the codebase, with a fix plan |
| Slack alerts | "in the slack channel alerts_api_fr find those related to langfuse, create a mr to notify those over alerts_ai like its done in one of the latest commits by jpasquale in another flow" | the MR, open, copying a pattern that already shipped |
| The board | "find all issues that belong to me or to my team and think of a MR to set the timeouts, or decide if we should disregard the issue since we do not need timeouts in that project" | a per-service decision, and the MRs for the ones worth doing |
| OpenSearch | "research this in sandbox, check opensearch, find an hypothesis on why the pods died (do not answer or reply in the thread)" | a hypothesis you can test in sandbox with the browser |

{{% /step %}}

{{% step num="12" title="Ship the next slice" %}}

Now you have a loop. If you invested the time upfront, the next slices, feedback and iteration changes go very quickly, maybe tons of them a day coded with Claude between meetings.

{{% card title="The card, if you only keep one thing" %}}

1. Ramble by voice. Craft questions, not answers.
2. Savepoint everything: MD for Claude, artifact for humans.
3. New idea, new worktree.
4. Research before proposing. Evidence with path:line, and mark what is inferred.
5. Plan in an artifact. Point at numbered items. Label the open decisions.
6. Cut vertical slices. If it cannot ship alone it is not a slice.
7. Implement with subagents, keep the parent thread clean.
8. Read the diff yourself. Then ask: anything to simplify?
9. E2E with a human in the loop, and film it.
10. Write the MR description by hand.
11. Point the harness at your observability and let it triage daily.

{{% /card %}}

{{% /step %}}
