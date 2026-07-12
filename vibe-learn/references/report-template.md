# Report Template

Use this exact structure. Sections may shrink as the ledger fills, but the order never changes — consistency is what lets the user build a reading habit and choose their own depth.

---

## Template

```markdown
# Report NNN — [Plain-English title of what changed]

**Date:** YYYY-MM-DD | **Files touched:** N | **New concepts:** X | **Reinforced:** Y

---

## 🌱 Level 0 — What just happened

[3–6 sentences. Zero jargon. Describe what the app now does differently
from the perspective of someone using the app. One metaphor maximum.]

## 🧩 Level 1 — The ideas involved

### [Concept name]  `new`
[One-line plain definition.]
**Think of it like:** [metaphor fitted to this specific concept].
**In this change:** [where it shows up, one line].

### [Concept name]  `developing — 2nd time, see report 004`
[One-line callback, not a full re-explanation.]

## 🔍 Level 2 — The actual code

[Walk the change in execution order. For each key moment:]

**[What this moment does]** — `path/to/file.ts`
​```ts
// exact snippet from the real file, ≤ 20 lines
​```
[1–3 lines of annotation: what to notice and why.]

## 🏗️ Level 3 — Why this way

[The engineering judgment: why this approach over the obvious alternative,
the tradeoff accepted, what could break, what a senior dev would double-check.
2–4 short paragraphs. This section teaches taste, not syntax.]

## 🔗 Your words → this code

> "[what the user actually asked for]"

[Trace how that request became these technical decisions. Note anything
Claude decided that the user didn't specify — those unstated decisions are
exactly what vibe coders need to learn to see.]

## ❓ One question

[A scenario-based application question about today's change. Never definition recall.]

<details><summary>Answer</summary>

[The answer, plus the one-line reasoning path to get there.]

</details>

---
*Concepts ledger updated: [list]. Reading time: ~N min.*
```

---

## Worked example

The change: user asked "make it so people have to log in before seeing the dashboard" in a Next.js + Supabase app. Claude added middleware and a login page.

```markdown
# Report 003 — The dashboard now has a locked door

**Date:** 2026-07-12 | **Files touched:** 3 | **New concepts:** 2 | **Reinforced:** 1

---

## 🌱 Level 0 — What just happened

Before today, anyone with the web address of your dashboard could open it and
see everything. Now the app checks who you are first. If you're not signed in,
you get sent to a login page, and after signing in you land back where you were
headed. Think of it like a club that used to leave its door propped open and
just hired a doorman: the doorman doesn't change what's inside the club — he
only decides who gets in.

## 🧩 Level 1 — The ideas involved

### Middleware  `new`
Code that runs in between a request ("show me the dashboard") and the response
(the dashboard itself) — every single time, before anything else.
**Think of it like:** airport security. Every passenger passes through it
before reaching any gate, no exceptions, and it decides: proceed or turn back.
**In this change:** one new file, `middleware.ts`, is now the doorman for every
page under `/dashboard`.

### Session  `new`
Proof that you already logged in, so the app doesn't ask for your password on
every click. Stored in your browser and checked by the server.
**Think of it like:** the wristband a festival gives you at the entrance.
Security checks your ID once; after that, the wristband is enough.
**In this change:** the middleware doesn't check your password — it checks for
a valid wristband (session) and only sends you to login if it's missing.

### Redirect  `developing — 2nd time, see report 001`
Same idea as when we sent users to the thank-you page after the contact form:
the server answers "what you want is over there" and the browser goes.

## 🔍 Level 2 — The actual code

**1. Every request to /dashboard passes through here first** — `middleware.ts`
​```ts
export async function middleware(request: NextRequest) {
  const supabase = createServerClient(/* ... */)
  const { data: { user } } = await supabase.auth.getUser()

  if (!user && request.nextUrl.pathname.startsWith('/dashboard')) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    url.searchParams.set('next', request.nextUrl.pathname)
    return NextResponse.redirect(url)
  }
  return NextResponse.next()
}
​```
Notice `searchParams.set('next', ...)` — the app writes down where you were
trying to go, so it can send you back there after login. Small detail, big
difference in how the app feels.

**2. This line tells Next.js WHICH pages get the doorman** — `middleware.ts`
​```ts
export const config = { matcher: ['/dashboard/:path*'] }
​```
Without this, the middleware would run on every page including the public
homepage — wasted work and possible redirect loops.

## 🏗️ Why this way — Level 3

The obvious alternative was checking for a user inside the dashboard page
itself. That works, but it means every protected page needs its own check —
and the day someone adds a new page and forgets, that page is silently public.
Middleware centralizes the decision: one doorman, one place to audit.

The tradeoff: middleware runs on every matched request, so it must stay fast —
which is why it only *reads* the session rather than hitting the database for
profile data. A senior dev reviewing this would double-check the `matcher`
covers every route that should be private (what about `/api/dashboard/...`?)
— that's the classic hole in this pattern.

## 🔗 Your words → this code

> "make it so people have to log in before seeing the dashboard"

Your one sentence became three decisions you didn't specify: (1) WHERE to
check — middleware, not per-page; (2) WHAT to check — a session, not a
password each time; (3) the post-login return trip via the `next` parameter.
None of these were in your prompt — you got them for free, but now you know
they're decisions, you can ask for them differently next time (e.g. "also
protect the API routes").

## ❓ One question

You add a new page at `/dashboard/settings` next week. Do you need to write
any login-checking code for it — and what one line in today's change is the
reason?

<details><summary>Answer</summary>

No — the `matcher: ['/dashboard/:path*']` line means the doorman already
covers every current AND future page under /dashboard. That's the payoff of
the middleware approach from Level 3.

</details>

---
*Concepts ledger updated: middleware (new), session (new), redirect (2/3).
Reading time: ~4 min.*
```

## Baseline report adaptations

Baseline reports (see SKILL.md "Baseline mode") use the same template with two swaps:

- `## 🌱 Level 0 — What just happened` → `## 🌱 Level 0 — What this piece does`
- `## 🔗 Your words → this code` → `## 🔗 Decisions already baked in` — the 2–3 biggest architectural decisions embedded in this subsystem that the user never consciously made (framework choice, where data lives, how secrets are handled). For each: the decision, the one-line reason it's reasonable, and what it would take to change later.

The quiz, ledger footer, and all other sections stay identical, so baseline and per-change reports read as one continuous series.

## Notes on tone

- Warm but not condescending. The reader is smart; they're just new to this domain.
- Levels 0–1 use "you/your app". Levels 2–3 can use technical voice.
- Never write "as you know" or "obviously". Never apologize for explaining.
- Emoji markers (🌱🧩🔍🏗️🔗❓) stay constant across all reports — they're the visual index that lets the reader jump to their level.
