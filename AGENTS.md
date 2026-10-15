# AGENTS.md — operating rules for this vault

You are working inside a personal and professional knowledge vault. Its owner,
and the conventions that are theirs rather than the vault's, are described in
[`OWNER.md`](OWNER.md). Wherever this file says "the owner", it means that
person.

Read this file **in full** before writing anything. Then read `OWNER.md` and
`index.md`.

The vault is a directory of Markdown files with YAML frontmatter, cross-linked
with ordinary Markdown links and navigated by `index.md` files. It is a git
repository. Every change is a diff somebody may read later.

---

## 1. The one rule that matters most

**A note's job is to save the owner from re-deriving something they already worked out.**

If a note does not do that, it does not belong here. Meeting minutes, transcripts,
and raw correspondence are not notes. They are sources, and they go in `raw/`.

### The vault is the distillate, not the reactor

Large projects generate far more material than belongs here: training runs, lab
books, dated experiment entries, datasets, figures, notebooks, generated reports.
That substrate stays in the project's own working folder, next to the code and
data it describes. The vault holds the distillate and a pointer to the reactor.

- **The vault** is the single source of truth for *what was learned*: the reasons
  for the work, the main reasoning, the settled conclusions, the dead ends and
  why they were dead.
- **The working folder** is the single source of truth for *what was run*:
  chronological, voluminous, churny, and correctly so.

Never copy findings verbatim from a working folder into the vault. That creates
two sources of truth and guarantees they drift apart. Copy the conclusion, cite
where the evidence lives.

A large programme therefore does not become one vault note. It decomposes into
several atomic `topics/` notes, one per durable idea, plus one `projects/` note
for the effort itself. The decomposition is where much of the value is, because
it forces each conclusion to be stated cleanly and separately from its evidence.

---

## 2. Layout

```
<vault>/
├── AGENTS.md          you are here
├── OWNER.md           who owns the vault and their own conventions
├── index.md           entry point and map. Read second.
├── log.md             chronological record of what changed and why
├── inbox/             unfiled deposits awaiting the owner's triage
├── projects/          time-bounded efforts. Go stale by design.
├── topics/            durable know-how. This is where value compounds.
├── people/            collaborators, students, vendors, counterparts
├── institutional/     the owner's institution: structures, processes, budgets, committees
├── raw/               immutable sources. Never edit. Never reorganise.
├── archive/           superseded material, kept but de-indexed
├── private/           gitignored. Third-party personal data. Never leaves the machine.
├── attachments/       figures and files referenced by notes
├── bin/               machine setup and the vault doctor
└── skills/            agent skills that live with the vault
```

Directory choice, in order of preference: **`topics/` first.** Ask "will this
still be useful when this project is over?" If yes, it is a topic. Projects
should link to topics, not duplicate them.

---

## 3. Frontmatter

Every note carries YAML frontmatter. `type` is the only strictly required field,
but write the others unless you have a reason not to.

```yaml
---
type: topic                    # required. See vocabulary below.
title: Versioning large datasets
description: One sentence. This is what an agent reads to decide whether to open the file.
tags: [workflow, infrastructure]
status: active                 # active | dormant | superseded | archived
sensitivity: internal          # public | internal | confidential | personal
created: 2026-05-12
updated: 2026-05-12
related:
  - ../projects/data-pipeline.md
sources:
  - ../raw/2026-05-12-design-review-thread.md
substrate: ~/Documents/Claude/Projects/<name>/   # project notes only. Where the evidence lives.
relation: [collaborator, influence]              # person notes only. See index.md.
aliases: [Curie]                                 # person notes only. Other names notes use for them.
revisit: 2027-03-01, when the partner's terms arrive # optional. A date, then what would make this note wrong.
---
```

**`revisit`** is the note's own decay model, written at the moment you know it
best: the date to look again and the event that would make the note wrong.
Use it for anything that depends on someone else's move or on a deadline. The
vault doctor lists every note whose revisit date has passed, so the question
arrives specific rather than as a generic "is this still true?".

**`aliases`** lets the vault doctor notice when a note names a person without
linking their note. Add a surname for an influence cited academic-style, or a
short form a colleague goes by. Never a nickname they have not used themselves.

**`type` vocabulary** (extend deliberately, and register additions in `index.md`):
`project`, `topic`, `person`, `org`, `decision`, `protocol`, `source`, `session`.

**`sensitivity` is not decorative.** A vault like this soon holds grant drafts,
salary and budget discussions, personnel matters, negotiations, and private
life. Before writing anything about a named third party, ask whether it would be
defensible if that person read it. If the answer is no, do not write it. Mark
anything touching personnel, compensation, or unpublished negotiation as
`confidential` and never include it in an exported or shared subset.

---

## 4. Note shape

```markdown
# Title

> One-sentence summary, mirroring the frontmatter description.

## What this is
Two to four sentences of context. When does this apply?

## Detail
Short H2/H3 sections. Concrete before abstract. Numbers, names, file paths,
version strings, error messages. The specific thing is the useful thing.

## Open questions
What is still unresolved. Delete the section when nothing is.

## Related
- [Data pipeline](../projects/data-pipeline.md) — this topic was worked out there first.
- [Jane Example](../people/jane-example.md) — counterpart for procurement questions.

## Provenance
Compiled from a Claude conversation, 2026-05-14. Sources in `raw/`.
```

Annotate every link with **why** the two notes connect. An unexplained link is
close to useless six months later.

State conclusions, not deliberations. If a question was settled, record the
answer and one line on why the alternatives lost. If it was not settled, say so
explicitly under Open questions rather than leaving it ambiguous.

### State above the line, record below it

Project and person notes have two zones, separated by a line that reads exactly
`<!-- timeline -->`.

- **Above the line is state.** Goal, current state, open threads, how to work
  with someone. Rewrite it whenever the facts change, so that it always reads as
  the present. Do not append to it, and do not keep a superseded paragraph
  beside its replacement.
- **Below the line is the record**, under `## Timeline`: one dated entry per
  decision, event or exchange, newest first, in the form
  `- **2026-09-27** | What happened, and why. (Source: where it was settled)`.
  Entries are never edited and never removed. A wrong entry is corrected by a
  new one; a reversal is a new entry that names the one it supersedes.

Every claim above the line should be traceable to an entry below it. When an
entry is newer than the "State as of" date, the state is stale: rewrite it in
the same change. The vault doctor flags both a stale state and any edit to an
existing entry.

Topics have no timeline. They are distillates, and git history is already their
record. Use `idea-lineage` (in `skills/`) to read that history back.

Automation may freshen the state above the line but never the record below it.
The marker string matches the one GBrain uses (github.com/garrytan/gbrain), so
notes stay importable into it unchanged.

Preserve the owner's own words when they land. A distilled paraphrase is usually
right. But when the owner phrases a conclusion, definition, or framing better than
a paraphrase would, keep their sentence as a short quotation attributed to them,
beside the distilled point. Their words are worth holding when they hit home. Use
judgement: quote the one sentence that crystallises the idea, not the paragraph
around it.

---

## 5. Writing style

Follow the writing conventions in `OWNER.md`. Where it is silent, these defaults
apply:

- Concrete before abstract. Committed statements over hedged ones.
- No hype. No "revolutionary", "powerful", "seamless", "leverage".
- Short sentences. If a sentence needs two commas to stand up, split it.

---

## 6. How to update the vault

### Adding knowledge
1. Check whether a note already covers the ground. Prefer editing over creating.
2. If creating: write the note, then **register it in the parent `index.md` in the
   same change**. An unregistered note is invisible, because agents navigate by index.
3. Add cross-links, and mirror them in `related`.
4. Bump `updated`. In a project or person note, add a dated timeline entry for
   anything that happened, and rewrite the state above the line to match.
5. Append one line to `log.md`, naming every note you touched.
6. Run `sh bin/vault-doctor.sh` and fix what it reports about your change.
7. Commit the change (see **Git** below).
8. If you believe you cannot reach the vault's files, check which file, shell or
   GitHub tools the session offers before saying so.

### Git

The vault has a remote (a private GitHub repository) and may be used from
several machines and sessions. State can therefore move under you between
sessions.

**At session start, before reading or writing anything:**

```bash
git status --short          # must be clean
git pull
```

If the tree is not clean, **stop and report it**. Someone left work in progress.
Never stash, never discard, never pull over it.

**At the end of a change:**

```bash
git add <only the files you changed>
git commit -m "<what changed and why, one line>"
git pull                   # only now, with a clean tree
git push
```

Commit *before* pulling, always. Pulling into a dirty working tree is the
operation most likely to lose work: git either refuses or merges around your
uncommitted edits in ways that are hard to reason about afterwards. Once the
change is committed, the merge happens between two clean commits and git can do
its job properly.

If the session has been open for more than an hour or so, that end-of-session
pull is not optional. The owner may have written from another machine meanwhile.

One commit per session, not per file. Message in the imperative: "Capture
conclusions from the 2026-05 design review." Stage only the files you
changed. If `git status` shows changes you did not make, stop and report them
rather than committing them alongside your own.

**Never resolve a merge conflict.** If the pull conflicts, the two sides are two
people's knowledge, and picking one silently discards the other. In code that
would be noticed. In a note it would not be, possibly for a year. Stop, name the
conflicted files, leave the repository mid-merge, and let the owner finish it.

**Never run:** `rebase`, `reset --hard`, `checkout -- .`, `clean -fd`,
`stash drop`, or anything with `--force`. Do not add or change remotes, and do
not create branches or tags unless asked.

If `push` is refused by the `pre-push` hook, report what it said and stop. Never
retry with `--no-verify`; that decision is the owner's.

If a commit fails because git has no identity configured, report that and stop.
Do not set one.

**Sessions without an interactive shell.** Some agent sessions reach the
machine only through a non-interactive shell (on macOS, for example, an
AppleScript `do shell script` route). Such a shell has no ssh-agent, so any
remote operation (`pull`, `push`) must name the SSH key explicitly. The clone's
`core.sshCommand`, set by `bin/setup-machine.sh`, does exactly that, so plain
`git pull` and `git push` work on every route. If the setting is ever lost, run
the setup script again. The same sequence and the same prohibitions apply on
every route.

**The pre-push hook.** A hook at `.githooks/pre-push`, activated per machine with
`git config core.hooksPath .githooks`, prints a warning at push time listing any
`sensitivity: confidential` notes in the push. It does not block: confidential
notes are the owner's own professional material and may reach the trusted private
origin. The warning is the statement of care described under "Notes about
people". The hard guarantee for third-party data lives in `.gitignore`, which
keeps `private/` out of the repository entirely.

### Setting up on a new machine

A fresh clone carries the notes, the hook, the scripts and these rules, but not
the local git config, which is per-machine and never pushed. After cloning, run
`sh bin/setup-machine.sh` from the vault root. It is safe to re-run, and it:

1. finds the SSH key GitHub accepts and points the clone at it
   (`core.sshCommand`), so sessions without an ssh-agent can pull and push;
2. activates the hooks: `git config core.hooksPath .githooks`;
3. makes the hook and scripts executable;
4. creates the ignored private area, `private/people/`, if absent.

None of this is committed; it is set once per machine.

### Reaching the vault with no local clone (GitHub connector)

Some sessions have no local working copy and no desktop bridge, most often a
phone or web session. They can still reach the vault through a GitHub connector
(an MCP server with repository access), which talks to the private repository
directly. The connector's GitHub App must be **installed** on the account that
owns the repository, not merely authorised: an authorised-but-not-installed app
can verify identity but reads every path back as 404, which is the failure mode
to recognise here.

Work the same way as any session: read `AGENTS.md` and `index.md` through the
connector first, then the two or three notes you need. Two differences from a
local clone matter. A connector write commits straight to `main` through the API,
so it does not run the `pre-push` hook and does not consult `.gitignore`; keeping
`private/` third-party data out of the repository is then a matter of judgement,
since nothing mechanical is guarding it. The vault doctor still runs on GitHub
after the commit lands, so check the commit's tick or cross before you finish.
And a connector commit moves `main` ahead of any local clone elsewhere, so the machine that holds a clone must
`git pull` before its next push. Prefer a local clone when one exists; use the
connector when it is the only way in.

### Deposit continuously, not at the end

When a project settles a concept, a working recipe, or a dead end, lift that one
thing into `topics/` at the moment it settles. Do not wait for the project to
finish. Waiting means the conclusion is either lost or re-derived later, and it
means the insight cannot work for a different project in the meantime.

Before setting a project to `dormant`, confirm every durable lesson has been
lifted into `topics/`. A project note going quiet with its lessons still inside
it is the main way this vault loses value.

### Keep the link to the substrate reciprocal

A project note must record where its substrate lives: the path in `substrate:`,
and a **Where the detail lives** section naming the two or three files someone
should open first. A bare directory path is not enough, since the point is to
make the reactor navigable, not merely locatable.

The working folder should point back. If you have write access to it, maintain a
short `VAULT.md` at its root naming the vault project note and the topics lifted
from it, so that anyone who starts in the folder finds the compiled layer. If you
do not have write access, say so rather than silently leaving the link one-way.

Substrate paths point outside the vault, so nothing here can validate them and
they will break silently if a folder moves. The project note is the single place
to fix that when it happens.

### Notes about people

One note per person, in `people/`, whether they are a colleague, an intellectual
influence, or both. The `relation:` field discriminates and takes several values
at once, so nobody has to be filed twice or filed wrongly.

Two rules, both firm.

**Never write biography.** An influence note records the owner's relationship to
someone's ideas: which of those ideas they use, which of their own notes they
appear in, the two or three works worth reading, and where they diverge. Career summaries
and life histories fail section 1's test outright, since they can be searched for
in thirty seconds. If you are writing a paragraph that could have come from an
encyclopaedia, delete it and write a link instead.

**Record only what the owner tells you.** Personal details about colleagues and
their families, the names of partners and children in particular, exist here as a
memory aid and for no other purpose. Write down what the owner dictates.
Never look a person up, never infer, never carry a detail across from another
source, and never record anything about health or relationships. The test in
section 3 applies at full strength: would this be defensible if that person read
it?

Person notes default to `sensitivity: confidential`. Since the vault has a
private remote that the owner has decided to trust with their own professional
material, that marking is now a **warning** at push time rather than a block.
Treat it as a statement of care, not a technical guarantee, and do not downgrade
it unless asked.

**Family details go in `private/`, never in `people/`.** The names of partners
and children are third-party personal data about people who did not choose to be
in a GitHub repository, and the owner's trust in the remote is a judgement they
can make for themselves but not on anyone else's behalf. `private/` is listed in `.gitignore`
and does not leave the machine. Keep the person note in `people/` as normal, and
put its `## Personal` content in `private/people/<same-filename>.md` with a link
between the two. If `private/` does not exist, create it: a fresh clone will not
have it, precisely because it is not in the repository.

Create an influence note when the same person is cited in three or more notes, or
when the owner would want an answer to "what else of theirs should I read". Below
that threshold, a mention inside the relevant topic note is enough, and a
`people/` folder full of one-off citations is worse than none.

### Scope every update
Never act on an instruction like "update the vault" without naming the files. An
unscoped rewrite across a large vault burns context, produces churn, and
introduces inconsistencies that are hard to spot in a diff. If the owner asks for a
broad update, propose the specific file list first and get agreement.

### Never delete
Superseded material moves to `archive/`, keeps its file, gains a banner at the
top, and is **removed from the parent `index.md`**. De-indexing is what makes it
invisible to agents while remaining recoverable by a human.

```markdown
> **Superseded 2026-09-01.** Not authoritative. See [new note](../topics/x.md).
```

### Never edit `raw/`
Sources are immutable. If a source is wrong, write a note saying so.

### When unsure, deposit rather than file
If you cannot tell where something belongs, or whether it belongs at all, write
it to `inbox/` with full frontmatter and a `status: active` field, and tell
the owner in your reply that you did. Do not guess at a permanent home. Do not
silently drop it either.

### Health checks

Structural problems are machine-decidable, so a machine reports them and nobody
is asked. `bin/vault-doctor.sh` checks the whole vault: missing `type`,
unregistered notes, broken `related` targets, tags outside the vocabulary,
topic, project and institutional notes nothing links to, people named but not
linked, revisit dates that have passed, active notes untouched for a year, and
state older than its own timeline. Given a commit range it also checks that
every changed note has a `log.md` line and that no timeline entry was edited.

```bash
sh bin/vault-doctor.sh             # the whole vault, warnings only
sh bin/vault-doctor.sh --strict    # exit 1 on any finding
```

It runs in two places. The `pre-push` hook runs it on the range being pushed,
so the pushing session sees the report before anything leaves the machine; like
the confidential warning, it prints and never blocks. GitHub then runs the same
script (`.github/workflows/vault-doctor.yml`) on every push from any source,
connector commits included, and every Monday morning so that passed revisit
dates surface without a push. On GitHub a green tick or red cross appears next
to each commit, and the report is on the run's summary page.

Fix what it reports about your own change before pushing. Findings about notes
you did not touch go into your reply, not into an unscoped clean-up.

---

## 7. How to read the vault

1. Read `index.md`.
2. Pick candidate notes from their one-line descriptions. Open two or three, not twenty.
3. Follow `related` links only when the first pass leaves a gap.
4. **Cite the file path** of anything you use, so the owner can check you.
5. If the vault contradicts what you believe, the vault wins for facts about
   the owner's own work, decisions, and context. Your training wins for general
   knowledge. Where the vault contradicts *itself*, say so rather than picking one.

Search with `grep -r` before assuming something is absent. Filenames are
kebab-case and greppable for exactly this reason.

---

## 8. Conflicts and staleness

A stale vault is worse than no vault, because it looks authoritative. Therefore:

- If you notice a note that contradicts what the owner just told you, flag it in
  your reply and offer to fix it. Do not silently work around it.
- If a note has `status: active` but its `updated` date is more than a year old
  and it describes something time-sensitive, say so.
- Record contradictions explicitly rather than resolving them by fiat:
  "As of 2026-03 the plan was X. As of 2026-07 it is Y, because Z." In a
  project or person note, that sentence is a new timeline entry.

### When the owner says something is wrong

Fix where the error came from, not only where it showed up. Agents draw on
several stores of the owner at once, and a fact corrected in one survives in the
others.

1. Say what was wrong, quoting the claim, and state the correction as they gave it.
2. Search every store you can reach for the wrong claim: this vault (`grep -r`),
   your own memory of the owner, the skills (`skills/` and any installed copies),
   `AGENTS.md`, and any project instructions or files in the session.
3. Classify the source and fix it there:

| Where the error lives | Fix |
|---|---|
| A vault note | Correct the state above the line. In a project or person note, add a dated correction entry below it. |
| An agent's memory | Correct it there, and check whether a vault note seeded it. |
| A skill, `AGENTS.md` or project instructions | Correct the instruction. It reaches every session. |
| Nowhere: the agent combined partial signals | Say which signals, so the next agent is warned. Nothing to fix in the vault. |
| Stale: true once, not now | Supersede with a dated entry. Never overwrite silently. |
| Attributed to the wrong person | Fix both person notes. |

4. Report in one or two lines what you found and where you fixed it. If a store
   is out of reach from this session, say which, so the owner can fix it there.

---

## 9. Naming

- Lowercase kebab-case: `topics/dataset-versioning.md`.
- No dates in filenames except in `raw/`, where the format is
  `YYYY-MM-DD-short-slug.md`.
- One topic per file. If a title needs an "and", it is probably two files.
