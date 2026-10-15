# SETUP.md — bring the vault to life on a computer

This is a prompt for an AI agent with a shell and access to this folder (Claude
Code, Codex, or Claude with a linked computer). On every computer where the
owner wants the vault, they clone it, open the agent in the clone and say:

> Read SETUP.md and set this vault up for me.

Everything below is addressed to that agent.

---

## Your job

Read `AGENTS.md` in full first: it is the rulebook you are setting up, and it
applies to you from the first file you touch. Then decide which case you are in:

```bash
grep -c '{{' OWNER.md
```

- **A number above 0: a new vault.** Do every step below, in order.
- **0: the vault is already set up**, and this is another computer. Do steps 1,
  4, 5 and 7 only. Do not interview the owner again and do not commit anything.

Do not invent answers. A placeholder left visibly empty is better than a
plausible guess.

## 1. Check the starting point

```bash
git status --short       # should be clean
git remote -v            # should point at the owner's private repository
```

If there is no remote, or the repository is public, stop and say so. The vault
will hold confidential material and must live in a private repository.

## 2. Interview the owner (new vault only)

Ask these in two or three short rounds, not all at once. Keep their words.

1. Name, role, institution, and one or two sentences on their work.
2. Which computers will hold a clone, and where on each (default `~/vault`).
3. Writing conventions: spelling, register, words or punctuation to avoid,
   format preferences. Offer examples; accept "no preference".
4. What they most want the vault to stop them re-deriving: decisions, working
   recipes, reading, people, institutional know-how.
5. Five to fifteen starting tags for their domains, one line of meaning each.
   Propose some from their answer to question 1 and let them edit.
6. Anything that must never go into the vault, beyond the rules in `AGENTS.md`.

## 3. Write what you learned (new vault only)

- `OWNER.md`: replace every `{{...}}` placeholder and the example comments.
- `index.md`: add their tags under **Tag vocabulary**, one line each, and set
  the **Status** line to today's date.
- `skills/knowledge-vault/SKILL.md`: replace `{{VAULT_PATH}}` and
  `{{GITHUB_REPO}}`.
- `log.md`: one line under today's date: "Vault set up from the template."

Then confirm nothing is left:

```bash
grep -rn '{{' --include='*.md' . | grep -v '^./SETUP.md'
```

## 4. Configure this computer

```bash
sh bin/setup-machine.sh
sh bin/vault-doctor.sh
```

The setup script finds the SSH key GitHub accepts, activates the hooks and
creates the ignored `private/` area. The doctor should report the vault clean.

## 5. Install the skills on this computer

```bash
sh bin/install-skills.sh
```

This links both skills into the folders Claude Code (`~/.claude/skills`) and
Codex (`~/.agents/skills`) read, so both see the skills from now on, in any
folder, and packages each skill as a ZIP in `dist/` for the apps that take an
upload.

## 6. First commit (new vault only)

```bash
git add OWNER.md index.md log.md skills/knowledge-vault/SKILL.md
git commit -m "Set up the vault from the template"
git push
```

The `pre-push` hook runs the doctor. On GitHub, the same check runs again and
marks the commit with a tick or a cross (Actions must be enabled for the
repository; they usually are by default).

## 7. Hand over

Tell the owner, in a few lines:

- where the vault is, and that Claude Code and Codex on this computer now use
  it on their own;
- that the first useful thing is to ask an assistant to capture something they
  already know well, and that `inbox/` is where anything uncertain lands for
  them to triage;
- where to read on: the README section **Using it day to day**.

Then ask one question: *do they also use the Claude apps or ChatGPT?* If so,
those need the skills uploaded by hand, once. Walk them through the README
section **Also using the Claude apps or ChatGPT?** step by step, reading the
menu names from it rather than guessing, and point them to the ZIPs in `dist/`.

Delete nothing: leave this file in place for the next computer.
