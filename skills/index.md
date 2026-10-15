# Skills

Agent skills that live with the vault so they are versioned alongside it.

- [knowledge-vault](knowledge-vault/SKILL.md) — teaches any agent to consult,
  capture into, and maintain this vault.
- [idea-lineage](idea-lineage/SKILL.md) — traces how one of the owner's ideas
  has changed, from the vault and its git history. Read-only.

Install them on every machine that holds a clone:

```bash
sh bin/install-skills.sh
```

It links the skills into `~/.claude/skills` (Claude Code) and `~/.agents/skills`
(Codex) and packages ZIPs in `dist/` for upload to the Claude apps and
ChatGPT. Uploaded copies do not follow the vault: re-run the script and upload
again after a skill changes. Details in the README, **Install the skills**.
