# Goals — the acceptance checklist

The mission: **a user vibe codes at full speed, and seamlessly gets a layered digest that takes them from basic to expert understanding of what they built.**

That mission decomposes into exactly five stages. Every feature, fix, or PR to this skill must name which stage it strengthens — and a change that strengthens no stage doesn't belong.

## The five stages

| # | Stage | Pass criterion |
|---|-------|----------------|
| 1 | **Capture** | Every meaningful change gets recorded — deterministically, even in a 3-hour session with 40 edits. Not "Claude probably remembers." |
| 2 | **Selection** | Each digest teaches ≤ 3 things, chosen against the ledger. Ruthless selection beats diff coverage. |
| 3 | **Explanation** | A zero-coder passes Level 0 without hitting a single jargon word; a senior dev finds Level 3 non-trivial. All four layers, exact code only. |
| 4 | **Retention** | A concept seen 3 weeks ago resurfaces for review. Reading ≠ learning; the system must close the loop with quizzes and misconception repair. |
| 5 | **Progression** | The system behaves *differently* as the user levels up — reports compress, depth shifts to Level 3, and eventually the user is invited to write code themselves. And the user can *see* their progress. |

## Scorecard (updated 2026-07-17)

| Stage | Status | What delivers it |
|-------|--------|------------------|
| 1 Capture | ✅ | Session inbox (`learning/inbox.md`) + PostToolUse breadcrumb hook + marker-based Stop hook |
| 2 Selection | ✅ | Step "Choose what's worth teaching" + max-3-concepts rule + honest counting |
| 3 Explanation | ✅ | Four-layer template, exact-snippet rule, fitted-metaphor rule, ledger compression |
| 4 Retention | ✅ | `/quiz` review mode, misconception tracking in ledger, demote-and-re-explain rule |
| 5 Progression | ✅ | Per-domain levels, dashboard (`learning/README.md`), graduation mechanic at level 2.5+ |
| 6 Continuity | ✅ | Learning path (`learning/path.md`): Plan seeded at setup, milestone thread, rewritten horizon |

## The sixth stage: Continuity

The first five stages make each *change* legible. Stage 6 makes the *whole project* legible as one evolving story — the piece that lets a user understand not just "what did this change do" but "what am I building, how did it get this shape, and where can it go." One learning path per project, seeded by the Plan (the thinking, up front) and grown one milestone per report with a living horizon of what's next.

| # | Stage | Pass criterion |
|---|-------|----------------|
| 6 | **Continuity** | A user reads `path.md` top-to-bottom after a month away and understands the project's intended shape, how the code actually evolved (on-plan vs. detours), and the plausible next moves. Reports are the deep-dives; the path is the thread joining them. |

## Definition of "seamless"

Seamless means the user never has to remember the skill exists:

- Capture happens as a side effect of building (inbox + hooks), not from Claude's memory at the end.
- The digest arrives after the session settles — never blocking the build (Design principle #1).
- One line in chat announces the report; the user reads at their chosen depth on their own time.
- Progress is visible without asking (dashboard), and review arrives on its own cadence (every-5th-report quiz offer).

## Definition of "basic to expert"

The path is: **read Level 0 → read deeper levels → answer scenario quizzes → prompt better (Your words → this code) → graduate to writing code with review.** A user who only ever reads reports has plateaued — stage 5 exists to prevent that.
