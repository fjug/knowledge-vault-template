# Vault index

Entry point for the vault. Agents: read [`AGENTS.md`](AGENTS.md) first, then
[`OWNER.md`](OWNER.md), then this file, then open only the notes you need.

**Status:** template, not yet set up. `SETUP.md` replaces this line.

---

## Map

| Directory | What lives here | Index |
|---|---|---|
| `topics/` | Durable know-how that outlives any single project | [topics/index.md](topics/index.md) |
| `projects/` | Time-bounded efforts, papers, grants, builds | [projects/index.md](projects/index.md) |
| `people/` | Collaborators, students, vendors, counterparts, influences | [people/index.md](people/index.md) |
| `institutional/` | The owner's institution: structures, processes, budgets, committees | [institutional/index.md](institutional/index.md) |
| `raw/` | Immutable sources. Never edited. | [raw/index.md](raw/index.md) |
| `inbox/` | Unfiled deposits awaiting triage | [inbox/index.md](inbox/index.md) |
| `archive/` | Superseded, kept but de-indexed | [archive/index.md](archive/index.md) |

`_templates/` holds note templates. `skills/` holds the agent skills that live
with the vault; see [skills/index.md](skills/index.md). `bin/` holds machine
setup and `vault-doctor.sh`, the health check run on every push.
`attachments/` holds figures and files.

---

## Type vocabulary

`project` · `topic` · `person` · `org` · `decision` · `protocol` · `source` · `session`

Add a type here before using it.

---

## Relation vocabulary

For `people/` notes only. Multi-valued: someone can be several of these at once.

`collaborator` · `student` · `alumnus` · `influence` · `vendor` · `counterpart`

---

## Tag vocabulary

Kept deliberately small. Add a tag here before using it, and prefer an existing
one over a near-synonym. The vault doctor flags any tag not listed.

- `workflow` — repeatable procedures for recurring tasks
- `writing` — writing craft, style, editorial process
- `infrastructure` — machines, hosting, tooling, access
- `leadership` — running a group, mentoring, direction
- `teaching` — courses, workshops and training material
- `reading` — reading lists and what came out of them

---

## Registry

The authoritative list of notes. Format:
`` `path` — **Title** — one-line description ``

### Topics

### Projects

### People

### Institutional

---

## Recent changes

See [`log.md`](log.md).
