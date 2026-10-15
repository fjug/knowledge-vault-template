# Skills

Agent skills that live with the vault so they are versioned alongside it.

- [knowledge-vault](knowledge-vault/SKILL.md) — teaches any agent to consult,
  capture into, and maintain this vault.
- [idea-lineage](idea-lineage/SKILL.md) — traces how one of the owner's ideas
  has changed, from the vault and its git history. Read-only.

Install them on every machine that holds a clone (`SETUP.md` step 5):

```bash
for s in knowledge-vault idea-lineage; do
  ln -sfn "$PWD/skills/$s" ~/.claude/skills/$s
  ln -sfn "$PWD/skills/$s" ~/.codex/skills/$s
done
```

Copies uploaded to claude.ai are separate and do not follow the vault. Update
them from the folders here when a skill changes.
