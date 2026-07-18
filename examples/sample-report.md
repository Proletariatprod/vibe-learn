# Report 006 — Search that waits for you to stop typing

**Date:** 2026-07-12 | **Files touched:** 2 | **New concepts:** 2 | **Reinforced:** 1

---

## 🌱 Level 0 — What just happened

Your app's search box used to fire off a lookup for every single letter you typed — type "guitar" and it searched seven times: "g", "gu", "gui"... Six of those searches were wasted work, and on a slow connection the results could even arrive out of order and show you answers for "gui" after you'd finished typing "guitar". Now the app waits until your fingers pause for a third of a second, then searches once. Think of a good waiter: he doesn't run to the kitchen after every word you say — he waits until you've finished ordering.

## 🧩 Level 1 — The ideas involved

### Debouncing  `new`
Delaying an action until the triggering events stop coming, then doing it once.
**Think of it like:** an elevator door. It doesn't slam shut the instant one person enters — it waits a beat, and every new person stepping in resets the wait. It closes only when people stop arriving.
**In this change:** every keystroke resets a 300-millisecond timer; the search only runs when the timer survives untouched.

### API route  `developing — 2nd time, see report 004`
Same idea as the contact form's back-office window from report 004: a URL in your own app that exists for your code to call, not for people to visit. Today's search box calls one.

*(This change also uses `useState` — that's in your known pile, so no re-explanation. It's doing its usual job: remembering what's currently typed.)*

## 🔍 Level 2 — The actual code

**1. Every keystroke resets the timer instead of firing a search** — `components/SearchBox.tsx`
```tsx
useEffect(() => {
  const timer = setTimeout(() => {
    if (query.length >= 2) {
      fetch(`/api/search?q=${encodeURIComponent(query)}`)
        .then((res) => res.json())
        .then(setResults)
    }
  }, 300)

  return () => clearTimeout(timer)
}, [query])
```
The magic is the last line inside: `return () => clearTimeout(timer)`. React runs that cleanup every time `query` changes — killing the previous timer before starting a new one. That's the elevator door resetting. Also notice `query.length >= 2`: no point searching on one letter.

**2. `useEffect` is the new face here** — same file
```tsx
}, [query])
```
That `[query]` list at the end tells React: "re-run this block whenever `query` changes, and nothing else." Forget the list and the block runs on every render of any kind — a classic source of runaway loops.

## 🏗️ Level 3 — Why this way

The obvious alternative was throttling — search at most once per 300ms *while* typing, instead of waiting for typing to stop. Throttling gives live-updating results mid-word; debouncing gives fewer requests and a calmer UI. For a search box backed by a real database query, debouncing wins: users care about results for the word they meant, not the fragments along the way, and every skipped request is database load you don't pay for.

What a senior dev would double-check: the out-of-order problem isn't fully dead. If a search takes longer than 300ms to come back and the user types again, an old response can still arrive after a newer one and overwrite it. The fix (an abort controller that cancels stale requests) was left out today to keep the change small — worth asking for if search ever hits a slow table.

## 🔗 Your words → this code

> "the search feels laggy and it's hammering the database"

Your sentence named two symptoms; the code made three decisions you didn't specify: (1) debounce rather than throttle — that was a judgment call about what "feels right" for search; (2) 300ms as the wait — long enough to skip mid-word requests, short enough to feel instant (typical range is 200–500ms); (3) the 2-character minimum, which you never mentioned but kills the most expensive queries of all. Unstated decisions like these are worth spotting — they're yours to control once you can see them.

**Try this next time:** "the search is hammering the database — debounce it at 300ms, skip searches under 2 characters, and cancel stale requests so old results can't overwrite new ones."

## ❓ One question

A user types "gu", pauses half a second, then types "itar" and stops. How many times does the search API actually get called — and which line decides that?

<details><summary>Answer</summary>

Twice: once for "gu" (the half-second pause outlives the 300ms timer) and once for "guitar". The deciding line is `return () => clearTimeout(timer)` — every keystroke during "itar" killed the pending timer before it could fire, so the fragments "gui", "guit", "guita" never searched.

</details>

---
*Concepts ledger updated: debouncing (new), useEffect (new), API route (2/3). Reading time: ~4 min.*
