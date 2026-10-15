---
name: idea-lineage
description: "Trace how one of the owner's ideas changed over time, from the knowledge vault and its git history: first mention, best version, current version, reversals, dead branches."
---

# Idea lineage

One idea, followed through the vault and its history, so that the owner sees
where it came from, where it was best stated, what it displaced and what is
live now. The vault keeps conclusions and dead ends; git keeps every revision
with a date. Together they are a trajectory record of how the thinking moved.

Read `AGENTS.md` first, as for any vault work. This skill writes nothing unless
the owner asks for the result to be filed.

## When to use this skill

When the owner asks "how has my thinking on X changed", "where did this idea
come from", "what is my current version of X", "trace the lineage of", or "when
did I drop", and before writing about an idea they have worked on across
several notes. Not for mapping a whole field (use the topic notes) or for a
project's decisions (read its timeline).

## 1. Pin the idea

Restate it in one sentence and confirm it if there is any doubt. If the phrase
covers two different ideas, ask which one before going further. One idea per
run: a request to map a whole area belongs in the topic notes, not here.

## 2. Gather the evidence

From the vault root:

```bash
grep -rl -i "<phrase>" topics projects people inbox archive raw     # where it lives now
git log --follow --format='%h %ad %s' --date=short -- <note>        # when each note changed
git log -p --follow --date=short -- <note>                          # what changed, line by line
git log -S "<phrase>" --format='%h %ad %s' --date=short             # when the phrase entered or left
```

Also read the `## Timeline` of any project or person note it touches, the
`archive/` notes it appears in (superseded is still evidence), `raw/` sources,
and `log.md` entries naming those notes. Read the two or three notes where the
idea carries most weight in full. Prefer few sources read properly over many
skimmed.

## 3. Sort what you found

| Bucket | What goes in it |
|---|---|
| First appearance | The earliest dated evidence. Say whether it is the idea or only its seed. |
| Best articulation | The clearest statement, not necessarily the newest. Quote the owner's sentence if they wrote one. |
| Current version | The latest statement still standing in a live note. |
| Reversals | Where their position changed direction, with what changed it. |
| Contradictions | Two live claims that cannot both hold. Distinguish from a supersession, where the newer one replaced the older. |
| Abandoned branches | Variants that appeared and stopped, or were rejected, with the reason if recorded. |
| Related ideas | Neighbours that fed it or inherited from it, linked. |

An empty bucket says "No clear evidence", plus what you searched. Never fill a
gap with a plausible story: a smooth narrative the evidence does not support is
the main failure mode of this skill.

## 4. Answer

Lead with the current version in one or two sentences. Then the buckets, in
the order above, each claim with a citation: the note path, the commit hash and
date when the evidence is a revision, and a short quote. Keep it proportional:
three evidenced points beat ten inferred ones.

End with at most one suggested action, when the evidence calls for it: a
contradiction to resolve in a named note, a stated best version that is buried
in a project note and should be lifted into `topics/`, or a `revisit:` date
worth setting.

## 5. Filing, only on request

If the owner wants the lineage kept, it is a deposit, not a topic: write it to
`inbox/` with full frontmatter, `type: session`, and register it, as
`AGENTS.md` describes. A lineage is evidence about an idea, and the idea's own
topic note stays the place where the current version lives.

## Provenance

Adapted on 2026-10-15 from the `idea-lineage` skill in GBrain
(github.com/garrytan/gbrain, MIT licence), rewritten for a git-backed Markdown
vault with no database.
