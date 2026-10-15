# Knowledge vault template

A personal knowledge vault that AI agents can read, write and keep in good
order: plain Markdown in a private git repository, with rules the agents
follow, templates, a health check that runs on every push, and two agent
skills.

The vault holds the **distillate** of your work: settled conclusions, decisions
and why, working recipes, dead ends and why they were dead, and what took effort
to learn about people and institutions. It does not hold the working material
those came from. Its test for every note: would you otherwise have to work this
out again in six months?

## Start

1. Press **Use this template** on GitHub and create a **private** repository.
2. Clone it where you want the vault to live, for example `~/vault`.
3. Open Claude Code or Codex in that folder and say:
   *"Read SETUP.md and set this vault up for me."*

The agent interviews you (about ten minutes), fills in `OWNER.md`, configures
the machine, installs the skills and makes the first commit.

## What is inside

| Path | What it is |
|---|---|
| `AGENTS.md` | The rules every agent follows. Shared by every vault from this template. |
| `OWNER.md` | Who you are and your own conventions. Filled in at setup. |
| `index.md` | The entry point agents navigate by: vocabularies and the registry of notes. |
| `log.md` | What changed, when and why, newest first. |
| `topics/` `projects/` `people/` `institutional/` | The notes. Topics first: they are where value compounds. |
| `inbox/` | Anything an agent could not confidently file, waiting for your triage. |
| `raw/` `archive/` | Immutable sources; superseded notes, kept but hidden from agents. |
| `private/` | Git-ignored. Third-party personal details that never leave your machine. |
| `_templates/` | Note templates. Project and person notes keep current state above a `<!-- timeline -->` line and an append-only dated record below it. |
| `skills/` | `knowledge-vault` (consult, capture, maintain) and `idea-lineage` (how one idea changed over time). |
| `bin/` | `setup-machine.sh` and `vault-doctor.sh`. |
| `.githooks/` `.github/` | The doctor on every push, locally and on GitHub, and weekly. |

## The ideas behind it

- **Distillate, not reactor.** Lab books, runs, datasets and drafts stay in their
  working folders; the vault holds what was learned and a pointer to the evidence.
- **Agents navigate by index.** An unregistered note is invisible.
- **State above the line, record below it.** Current state is rewritten; dated
  history is only ever appended to.
- **Fix errors at their source.** A corrected fact is traced to the note, memory
  or instruction it came from and fixed there.
- **Structure is checked by a machine.** Nobody is asked about a missing field
  or a broken link; the doctor reports it.
- **When unsure, the inbox.** Agents never guess at a permanent home and never
  silently drop something.

The timeline convention, the correction procedure and the idea-lineage skill are
adapted from [GBrain](https://github.com/garrytan/gbrain) (MIT licence). The
rest grew out of a working vault used daily with Claude and Codex.
