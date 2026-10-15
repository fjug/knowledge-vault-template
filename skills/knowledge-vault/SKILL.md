---
name: knowledge-vault
description: "Use the owner's Markdown knowledge vault: check it before substantive work, file durable conclusions after, and fix corrected facts at the source they came from."
---

# Knowledge vault

A Markdown knowledge vault owned by the person described in its `OWNER.md`.
Three operations: **consult**, **capture**, **maintain**. Most sessions use consult at the start and capture at
the end.

## When to use this skill

- At the **start** of any substantive task (research, drafting, planning,
  debugging, decisions, purchases, institutional questions), to check what the
  vault already knows.
- At the **end**, or whenever a conversation produces something durable: a
  conclusion, a decision, a working recipe, a dead end, a lesson learned. Do
  this even when the owner does not ask.
- Whenever the owner says "what do I know about", "have we done this before",
  "did I decide", "check my notes", "last time", "remember this", "add this to
  the vault", "anything here worth keeping?", or refers to a past project, person or decision as if you should
  already know it.
- Whenever the owner corrects a fact ("that's wrong", "where did you get that",
  "I never said that").
- When asked to check the vault's health or triage its inbox.

## Locating the vault

In order of preference:

1. `$KNOWLEDGE_VAULT` if set.
2. `{{VAULT_PATH}}`.
3. A `vault-notes` symlink in the current repo.
4. No local copy, but a GitHub connector is available. Reach the repo directly
   with the GitHub connector's tools against the repository `{{GITHUB_REPO}}`.
   This is the route for a phone or web session. It needs the connector's
   GitHub App installed on the repository, and it reads
   and writes through the API rather than a working tree. See "Reaching the vault
   with no local clone" in `AGENTS.md` for the two caveats: writes skip the
   `pre-push` hook and `.gitignore`, and a connector commit can move `main` ahead
   of a local clone.

If none of these is available, you are in a chat-only session. Skip to **Capture
without filesystem access** at the end of this file.

Always read `AGENTS.md` and `OWNER.md` at the vault root before writing, through
the connector if that is your only access. They are authoritative and override
anything here.

---

## Consult

Run this at the start of a task, before doing the work. It costs little and the
whole point of the vault is that it saves you from redoing something.

1. Read `index.md`. It is a map with one-line descriptions, not a container.
2. `grep -ril "<term>" topics/ projects/ people/ institutional/` for two or three
   terms from the request, including likely synonyms. Filenames are kebab-case
   and greppable.
3. Open two or three candidate notes. Not twenty. Follow `related` links only if
   the first pass leaves a gap.
4. **Report what you found before starting the work**, in one or two lines:
   "The vault has a note on X from March that settles the hosting question, and
   a project note on Y that is probably stale." Then proceed.
5. Cite file paths for anything you use.

If the vault has nothing, say so in one short sentence and carry on. Do not
apologise for it and do not pad the answer.

In a project or person note, read the state above the `<!-- timeline -->` line
first; the dated entries below it are the evidence. If the newest entry is later
than the "State as of" date, say the state may be stale. For how one idea has
changed over time, use the `idea-lineage` skill in `skills/`.

**Precedence.** For facts about the owner's own work, decisions, collaborators, and
institutional context, the vault beats your training data and beats web search.
For general knowledge, the reverse. If the vault contradicts what the owner says in
the conversation, the conversation wins and you should flag the stale note.

---

## Capture

Run this at the end of a task, or whenever a conversation produces something
durable. Ask one question: **would the owner have to work this out again from
scratch in six months?** If yes, capture it.

Capture:
- Conclusions, with the reasoning compressed to what matters.
- Decisions, with what was chosen, why, and what would trigger a rethink.
- Recipes that worked: commands, parameters, file paths, version strings.
- Dead ends, with the reason they were dead. These are as valuable as successes
  and they are what people always forget to write down.
- Facts about people and institutions that took effort to learn.

Do not capture:
- Transcripts or summaries of the conversation itself.
- Anything you could re-derive from a search in thirty seconds.
- Anything still in flux. Wait until it settles, or write it as an open question.
- The contents of a project's working folder. Lab books, run logs, dated
  experiment entries, datasets and figures stay where they are. The vault holds
  the conclusion and a pointer; the folder holds the evidence. Copying findings
  across creates two sources of truth that will drift.

For a project with substantial material of its own, write one `projects/` note
that summarises state and points at the folder, lift each durable conclusion into
its own `topics/` note as it settles, and leave everything else alone. Record the
folder path in `substrate:` and name the two or three files worth opening first.

### Notes about people

One note per person in `people/`, colleague or influence or both, discriminated
by the multi-valued `relation:` field. Two firm rules. **Never write biography**:
an influence note records which of their ideas the owner uses, where those appear in
the owner's notes, what to read, and where the owner diverges, not their career. **Record
only what the owner tells you**: personal details about colleagues and their
families are a memory aid, taken from what the owner says in conversation and never
looked up, inferred, or carried across from another source, with nothing about
health or relationships. These notes stay `sensitivity: confidential`.

### The filing decision

This is where agents go wrong. Follow it strictly.

- **Clearly durable and clearly on-topic** → write to `topics/`, register it in
  `topics/index.md` and in the root registry, append to `log.md`.
- **Clearly tied to one effort** → write to `projects/`, same registration.
- **Anything else, including "I am not sure this belongs in the vault at all"** →
  write to `inbox/` with full frontmatter, and **say so in your reply**. Do not
  agonise, do not ask a clarifying question, and above all do not silently drop
  it. The inbox exists precisely so the decision can be deferred to the owner at
  triage time rather than blocking the session.

The inbox is the default. Using it is not a failure.

### Writing the note

Use the templates in `_templates/`. Required frontmatter field is `type`;
write `title`, `description`, `tags`, `status`, `sensitivity`, `created`,
`updated`, `related` unless you have a reason not to.

Set `sensitivity` deliberately: `confidential` for anything touching personnel,
compensation, unpublished negotiation, or evaluation of a named person;
`personal` for private life; `internal` by default; `public` only for material
already published.

Project and person notes have two zones split by a line reading exactly
`<!-- timeline -->`. Above it is state: rewrite it so it always reads as the
present. Below it is the record: add one dated entry per decision or event,
newest first, as `- **2026-09-27** | What happened, and why. (Source: ...)`.
Never edit or remove an entry; a reversal is a new entry naming the one it
supersedes. Topics have no timeline. `revisit:` in the frontmatter takes a date
and the event that would make the note wrong; set it whenever a note depends on
someone else's move or a deadline.

Then, **in the same change**:
- register the note in its directory `index.md` and the root registry,
- add cross-links and mirror them in `related`,
- append one line to `log.md`, naming every note you touched,
- run `sh bin/vault-doctor.sh` and fix what it reports about your change.

An unregistered note is invisible, because agents navigate by index.

### Corrections

When the owner says something is wrong, fix the source, not only the symptom.
Quote the wrong claim and state the correction. Then search every store you can
reach (the vault, your memory of them, the skills, `AGENTS.md`, project
instructions), find where the error came from, and fix it there: a vault note
gets corrected state and, in a project or person note, a dated correction entry;
a memory or instruction gets corrected in place; a fact the agent made up gets
named, with the partial signals that produced it. Report in a line or two what
you found and where you fixed it. The full table is in `AGENTS.md` section 8.

### Triaging the inbox

When the owner asks to triage, go through `inbox/` one note at a time, oldest
first. For each, propose one move and wait for the answer: promote it (to
`topics/`, `projects/`, `people/` or `institutional/`, registered and linked),
merge it into an existing note, or archive it with a banner. Keep `inbox/index.md`
in step, and log the session in one line.

### Scope

Never do an unscoped "update the vault". Name the files you intend to touch,
and for anything beyond two or three files, propose the list and wait for
agreement. Unscoped rewrites produce churn that is hard to review in a diff.

### Never delete

Superseded material moves to `archive/`, gains a banner, and is removed from its
index. De-indexing is what hides it from agents while keeping it recoverable.

```markdown
> **Superseded 2026-09-01.** Not authoritative. See [new note](../topics/x.md).
```

---

## Maintain

The mechanical checks run on every push, twice: the `pre-push` hook calls
`bin/vault-doctor.sh` on the pushing machine (warnings only), and a GitHub
Action runs the same script on every push from any source and every Monday,
marking each commit with a tick or a cross. After a connector commit, check
that mark. Run the script yourself after any change, and on request for a full
report:

```bash
sh bin/vault-doctor.sh             # whole vault, warnings only
sh bin/vault-doctor.sh --strict    # exit 1 on any finding
```

It reports missing `type`, unregistered notes, broken `related` targets, tags
outside the vocabulary, orphaned topic, project and institutional notes, people
named but not linked, passed `revisit:` dates, stale actives, state older than
its own timeline, and, for a pushed range, changed notes with no `log.md` line
and edited timeline entries.

Fix what it reports about your own change. Report the rest and fix only what is
agreed. One thing it cannot judge stays with you: a note that grew to cover
three things should become three.

---

## Style

Everything written into the vault follows the writing conventions in `OWNER.md`.
Where it is silent: concrete before abstract, committed statements over hedged
ones, no hype, short sentences.

---

## Capture without filesystem access

In a chat-only session you cannot write to the vault. Produce a **deposit**
instead: one or more complete Markdown files, fully conformant, that the owner can
drop into the vault's `inbox/` unchanged.

- One file per note. Full frontmatter. Kebab-case filename stated clearly.
- If a file-creation tool is available, create real `.md` files and present them.
  Otherwise emit them as fenced code blocks, one per note, filename above each.
- End with a single line telling the owner where they go:
  "Save these to the vault's `inbox/`."

Do not attempt to update indexes or `log.md` from a chat-only session. Registration
happens at triage, on the machine that holds the vault.
