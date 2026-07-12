# Automation: making reports fire reliably

Skill triggering is probabilistic — Claude decides based on the description. For "a report after every change," layer these mechanisms from simplest to most deterministic. Recommend option 1 to everyone; offer option 2 when the user asks why a report didn't generate.

## Option 1 (default): CLAUDE.md instruction

Add to the project's `CLAUDE.md`:

```markdown
## Learning reports
After completing any meaningful code change, use the vibe-learn skill to
generate a learning report in learning/reports/. Skip trivial changes
(typos, formatting, renames). One report per working session is fine when
changes come rapidly.
```

This puts the instruction in every session's context. Reliability: high but not guaranteed — long sessions can drift.

## Option 2: Stop hook (deterministic reminder)

A Claude Code hook fires every time, no model judgment involved. This one injects a reminder when Claude finishes responding, prompting it to check whether a report is owed. Add to the project's `.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if [ -d learning ] && ! git diff --quiet HEAD 2>/dev/null; then echo '{\"decision\": \"block\", \"reason\": \"Code changed this session and a learning/ directory exists. If the changes were meaningful and no learning report was written yet, generate one now using the vibe-learn skill. If the changes were trivial or a report already exists for this session, ignore this and stop.\"}'; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

How it works: when Claude tries to end its turn, the hook checks two conditions — a `learning/` directory exists (the project has opted in) and there are uncommitted changes (something happened). If both are true, it blocks the stop once and tells Claude to consider writing the report. Claude still applies the skill's judgment about trivial changes, so typo fixes don't generate spam.

Caveats to tell the user:
- The hook fires on ANY uncommitted changes, including ones from previous sessions. If they keep a dirty working tree habitually, this gets noisy — Option 1 is better for them.
- Hook syntax evolves; if this errors on their Claude Code version, check `/hooks` in-app or the current hooks docs rather than debugging blind.

## Option 3: manual, zero setup

The skill's own description matches phrases like "explain what you just did" and "/learn" typed as a plain message. Users who dislike automation can simply ask after any change. No configuration needed.
