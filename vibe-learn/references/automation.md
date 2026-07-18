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

## Option 2: Stop hook (deterministic reminder, marker-based)

A Claude Code hook fires every time, no model judgment involved. This one injects a reminder when Claude finishes responding — but only when the code has actually changed **since the last report**, tracked via a marker file the skill refreshes each time a report is written. Add to the project's `.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if [ -d learning ]; then state=$( { git rev-parse HEAD 2>/dev/null; git diff HEAD 2>/dev/null | git hash-object --stdin 2>/dev/null; } | tr '\\n' ' ' ); last=$(cat learning/.last-report-state 2>/dev/null); if [ -n \"$state\" ] && [ \"$state\" != \"$last\" ]; then echo '{\"decision\": \"block\", \"reason\": \"Code changed since the last learning report and a learning/ directory exists. Check learning/inbox.md: if it has entries or meaningful changes happened, write the session digest now using the vibe-learn skill, then update learning/.last-report-state. If the changes were trivial, update the marker and stop.\"}'; fi; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

How it works: the hook computes the current state (commit hash + a hash of the uncommitted diff) and compares it to `learning/.last-report-state`. They differ only when code changed since the last report — a habitually dirty working tree no longer causes false fires, because that dirty diff was part of the state when the marker was last written. When a report is written (or changes were judged trivial), the skill refreshes the marker:

```bash
{ git rev-parse HEAD; git diff HEAD | git hash-object --stdin; } | tr '\n' ' ' > learning/.last-report-state
```

Add `learning/.last-report-state` to `.gitignore` — it's per-machine state, not project content.

## Option 2b: PostToolUse breadcrumb (deterministic capture)

The Stop hook makes the *digest* reliable; this one makes the *capture* reliable. It appends a raw breadcrumb to `learning/inbox.md` whenever Claude edits a file, so even a session that ends abruptly leaves a trail the next digest can pick up. Combine with Option 2:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "if [ -d learning ] && command -v jq >/dev/null; then f=$(jq -r '.tool_input.file_path // empty' 2>/dev/null); case \"$f\" in */learning/*) ;; *) [ -n \"$f\" ] && printf -- '- [%s] (auto) touched %s\\n' \"$(date '+%Y-%m-%d %H:%M')\" \"$f\" >> learning/inbox.md ;; esac; fi",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

The `case` guard skips files inside `learning/` itself (otherwise writing a report would breadcrumb the report). Auto-breadcrumbs are raw material, not teachable entries — the skill's hand-written inbox lines (with concepts and the user's words) are richer; the hook is the floor, not the ceiling. At digest time, deduplicate: an auto line for a file already covered by a hand-written line adds nothing.

Caveats to tell the user:
- Hook syntax evolves; if either hook errors on their Claude Code version, check `/hooks` in-app or the current hooks docs rather than debugging blind.
- The PostToolUse hook needs `jq`; without it the hook silently does nothing (by design — never block the build).

## Option 3: manual, zero setup

The skill's own description matches phrases like "explain what you just did" and "/learn" typed as a plain message. Users who dislike automation can simply ask after any change. No configuration needed.
