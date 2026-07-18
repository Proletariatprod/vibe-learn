# vibe-learn

**Learn while you vibe code.** A Claude Code skill that turns every code change into a short, layered learning report — so you actually understand what you're building, at whatever depth you're ready for today, with reports that compress as you level up.

## The problem

Vibe coding lets you build faster than you learn. Six months in, you've shipped real things you can't explain, can't debug confidently, and can't extend without the AI. Existing fixes either slow you down (mentor-mode skills that refuse to write code) or arrive too late (one-shot codebase-to-course generators after the project is done).

vibe-learn takes a third path: **build first, understand after — automatically, incrementally, forever.** You keep shipping at full speed. After each meaningful change, a report lands in `learning/reports/` explaining what just happened at four depths:

| Layer | For the you who... |
|---|---|
| 🌱 **Level 0 — What just happened** | knows nothing about code. Zero jargon, one metaphor. |
| 🧩 **Level 1 — The ideas involved** | wants the concepts named (max 3 new per report). |
| 🔍 **Level 2 — The actual code** | can read code. Exact snippets from your real files, walked in execution order. |
| 🏗️ **Level 3 — Why this way** | wants engineering judgment: tradeoffs, alternatives, what could break. |

Plus two sections no other tool has:

- **🔗 Your words → this code** — traces your plain-English prompt to the technical decisions the AI made *that you never specified*. Seeing those invisible decisions is how vibe coders learn to prompt better.
- **❓ One question** — a scenario-based quiz about today's change (never definition trivia), answer hidden in a collapsible.

## The part that makes it compound

A **concept ledger** (`learning/concepts.md`) tracks every concept across reports: `new` → `developing` (2 sightings) → `known` (3+). Known concepts stop being explained. Your reports start at ~300 lines and shrink toward ~100 as your known pile grows — and the depth budget shifts from Level 0 toward Level 3. A `profile.md` tracks your level **per domain** (you can be Level 2 on React and Level 0 on databases; the reports adapt to each).

## The rest of the learning loop

Reading isn't learning, so the digest is only stage one:

- **Session inbox** (`learning/inbox.md`) — changes are captured as they happen, so the end-of-session digest is compiled, never recalled from memory. Long sessions stop losing their middle.
- **"Quiz me"** — spaced review pulling 3 scenario questions from your most-overdue developing concepts. Correct answers promote concepts; misses get recorded and repaired in the next report.
- **Misconception tracking** — say something that reveals a wrong mental model and the ledger remembers; the next relevant report corrects it head-on.
- **"Walk me through report N"** — any past report becomes an interactive session, taught one level above where you are.
- **Dashboard** (`learning/README.md`) — an auto-updated one-pager: known/developing counts, per-domain level bars with evidence, what's up for review.
- **Graduation** — hit level 2.5 in a domain and the skill flips the script: you write the next small change, it reviews like a senior dev. The exit ramp from reading to doing.
- **Global ledger** (`~/.claude/vibe-learn/concepts.md`) — what you learn travels with you. A concept mastered in project one gets a one-line callback in project five, not the full lecture.

The full acceptance criteria behind these live in [`GOALS.md`](GOALS.md) — five stages (capture → selection → explanation → retention → progression) that every future change must strengthen.

See [`examples/sample-report.md`](examples/sample-report.md) for a full report — note how `useState` (known) gets zero explanation while `debouncing` (new) gets the full treatment.

## Install

**Easiest — let Claude do it.** In any Claude Code session:

> Install the vibe-learn skill from https://github.com/YOUR_USERNAME/vibe-learn — copy the `vibe-learn` folder into `~/.claude/skills/`.

**Or with the script:**

```bash
git clone https://github.com/YOUR_USERNAME/vibe-learn.git
cd vibe-learn && bash install.sh
```

**Or manually:** copy the `vibe-learn/` folder into `~/.claude/skills/`.

Installing to `~/.claude/skills/` makes it a *personal* skill — available in every project on your machine automatically.

## Use

### New or ongoing project
In the project, just say:

> Set up vibe-learn in this project.

Claude creates the `learning/` structure, asks two calibration questions, and adds a trigger line to the project's `CLAUDE.md`. From then on, meaningful changes produce reports automatically. You can always force one with **"/learn"** or **"explain what you just did."**

### Existing project (backlog / baseline mode)
For code that existed before vibe-learn:

> Run vibe-learn baseline on this project.

Claude surveys the codebase and writes a foundation series (max 6 reports): report 000 is the 10,000-foot tour of how your app fits together, then one report per major subsystem, each ending with **"Decisions already baked in"** — the architectural choices you never consciously made. The ledger gets seeded, and normal per-change mode picks up from there.

### Make it fire every time (optional)
Skill triggering is probabilistic. For deterministic triggering, see [`vibe-learn/references/automation.md`](vibe-learn/references/automation.md) — includes a Stop hook config that reminds Claude whenever code changed and no report was written.

## What a report looks like

```
# Report 006 — Search that waits for you to stop typing

🌱 Level 0 — What just happened
   (plain English: the waiter who waits until you finish ordering)
🧩 Level 1 — The ideas involved
   Debouncing `new` · API route `developing — see report 004`
🔍 Level 2 — The actual code
   (exact snippets, execution order, annotated)
🏗️ Level 3 — Why this way
   (debounce vs throttle, the 300ms tradeoff, the stale-response hole)
🔗 Your words → this code
   ("laggy search" became 3 decisions you didn't specify — here's each one)
❓ One question
   (scenario quiz, answer collapsed)
```

## Design principles

1. **Never block the build.** Reports come after the change works.
2. **Ruthless selection.** Top 1–3 teachable things per change, not diff coverage. The report nobody reads teaches nothing.
3. **Exact code only.** Snippets are copied from your real files, never simplified — you can open the file and see the same code.
4. **Fitted metaphors.** Middleware is airport security; a session is a festival wristband. Never "it's like a recipe" for everything.
5. **Respect growth.** The ledger is read before every report. Re-explaining `useState` for the 15th time is the failure mode this project exists to kill.

## Credits & prior art

- [codebase-to-course](https://github.com/zarazhangrui/codebase-to-course) by Zara Zhang — the application-quiz style and fitted-metaphor discipline come from here; vibe-learn trades its one-shot whole-codebase course for incremental, cumulative reports.
- Anthropic's [skill docs](https://code.claude.com/docs/en/skills) — the grounding-in-real-diff pattern.

## License

MIT
