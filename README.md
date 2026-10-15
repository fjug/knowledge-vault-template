# Knowledge vault template

A personal knowledge vault that your AI assistants read, write and keep in good
order: plain Markdown files in a private git repository, with rules the
assistants follow, templates, a health check that runs on every push, and two
skills that teach any assistant how to use it. It works with Claude (Claude
Code and the Claude apps), Codex and ChatGPT, and with any other assistant that
reads an `AGENTS.md` file.

The vault holds the **distillate** of your work: settled conclusions, decisions
and why, working recipes, dead ends and why they were dead, and what took effort
to learn about people and institutions. It does not hold the working material
those came from. Every note passes one test: would you otherwise have to work
this out again in six months?

**Contents:** [Set up your vault](#set-up-your-vault) ·
[Install the skills](#install-the-skills) ·
[Using it day to day](#using-it-day-to-day) ·
[What is inside](#what-is-inside) ·
[Questions](#questions)

---

## Set up your vault

You need a GitHub account, git, and one assistant that can run commands in a
folder on your computer: [Claude Code](https://code.claude.com), the Claude
desktop app with your computer linked, or [Codex](https://developers.openai.com/codex).
Setup takes about fifteen minutes, most of it a conversation.

1. **Create your copy.** At the top of this page, press **Use this template**,
   then **Create a new repository**. Choose **Private**: your vault will hold
   confidential material.
2. **Clone it** to where the vault should live, for example your home folder:
   ```bash
   cd ~
   git clone git@github.com:<you>/<your-vault>.git vault
   ```
3. **Let your assistant set it up.** Open Claude Code or Codex in the new
   `vault` folder and say:
   > Read SETUP.md and set this vault up for me.

   The assistant interviews you (who you are, how you write, what the vault is
   for, your starting tags), fills in `OWNER.md`, configures the machine,
   installs the skills on it and makes the first commit.
4. **Check on GitHub.** Your repository page shows a green tick next to the
   first commit once the health check has run. A red cross means the check
   found something; click it to read the report.

On a second computer, clone the same repository and run `sh bin/setup-machine.sh`
and `sh bin/install-skills.sh` there.

---

## Install the skills

The vault ships two skills: short instruction files that teach an assistant
what to do and when.

- **`knowledge-vault`**: check the vault before substantive work, file durable
  conclusions after, keep it healthy, and fix corrected facts where they came
  from.
- **`idea-lineage`**: trace how one of your ideas changed over time, from the
  notes and their git history.

The rules themselves live in `AGENTS.md` inside the vault. The skills make sure
an assistant reaches for the vault at the right moments and reads those rules.

Run this once on every computer that holds a clone (setup does it for you on
the first one):

```bash
sh bin/install-skills.sh
```

It links the skills into the folders Claude Code and Codex read, and packages
each skill as a ZIP in `dist/` for the apps that take an upload.

| Assistant | How it gets the skills | How it reaches the vault |
|---|---|---|
| **Claude Code** | Automatic after `install-skills.sh` (`~/.claude/skills`). Also reads `CLAUDE.md` when started in the vault. | Directly, on the computer. Full read and write. |
| **Codex** (CLI, IDE, ChatGPT desktop app) | Automatic after `install-skills.sh` (`~/.agents/skills`). Reads `AGENTS.md` when started in the vault. | Directly, on the computer. Full read and write. |
| **Claude apps** (web, desktop, mobile) | Upload each ZIP from `dist/` under **Customize > Skills**: press **+**, then **Create skill**, then **Upload a skill**. Code execution must be on. On Team and Enterprise plans an owner may need to allow this, or can install the skills for everyone. | With the desktop app and your computer linked: directly. Otherwise through a GitHub connector, if your plan has one. |
| **ChatGPT** | Skills are in beta and must be enabled for your workspace. In a new chat, say *"Build me a skill from this file"*, paste the contents of a `SKILL.md`, then press **Install**. Use it with `@knowledge-vault`. | Through the GitHub app, mostly read-only. Anything new comes back as files for your `inbox/`. |
| **Anything else** | Point it at `AGENTS.md`, which most coding assistants read by convention. | Whatever file access it has. |

Uploaded copies do not follow the vault. When a skill changes, run
`install-skills.sh` again and upload the new ZIPs. Menus change; if one has
moved, the assistant's own help pages have the current path.

**When the assistant cannot reach your files** (a phone chat without a
connector, say), the skill still works. It produces complete notes as files
for you to drop into `inbox/`, and an assistant with access files them later.

---

## Using it day to day

You do not need to remember commands. Talk normally; the skills recognise
these situations.

| You say | What happens |
|---|---|
| *"What do I know about X?"* · *"Did I decide this already?"* · *"Check my notes first."* | The assistant reads `index.md`, searches, opens two or three notes and tells you what it found, with file paths, before doing the work. |
| *"Remember this."* · *"Add this to the vault."* | It files the conclusion as a topic, project or person note, registers it, links it and logs the change. When unsure where it belongs, it goes to `inbox/` and the assistant says so. |
| Nothing: you just finished something | It should offer to capture a settled decision, a recipe that worked, or a dead end. If it does not, ask: *"Anything here worth keeping?"* |
| *"That's wrong: it was Y, not X."* | It fixes the fact where it came from (a note, its own memory, a skill) and tells you where that was. |
| *"How has my thinking on X changed?"* | `idea-lineage` traces the idea through the notes and their history: first mention, best version, current version, reversals, abandoned branches. |
| *"Triage my inbox."* | It goes through `inbox/` with you, one note at a time: promote, merge or archive. |
| *"Check the vault's health."* | It runs `bin/vault-doctor.sh` and fixes what you agree to. |

**Habits that make it work:**

- **Start substantive work by asking for the vault.** One line, *"check the
  vault first"*, saves re-deriving what you already settled.
- **Capture when something settles, not at the end.** A conclusion filed the
  day it is reached is available to every other project from then on.
- **Keep working material out.** Lab books, runs, drafts and datasets stay in
  their own folders. The vault holds what was learned and a pointer to the
  evidence.
- **Triage the inbox weekly.** Ten minutes. An inbox nobody empties turns into
  a second, worse vault.
- **Look at Monday's check.** GitHub runs the health check every Monday. A red
  cross usually means a `revisit:` date has passed: a note asking to be looked
  at again.
- **Correct out loud.** When an assistant gets something wrong about you, say
  so plainly. The correction then reaches the source, not only that one
  conversation.

**Your first week:** ask an assistant to capture three things you already know
well (a decision you keep re-explaining, a recipe you keep looking up, a person
you work with). Then start a real task with *"check the vault first"* and see
what it finds.

---

## What is inside

| Path | What it is |
|---|---|
| `AGENTS.md` | The rules every assistant follows. The same for every vault made from this template. |
| `OWNER.md` | Who you are and your own conventions. Filled in at setup. |
| `index.md` | The entry point assistants navigate by: vocabularies and the registry of notes. |
| `log.md` | What changed, when and why, newest first. |
| `topics/` `projects/` `people/` `institutional/` | The notes. Topics first: they are where value compounds. |
| `inbox/` | Anything an assistant could not confidently file, waiting for you. |
| `raw/` `archive/` | Immutable sources; superseded notes, kept but hidden from assistants. |
| `private/` | Git-ignored. Third-party personal details that never leave your computer. |
| `_templates/` | Note templates. Project and person notes keep current state above a `<!-- timeline -->` line and a dated, append-only record below it. |
| `skills/` | `knowledge-vault` and `idea-lineage`. |
| `bin/` | `setup-machine.sh`, `install-skills.sh`, `vault-doctor.sh`. |
| `.githooks/` `.github/` | The health check on every push, on your computer and on GitHub, and weekly. |

**The ideas behind it**

- **Distillate, not reactor.** The vault holds what was learned; working folders
  hold the evidence.
- **Assistants navigate by index.** An unregistered note is invisible.
- **State above the line, record below it.** Current state is rewritten; dated
  history is only ever added to.
- **Fix errors at their source.** A corrected fact is traced to wherever it came
  from and fixed there.
- **A machine checks the structure.** Nobody is asked about a missing field or a
  broken link; the health check reports it.
- **When unsure, the inbox.** Assistants never guess at a permanent home and never
  silently drop anything.

---

## Questions

**Why a private repository?** The vault soon holds negotiations, personnel
matters and notes about colleagues. Family details stay out of the repository
altogether, in the git-ignored `private/` folder.

**Do I need Obsidian or another notes app?** No. The vault is plain Markdown and
opens in any editor. It works well as an Obsidian vault if you like one.

**The health check shows a red cross. What now?** Click it to read the report,
or ask an assistant: *"Check the vault's health and fix what you can."* Most
findings take a minute: an unregistered note, a tag missing from the vocabulary,
a link not yet made.

**Can I change the rules?** Yes. Your own conventions belong in `OWNER.md`.
Change `AGENTS.md` only for things you want every assistant to do differently.

**Where does my data go?** Your files stay on your computer and in your private
repository. When an assistant reads a note, that note goes to the assistant's
provider as part of the conversation, as with anything else you show it.

---

## Licence and credits

[MIT](LICENSE). The timeline convention, the correction procedure and the
`idea-lineage` skill are adapted from [GBrain](https://github.com/garrytan/gbrain)
(MIT licence). The rest grew out of a working vault used daily with Claude and
Codex.
