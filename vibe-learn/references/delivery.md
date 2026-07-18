# Delivery: getting the report in front of the user

A report the user never opens teaches nothing. The markdown in `learning/reports/` is the source of truth, but terminal users won't go digging for it — so after saving the `.md`, deliver it according to the `Report delivery` preference in `profile.md` (asked at setup, changeable any time: "deliver my reports as PDF from now on").

The tiers below degrade gracefully: if a tier's tool is missing, fall back one tier and tell the user once what to install. Never let delivery failure block or delay the report — the .md is already saved.

## Tier 0 — chat line only (`delivery: markdown`)

The default before calibration. One line in chat with the path. Fine for users who read reports in their editor.

## Tier 1 — HTML, auto-opened (`delivery: html`) — recommended default

Zero dependencies. After saving the .md, also write `learning/reports/NNN-slug.html` — a **self-contained** HTML file (inline CSS, no external assets) rendering the report with:

- readable typography (max-width ~46rem, 1.6 line-height, system font stack)
- the emoji level markers as a sticky mini table-of-contents so the reader can jump to their depth
- `<details>` blocks preserved (the quiz answer stays collapsed)
- code blocks styled with a light background and horizontal scroll

Write the HTML yourself from the markdown you just wrote — do not require pandoc. Then open it:

```bash
open "learning/reports/NNN-slug.html"        # macOS
xdg-open "learning/reports/NNN-slug.html"    # Linux
```

The report pops up in the browser the moment the session's work is done — that's the seamless moment. If the environment is headless (SSH, CI), skip the `open` and say so in the chat line.

## Tier 2 — PDF in the folder (`delivery: pdf`)

Probe for a converter in this order and use the first hit:

```bash
# 1. Chrome/Chromium headless (very common, best rendering of the HTML from Tier 1)
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --print-to-pdf="learning/reports/NNN-slug.pdf" "learning/reports/NNN-slug.html"
# 2. wkhtmltopdf
wkhtmltopdf learning/reports/NNN-slug.html learning/reports/NNN-slug.pdf
# 3. pandoc (needs a LaTeX or weasyprint engine for PDF)
pandoc learning/reports/NNN-slug.md -o learning/reports/NNN-slug.pdf
# 4. macOS fallback, no installs (loses some styling)
textutil -convert html learning/reports/NNN-slug.md -output /tmp/report.html && cupsfilter /tmp/report.html > learning/reports/NNN-slug.pdf
```

PDF delivery always builds the Tier 1 HTML first (Chrome and wkhtmltopdf convert HTML, and the HTML is the styling). If no converter exists, deliver Tier 1 and tell the user once: "PDF needs Chrome or wkhtmltopdf — delivering HTML until then."

Optionally `open` the PDF too, same rule as Tier 1.

## Tier 3 — email (`delivery: email <address>`)

Email requires a send command the user has already configured — the skill must never handle SMTP credentials itself. At setup, if they choose email, ask which sender they have and record it in profile.md:

```markdown
- Report delivery: email geoff@example.com via Mail.app
```

Recipes, in order of how commonly they're already set up:

```bash
# macOS Mail.app (no credentials needed — uses their signed-in account)
osascript -e 'tell application "Mail"
  set m to make new outgoing message with properties {subject:"Learning report 012 — Sessions survive refresh", content:"Report attached.", visible:false}
  tell m to make new to recipient with properties {address:"USER@EXAMPLE.COM"}
  tell m to make new attachment with properties {file name:POSIX file "/full/path/learning/reports/012-slug.pdf"}
  send m
end tell'

# himalaya / msmtp / mutt — if the user already uses one, per their config
```

Attach the PDF if Tier 2 succeeded, else the HTML. Subject line = the report's plain-English title. Body = the Level 0 section as text (so the email is skimmable on a phone) plus "full report attached."

Caveats:
- Confirm the address once at setup, then send without asking — that's the seamless contract. If a send ever fails, fall back to Tier 1 and say so.
- Never configure mail forwarding rules or store passwords; if the user has no sender configured, recommend Mail.app (macOS) or delivering as PDF instead.

## The chat line, updated

Whatever the tier, the one-line chat close-out now names the delivery: "📚 Report 012 saved and opened in your browser" / "…PDF in learning/reports/" / "…emailed to geoff@…". Still one line, still no report pasted into chat.

## Choosing at setup

The calibration questions (SKILL.md first-run setup) gain a third: **"How do you want reports delivered — pop up in your browser (default), PDF in the folder, or emailed?"** Record the answer in profile.md Preferences. Users can change it any time in plain English; update profile.md when they do.
