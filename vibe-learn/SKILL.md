---
name: vibe-learn
description: Generate a layered learning report after completing code changes, so the user learns from every update they vibe code. Explains each change at four depths (plain English → concepts → the actual code → engineering judgment) and maintains a cumulative concept ledger so explanations compress as the user levels up. Use this skill EVERY TIME you finish writing, editing, or fixing code in a project where a learning/ directory exists or the user has asked to learn as they build. Also use when the user says things like "explain what you just did", "learning report", "what did that change do", "teach me what we built", "/learn", or asks to understand their codebase changes. Also use in QUIZ MODE when the user says "quiz me", "/quiz", or "test what I've learned", and in DEEPER MODE when they ask to go deeper on a past report ("walk me through report 007", "explain report 3's code interactively"). Also use in BASELINE MODE when the user wants retroactive reports on an existing codebase — triggers like "vibe-learn baseline", "catch me up on this codebase", "run this on my existing project", or "backlog reports".
---

# Vibe Learn

Turn every code change into a learning opportunity. After completing changes, generate a short layered report that explains what happened at multiple depths — so someone who "knows nothing about coding" today can read Level 0, and read Level 3 six months from now — while a cumulative concept ledger tracks their growth and compresses what they already know.

**Philosophy: build first, understand after.** Never slow down or block the actual coding work. The report comes after the change works. The user keeps shipping at full speed; learning rides along.

## When to run

- **Default cadence: one digest per working session.** As you make meaningful changes, capture them to the inbox (see "During the session" below); when the session settles — the user stops firing requests, says they're done, or asks for the report — compile ONE digest covering the session. A lone meaningful change can get its report immediately.
- Only run automatically IF the project contains a `learning/` directory OR the user has previously asked to learn as they build.
- On explicit request: "explain what you just did", "learning report", "/learn".
- NOT for trivial changes: fixing a typo, renaming a variable, formatting, bumping a version number. Skip those silently — a report on nothing teaches nothing and trains the user to ignore reports.

## During the session: capture to the inbox

Report quality dies when it depends on remembering a 3-hour session at the end. So capture as you go: **immediately after completing each meaningful change, append one line to `learning/inbox.md`:**

```
- [YYYY-MM-DD HH:MM] added debounce to search input (src/Search.tsx) — teachable: debouncing, stale responses | user asked: "search feels laggy"
```

One line per change: what happened, key file(s), candidate teachable concepts, and the user's words that triggered it (you'll need those for the "Your words → this code" section). This costs seconds and makes the digest a compilation job instead of a memory test. At digest time, the inbox is your source of truth; clear it after the report is written. If the inbox has leftover entries from a previous session that never got a report, fold them into this digest — that's the safety net working.

## First run in a project (setup)

If `learning/` does not exist and the user wants learning reports:

1. Create the structure:
   ```
   learning/
   ├── reports/          # one markdown file per report
   ├── path.md           # the project's single evolving learning path (see references/learning-path.md)
   ├── concepts.md       # cumulative concept ledger (see references/ledger-format.md)
   ├── profile.md        # learner level + preferences (see references/ledger-format.md)
   ├── inbox.md          # session capture log, compiled into each digest then cleared
   └── README.md         # auto-maintained progress dashboard (see references/ledger-format.md)
   ```
2. Ask the user three quick calibration questions (or infer from conversation): roughly how much coding do they understand today; do they want reports on everything or only on request; and how should reports be delivered — auto-opened in the browser (default), PDF in the folder, or emailed (see references/delivery.md). Record the delivery choice in profile.md.
3. **Seed the learning path.** Create `learning/path.md` and write its **Plan** section — the project's intended shape and the thinking behind it (see references/learning-path.md). If a plan already exists (plan mode output, a PRD, a README roadmap, or the goal the user just described), ingest it and surface the *why* behind the shape. If not, ask two or three quick questions about what they're building, then draft the Plan and show it. This is the "explain its thinking" starting point the whole path grows from — do it once, before the first code milestone. On a **baseline** run into an existing codebase, seed the Plan from the survey (Baseline mode step 2) instead, marking it "reconstructed from the code as it stands."
4. Add this line to the project's `CLAUDE.md` (create it if needed) so future sessions trigger reliably:
   ```
   After completing any meaningful code change, use the vibe-learn skill to generate a learning report in learning/reports/.
   ```
5. Tell the user about `references/automation.md` if they want fully deterministic triggering via hooks.

## Generating a report

### Step 1: Ground yourself in the real change

Read `learning/inbox.md` first — it's the session's capture log and the digest's table of contents. Then run `git diff HEAD` (or `git diff` + `git diff --cached`, or review the edits you just made this session if git isn't in use) to get the actual code. Every code snippet in the report must be an **exact copy from the real files** — never simplified, never paraphrased. The user should be able to open the file and see the same code. This is non-negotiable: paraphrased code teaches a codebase that doesn't exist.

### Step 2: Read the ledger

Read `learning/concepts.md` and `learning/profile.md` if they exist. You need to know:
- Which concepts are **known** (seen 3+ times or user-confirmed) → do NOT re-explain; reference by name only.
- Which are **developing** (seen 1–2 times) → brief callback ("state again — same idea as report 004, the whiteboard that redraws").
- Which are **new** → full explanation at every level. Check the `builds on` column: if a new concept's prerequisite is itself still unlearned, teach the prerequisite first or flag it — never silently assume it.
- Any **recorded misconceptions** touching today's concepts → correct them explicitly in this report (see references/ledger-format.md). Repairing a wrong mental model teaches more than introducing a new one.

Also read the **global ledger** at `~/.claude/vibe-learn/concepts.md` if it exists. A concept known there but new to this project gets a brief callback ("known from your other projects — same idea here"), not a full re-explanation, and enters the local ledger at `developing`. The local ledger stays authoritative for this project; the global one only prevents re-teaching `useState` from scratch in every new project.

This is the mechanism that makes reports shrink and deepen over time. Skipping this step produces the #1 failure mode: re-explaining variables for the 15th time to someone who's past it, which makes the reports feel like spam.

### Step 3: Choose what's worth teaching

Do not cover the whole diff. Pick the **top 1–3 things worth learning** from this change. A 40-file migration has maybe two teachable ideas in it. Selection criteria, in priority order:
1. New concepts the user hasn't seen (check ledger)
2. Concepts at "developing" status that this change reinforces
3. A design decision with a real tradeoff (Level 3 material)

Ignore: import shuffling, boilerplate, lockfile changes, anything the user already has at "known" status unless something interesting happened with it.

### Step 4: Write the report

Save to `learning/reports/NNN-short-slug.md` (zero-padded sequence: `001-`, `002-`...). Follow the exact template in `references/report-template.md` — read it before writing your first report in a session. The four layers, briefly:

- **🌱 Level 0 — What just happened** (plain English, ZERO jargon): what the app does now that it didn't before, in terms of what a user of the app would notice. 3–6 sentences. One metaphor max. Test: would a smart person who has never seen code understand every single word? If any programming term appears here, you've failed the level.
- **🧩 Level 1 — The ideas involved**: name the 1–3 concepts (max 3 new ones per report — cognitive load is real), each as: concept name → one-line plain definition → a metaphor fitted to THIS concept (not recycled) → where it shows up in this change. Count honestly: any concept you materially explain anywhere in the report (including at Level 2) counts as introduced — it goes in the header count, gets its Level 1 entry, and enters the ledger. Sneaking a fourth concept in via a code annotation is how reports bloat.
- **🔍 Level 2 — The actual code**: walk the key parts of the real diff in **execution order** (the order things happen when the app runs), not file order. Exact snippets, ≤ 20 lines each, with a one-line annotation per interesting line. Include file paths so the user can open them.
- **🏗️ Level 3 — Why this way**: the engineering judgment. Why this approach over the obvious alternative, what tradeoff was made, what could break, what a senior developer would double-check. This is where the user grows from "understands code" to "thinks like an engineer."
- **🔗 Your words → this code**: quote or paraphrase what the user actually asked for (the inbox captured it), and trace how their plain-English request became these specific technical decisions. End with one **"Try this next time"** line: the concrete prompt the user *could have written* to specify the biggest unstated decision themselves. This closes the loop between prompting and outcome — it's how vibe coders learn to prompt better.
- **❓ One question**: a single application-style quiz question about a *scenario* ("the page shows stale data after login — which of today's three files would you check first, and why?"), never definition recall ("what does API stand for?"). Put the answer in a `<details>` collapsible block.

Total report length: **150–400 lines of markdown for early reports, shrinking toward 50–150 as the ledger fills with known concepts.** If your report exceeds this, you selected too much in Step 3.

### Step 5: Update the path, ledger, dashboard, and inbox

Update `learning/path.md` (see references/learning-path.md): **append one milestone node** to *The Path so far* — project-level only (what the app can now do, whether it was `on-plan`/`detour`/`new territory`, what it unlocked, and a link to this report) — and **rewrite the horizon** with 2–3 plausible next evolutions given the new state. If the change was a structural pivot away from the Plan, add a dated revision line rather than silently editing the Plan. This is the thread that lets the user follow the project's whole evolution; it costs a few lines per report.

In `learning/concepts.md`: add new concepts (with their `builds on` prerequisites), increment counts on repeated ones, promote to "known" at 3 sightings, and record or clear misconceptions. In `learning/profile.md`: update level estimates if you saw evidence (user asked a Level 3 question → they're growing; user was confused by a Level 1 concept → recalibrate). Regenerate `learning/README.md` — the dashboard (see references/ledger-format.md for the format). Propagate to the global ledger (`~/.claude/vibe-learn/concepts.md`, create it on first promotion): concepts promoted to `known` here become known globally; demotions stay local. Finally, clear `learning/inbox.md` — its entries are now covered by this report.

### Step 6: Deliver and close the loop

After saving the .md, deliver per the `Report delivery` preference in profile.md — auto-opened HTML, PDF in `learning/reports/`, or email; exact recipes and fallback order in references/delivery.md. A terminal user should never have to go find the file: the seamless moment is the report appearing (browser tab, PDF, inbox) right as the session's work lands. Delivery failures never block anything — fall back a tier and say so.

Refresh `learning/.last-report-state` if the project uses the Stop hook (see references/automation.md). Then tell the user in ONE short line: report number, the headline concept, and how it was delivered. Do not paste the report into chat — that defeats the layered-reading design. Example: "📚 Learning report 007 saved (`learning/reports/007-auth-middleware.md`) — headline concept: middleware. Concepts now known: 12."

Every 5th report, add: offer a 3-question review quiz drawn from concepts at "developing" status. Keep it optional and light.

## Quiz mode (spaced review)

Trigger: "quiz me", "/quiz", "test what I've learned" — or the standing offer every 5th report.

1. Read the ledger. Select 3 concepts, prioritized by: (a) `developing` status, (b) oldest `last report` (most overdue), (c) any concept with a recorded misconception.
2. Ask **one scenario question at a time**, in chat, same application-style rules as report quizzes — never definition recall. Wait for the answer before the next question.
3. After each answer: confirm or gently correct with the one-line reasoning path. A correct answer counts as a sighting (may promote to `known`); a revealing miss records a misconception and may demote.
4. Update the ledger and dashboard. Never show scores or streaks — end with what got promoted, framed as growth ("`middleware` is now known — it won't be re-explained again").

## Deeper mode (interactive walkthrough of a past report)

Trigger: "walk me through report 007", "go deeper on the auth report", "explain report 3's code to me".

1. Open the report AND the real files it references (they may have drifted since — say so if they have).
2. Teach interactively at one level deeper than the user's current domain level, in chat, checking understanding as you go rather than monologuing.
3. This is a conversation, not a document — don't write a new report. Sightings and misconceptions observed here update the ledger like any other evidence.

## Graduation (the exit ramp)

When a domain reaches level 2.5+, reading reports is no longer the fastest way to learn — doing is. At the next relevant change in that domain, offer once:

> "You're at level 2.5 on react/frontend. Want to try writing this next small change yourself? I'll review it like a senior dev — that's the fastest path from here."

If they accept: let them write it, review with the same warmth as the reports (what works, one thing to reconsider, why). The review replaces that change's report. If they decline, don't re-offer for at least 5 reports — note the offer date in `profile.md`. Graduation is per-domain: someone writing their own React can still be reading Level 0 database reports.

## Baseline mode (existing projects / backlog)

Per-change reports need a change. For a codebase that existed before vibe-learn was installed, generate a retroactive foundation instead of starting with an empty ledger. Trigger: "vibe-learn baseline", "catch me up on this codebase", or installing into a project with substantial existing code.

1. **Set up** the `learning/` structure and run the calibration questions as in first-run setup.
2. **Survey** the codebase: directory tree, config/manifest files (`package.json`, etc.), entry points, README, and the main data flow. Identify the major subsystems (typically 3–6: e.g., UI, data storage, auth, external APIs, background jobs).
3. **Write report 000 — "The 10,000-foot tour"**: what the app is, the big pieces, and how one real user interaction flows through all of them from click to result. This report is the map every later report hangs on.
4. **Write one report per subsystem**, in dependency order (data layer before the features that use it), numbered 001 onward. **Hard cap: 6 baseline reports total.** Baseline is a foundation, not complete coverage — a codebase with 30 concepts still gets max 3 new concepts per report; everything else gets taught naturally by future per-change reports. Resist the urge to be exhaustive: an unread 15-report baseline teaches less than a read 4-report one.
5. **Template adaptations for baseline reports** (everything else identical): Level 0 heading becomes "What this piece does"; the "Your words → this code" section becomes **"🔗 Decisions already baked in"** — surface the 2–3 biggest unstated architectural decisions embedded in this subsystem (chosen framework, storage approach, where secrets live), because the user likely never consciously made them.
6. **Seed the ledger** with every concept materially explained, and write `profile.md` from the calibration answers.
7. **Seed the path** (`learning/path.md`): write the Plan section as the architecture *reconstructed from the code as it stands* (see references/learning-path.md), and add report 000's tour as the first milestone node. From here the path grows normally.
8. Per-change mode then continues numbering where baseline stopped.

For large codebases, offer to do baseline one subsystem per session rather than all at once — six deep reports in one shot burns context and produces a worse tour.

## Calibration and drift

- The user's level is per-domain, not global. Someone can be Level 2 on React components and Level 0 on databases. `profile.md` tracks domains separately.
- If the user answers the report quiz correctly or asks questions that reference Level 2/3 material, that's evidence to compress harder next time.
- If the user says a report was confusing, find the concept that broke and demote it in the ledger — then re-explain it fresh in the next relevant report.
- Never make the user feel tested or graded. The quiz is a curiosity hook, not an exam. No scores, no streaks-guilt, no "you should know this by now."

## Failure modes to avoid

1. **Exhaustive coverage.** The report nobody reads teaches nothing. Ruthless selection beats completeness.
2. **Jargon leaking into Level 0.** "We added an endpoint" is a Level 1 sentence. Level 0 is "the app can now save your notes so they're still there tomorrow."
3. **Paraphrased or simplified code at Level 2.** Exact snippets only.
4. **Recycled metaphors.** "It's like a recipe" for everything teaches nothing. Fit the metaphor to the concept: a database index is a book's index; middleware is airport security every passenger passes through; a race condition is two people editing the same whiteboard.
5. **Re-explaining known concepts.** Read the ledger. Respect the user's growth.
6. **Blocking the build.** If the user is mid-flow and firing rapid requests, hold the report until the session settles, then write one session report.
7. **Digest from memory.** Writing the end-of-session digest by recalling the session instead of reading `learning/inbox.md`. Long sessions lose their middle that way — capture as you go, compile at the end.

## References

- `references/learning-path.md` — the single per-project `path.md`: the Plan (seeded at setup), the milestone thread, and the horizon. Read when setting up a project or updating the path after a report.
- `references/report-template.md` — exact report format with a full worked example. Read before writing the first report of a session.
- `references/ledger-format.md` — format for `concepts.md` and `profile.md`, including status rules and domain levels.
- `references/automation.md` — CLAUDE.md snippet and optional Claude Code hook config for deterministic (non-probabilistic) triggering. Point the user here if they ask why a report didn't auto-generate.
- `references/delivery.md` — how reports reach the user: auto-opened HTML (zero deps), PDF in the folder, or email. Read when setting up delivery or when the user asks to change how reports arrive.
