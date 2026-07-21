# The learning path: one evolving story per project

Reports are episodes. The **learning path** (`learning/path.md`) is the season arc — a single document, one per project, that a user reads top-to-bottom to understand *how this project's code came to be and where it could go next*. Where a report answers "what did this one change teach me?", the path answers "what is the shape of the whole thing, how did it get here, and what's the next move?"

It has exactly three sections, and it grows in a fixed rhythm: **the Plan is written once at setup, a milestone node is appended after every report, and the horizon is rewritten on every update.**

## The shape of `learning/path.md`

```markdown
# Learning Path — <project name>

*<One line: what this project is.> · Started <YYYY-MM-DD>*

---

## 🗺️ The Plan — the thinking before the code

*Written at setup. Revised openly (never silently), because a pivot is a lesson.*

- **The one idea:** <what this project is really for, in a sentence a non-coder gets>
- **The intended shape:** the <3–5> big pieces and *why this arrangement* — e.g. "a UI that never talks to the database directly; everything goes through one API layer, so the rules live in one place."
- **The load-bearing decisions:** the up-front calls and their reasoning — stack, storage, the one pattern the whole thing leans on. For each: the decision, the one-line why, and what it would cost to reverse later.
- **Deliberately deferred:** what we're NOT building yet, and the signal that will say "now."

## 🧭 The Path so far — how the code actually evolved

*One node per report, oldest first. This is the narrative — read it straight through and the project's growth reads like a story.*

### <Plain-English milestone title> · report <NNN> · <YYYY-MM-DD>
- **Now possible:** <what the project can do now that it couldn't, at the project level — not code detail; the report holds that>
- **vs. the plan:** `on-plan` — the API layer we planned now has its first real route. *(or)* `detour — <why>` *(or)* `new territory — the plan didn't foresee this`
- **Unlocked:** <what this makes buildable next>
- **→ Full report:** [reports/<NNN>-<slug>.md](reports/<NNN>-<slug>.md)

## 🌅 The horizon — where the code could go next

*Rewritten every update. The 2–3 most plausible next evolutions given where the code actually is today — this is what lets the user see the road ahead, not just the road behind.*

- **<Direction>:** <one line on what it would take> — <why you might want it, and what in the code today points here>
- **<Direction>:** …
```

## Seeding the Plan at setup

The Plan is the "explain its thinking" part — write it once, when `learning/` is first created, before any code milestone exists. Two paths:

1. **A plan already exists** (the user ran plan mode, wrote a PRD, has a roadmap in the README, or just described the goal in chat): ingest it. Translate the technical plan into the four-part Plan section above — especially the *why* behind the shape, which technical plans usually leave implicit. That implicit reasoning is exactly what a vibe coder needs surfaced.
2. **No plan exists** (user is starting from a one-line idea): interview briefly — two or three questions, no more. "In one sentence, what's this for?" · "What are the big pieces you imagine?" · "Anything you already know you want to use or avoid?" Then draft the Plan and show it, so the user starts the project already seeing its intended architecture in plain English.

Keep the Plan honest about uncertainty: an early plan is a hypothesis. Say so. "Best guess at the shape — expect the Path below to show where reality pushed back."

## Updating the path (folds into report Step 5)

Every time a report is written, do two cheap edits to `path.md`:

- **Append one milestone node** to *The Path so far*. Project-level only — what the app can now do, how it relates to the plan, what it unlocked, and a link to the full report for the code detail. A few lines. Never restate the report.
- **Rewrite the horizon.** Replace the old *Where the code could go next* with 2–3 fresh directions based on the new state. This is the section that answers the user's request to "understand how the code can evolve" — it's a living forecast, not history.

Tagging each milestone `on-plan` / `detour` / `new territory` is the spine of the learning: over ten reports the user *sees* how a real project drifts from its plan, which is one of the most valuable things a new builder can internalize.

## Revising the Plan (the pivot moment)

When the code diverges from the Plan structurally — not a tweak, a genuine change of shape — do NOT quietly edit the Plan to match. Add a dated revision line inside the Plan section:

```markdown
> **Plan revised 2026-08-02:** dropped the separate API layer — the app is small enough that
> components talk to the database directly through one shared client. Simpler now; the cost is
> that the data rules are spread across components instead of centralized. (See report 014.)
```

The struck-through original stays visible. A vibe coder learning to build needs to see that plans change *and why* — hiding the pivot hides the lesson.

## Delivery and discovery

- The path lives at `learning/path.md` and is the natural "front door" to the whole `learning/` folder. Link it from the top of the dashboard (`learning/README.md`): *"📖 Read the full story of this project: [the learning path](path.md)."*
- It renders with the same HTML/PDF delivery as reports (see references/delivery.md) if the user wants it opened — but its main job is to be the one file worth reading end-to-end after a month away.
- One path per project, always. Never split it; never start a second. Its value is that it's the single continuous thread.
