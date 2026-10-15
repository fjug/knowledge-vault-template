#!/bin/sh
#
# install-skills.sh - make the vault's skills available to your AI assistants.
#
# 1. Links each skill in skills/ into the folders where Claude Code
#    (~/.claude/skills) and Codex (~/.agents/skills) look for them. Links, not
#    copies: when a skill changes in the vault, every assistant on this machine
#    sees the change.
# 2. Packages each skill as a ZIP in dist/ (git-ignored) for the apps that take
#    an upload instead: the Claude apps (Customize > Skills > Upload a skill)
#    and, where your workspace has skills enabled, ChatGPT.
#
# Run it from anywhere inside the vault. Safe to re-run; re-run it and upload
# the ZIPs again after a skill changes.

set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Not inside the vault. Run this from within it." >&2
  exit 1
}
cd "$root"

if grep -rqs '{{' skills/*/SKILL.md; then
  echo "The skills still contain {{...}} placeholders. Run the setup in SETUP.md first." >&2
  exit 1
fi

for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for dir in skills/*/; do
    name=$(basename "$dir")
    [ -f "$dir/SKILL.md" ] || continue
    ln -sfn "$root/skills/$name" "$target/$name"
  done
  echo "Linked into $target"
done

mkdir -p dist
for dir in skills/*/; do
  name=$(basename "$dir")
  [ -f "$dir/SKILL.md" ] || continue
  rm -f "dist/$name.zip"
  if command -v zip >/dev/null 2>&1; then
    (cd skills && zip -qr "../dist/$name.zip" "$name" -x '*.DS_Store')
  else
    python3 - "$name" <<'PY'
import os, sys, zipfile
name = sys.argv[1]
with zipfile.ZipFile(f"dist/{name}.zip", "w", zipfile.ZIP_DEFLATED) as z:
    for base, _, files in os.walk(f"skills/{name}"):
        for f in files:
            if f != ".DS_Store":
                path = os.path.join(base, f)
                z.write(path, os.path.relpath(path, "skills"))
PY
  fi
  echo "Packaged dist/$name.zip"
done

echo
echo "Claude Code and Codex on this machine now see the skills."
echo "For the Claude apps, upload each ZIP in dist/ under Customize > Skills."
echo "See README.md, 'Also using the Claude apps or ChatGPT?', for the uploads."
