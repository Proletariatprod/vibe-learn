# Ledger Format

Two files make the skill cumulative. Keep both machine-scannable (you read them at the start of every report) and human-readable (the user will browse them — `concepts.md` doubles as their personal glossary).

## learning/concepts.md

One table, sorted by status (new → developing → known), then alphabetically.

```markdown
# Concept Ledger

Statuses: `new` (seen once) → `developing` (seen 2x) → `known` (seen 3+ or user-confirmed).
Known concepts are referenced by name in reports, never re-explained.

| Concept | Domain | Status | Seen | First report | Last report | Builds on | One-line definition |
|---|---|---|---|---|---|---|---|
| middleware | backend | developing | 2 | 003 | 007 | request/response | Code that runs between request and response, every time |
| session | auth | known | 4 | 003 | 011 | cookies | Proof you already logged in (the festival wristband) |
| useState | react | known | 6 | 001 | 010 | — | A component's memory that survives re-renders |
```

Below the table, a misconceptions section (omit when empty):

```markdown
## Misconceptions to repair

| Concept | Wrong model | Heard in | Corrected in |
|---|---|---|---|
| middleware | thinks it runs in the browser | chat, 2026-07-15 | (pending) |
```

Rules:
- Promote at 3 sightings, OR immediately if the user demonstrates it (uses the term correctly, answers a quiz on it, explains it back).
- Demote known → developing if the user expresses confusion about it. Then re-explain fresh in the next relevant report — treat the demotion as new information about the user, not a failure.
- Keep definitions to one line; the reports hold the full explanations. Include the metaphor's anchor word in parentheses when it helps recall.
- A "sighting" = the concept was materially involved in a report, not merely present in the diff. Correct quiz answers count as sightings.
- `Builds on` lists prerequisites by concept name. Before teaching a new concept, check its prerequisites are at least `developing`; if not, teach the prerequisite first or flag the gap. `—` means foundational.
- **Misconceptions:** when the user says something revealing a wrong mental model, add a row immediately (even mid-session). The next report or quiz touching that concept must correct it explicitly — then fill in "Corrected in" and delete the row once the user demonstrates the fixed model.

## learning/profile.md

```markdown
# Learner Profile

## Levels by domain
Scale: 0 = plain English only · 1 = knows the concepts · 2 = reads code · 3 = follows engineering tradeoffs

| Domain | Level | Evidence (last updated) |
|---|---|---|
| react/frontend | 1.5 | Answered report 010 quiz correctly; asked about props unprompted (2026-07-10) |
| databases | 0.5 | Confused by "migration" in report 008 — re-explained in 009 (2026-07-08) |
| auth | 1 | — |

## Preferences
- Report cadence: [every change / session summaries / on request]
- Report delivery: [markdown / html (auto-open) / pdf / email name@example.com via Mail.app] — see references/delivery.md
- Depth priority: [e.g. "wants Level 3 emphasis on security topics"]
- Quiz appetite: [loves them / tolerates them / skip]

## Report index
| # | Title | Headline concepts |
|---|---|---|
| 001 | The contact form remembers what you typed | useState, controlled input |
| 002 | ... | ... |
```

Additional `profile.md` fields:
- Under Preferences, track graduation state per domain: `Graduation: offered 2026-07-15 (declined) — don't re-offer before report 018`.

Rules:
- Levels move in 0.5 steps, on evidence only — never on vibes or elapsed time. Cite the evidence in the table.
- Domain levels shape which layers get the most care: a Level 0 domain gets a rich Level 0–1 and a brief Level 3; a Level 2.5 domain gets one-line Levels 0–1 and a deep Level 3. All levels always appear (the user may share reports, or regress after a break) — what changes is the weight.
- The report index is the user's table of contents for their entire learning history. Keep it current; it costs one line per report.

## ~/.claude/vibe-learn/concepts.md (global ledger, cross-project)

The user's knowledge travels with them; project ledgers don't. The global ledger stores **floors, not truth** — the project ledger stays authoritative, the global one only prevents re-teaching `useState` from scratch in project number five.

```markdown
# Global Concept Ledger
Concepts known across all vibe-learn projects. Floors only — projects hold the detail.

| Concept | Domain | Status | Seen | Projects | Last seen | One-line definition |
|---|---|---|---|---|---|---|
| useState | react | known | 9 | 3 | 2026-07-15 | A component's memory that survives re-renders |
| middleware | backend | known | 4 | 2 | 2026-07-12 | Code that runs between request and response, every time |
```

Rules:
- Created lazily — on the first promotion to `known` in any project. No setup step.
- **Up only:** promotions to `known` propagate here; demotions never do. Confusion in one project is noise; competence demonstrated anywhere is signal.
- **Reading it:** a concept known globally but absent from the local ledger enters locally at `developing` with a brief callback ("known from your other projects"), never a full re-explanation — and never silently as `known`, since context differs across stacks.
- Only `known` concepts live here. `new`/`developing` are project business.
- `Seen` sums sightings across projects; `Projects` counts distinct projects; `Last seen` is a date (YYYY-MM-DD), since report numbers are meaningless across projects.

## learning/inbox.md (session capture log)

Append-only during the session; compiled into the digest and then cleared. One line per meaningful change:

```markdown
# Inbox — changes awaiting a learning report

- [2026-07-15 14:32] added debounce to search input (src/Search.tsx) — teachable: debouncing, stale responses | user asked: "search feels laggy"
- [2026-07-15 15:10] fixed race in results rendering (src/Search.tsx) — teachable: race condition | follow-up to above
```

Rules:
- Write the line immediately after the change works, not at session end.
- Always capture the user's actual words — the "Your words → this code" section depends on them.
- Trivial changes don't get lines (same bar as reports).
- Leftover entries from a crashed or unreported session get folded into the next digest.

## learning/README.md (progress dashboard)

Regenerated after every report and quiz — the user's at-a-glance "am I actually learning?" view. Keep it under ~30 lines:

```markdown
# Your learning dashboard
*Updated after report 011 — 2026-07-15*

📖 Read the full story of this project: [the learning path](path.md)

**Concepts:** 12 known · 5 developing · 3 new — 20 total across 4 domains

## Where you are
| Domain | Level | Trend |
|---|---|---|
| react/frontend | 2.0 | ▲ from 1.5 (report 010 quiz) |
| databases | 0.5 | — |
| auth | 1.0 | ▲ new domain since report 003 |

## Up for review
`middleware` (developing, last seen report 007) · `migration` (misconception pending repair)

## Recent reports
| # | Title | Headline |
|---|---|---|
| 011 | Sessions now survive a page refresh | session storage |
| 010 | Search waits for you to stop typing | debouncing |

*Say "quiz me" to review · "walk me through report N" to go deeper.*
```

Rules:
- Trend arrows cite evidence (the report/quiz that moved the level), same discipline as profile.md.
- "Up for review" surfaces at most 3 items: oldest developing concepts and pending misconceptions.
- The footer line always advertises the two interactive modes — it's how users discover them.
