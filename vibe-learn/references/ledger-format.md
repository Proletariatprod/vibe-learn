# Ledger Format

Two files make the skill cumulative. Keep both machine-scannable (you read them at the start of every report) and human-readable (the user will browse them — `concepts.md` doubles as their personal glossary).

## learning/concepts.md

One table, sorted by status (new → developing → known), then alphabetically.

```markdown
# Concept Ledger

Statuses: `new` (seen once) → `developing` (seen 2x) → `known` (seen 3+ or user-confirmed).
Known concepts are referenced by name in reports, never re-explained.

| Concept | Domain | Status | Seen | First report | Last report | One-line definition |
|---|---|---|---|---|---|---|
| middleware | backend | developing | 2 | 003 | 007 | Code that runs between request and response, every time |
| session | auth | known | 4 | 003 | 011 | Proof you already logged in (the festival wristband) |
| useState | react | known | 6 | 001 | 010 | A component's memory that survives re-renders |
```

Rules:
- Promote at 3 sightings, OR immediately if the user demonstrates it (uses the term correctly, answers a quiz on it, explains it back).
- Demote known → developing if the user expresses confusion about it. Then re-explain fresh in the next relevant report — treat the demotion as new information about the user, not a failure.
- Keep definitions to one line; the reports hold the full explanations. Include the metaphor's anchor word in parentheses when it helps recall.
- A "sighting" = the concept was materially involved in a report, not merely present in the diff.

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
- Depth priority: [e.g. "wants Level 3 emphasis on security topics"]
- Quiz appetite: [loves them / tolerates them / skip]

## Report index
| # | Title | Headline concepts |
|---|---|---|
| 001 | The contact form remembers what you typed | useState, controlled input |
| 002 | ... | ... |
```

Rules:
- Levels move in 0.5 steps, on evidence only — never on vibes or elapsed time. Cite the evidence in the table.
- Domain levels shape which layers get the most care: a Level 0 domain gets a rich Level 0–1 and a brief Level 3; a Level 2.5 domain gets one-line Levels 0–1 and a deep Level 3. All levels always appear (the user may share reports, or regress after a break) — what changes is the weight.
- The report index is the user's table of contents for their entire learning history. Keep it current; it costs one line per report.
