#!/bin/sh
#
# setup-machine.sh - bring a fresh clone of the vault up on a new machine.
#
# Sets the per-machine git config that is never pushed (the SSH key for
# sessions without an ssh-agent, and the hooks path), makes the scripts
# executable, and creates the ignored private/ area. Safe to re-run.
# See AGENTS.md section 6 ("Setting up on a new machine").

set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Not inside a git working tree. Run this from within the vault." >&2
  exit 1
}
cd "$root"

# 1. SSH key. Only relevant when the remote is reached over SSH.
remote=$(git remote get-url origin 2>/dev/null || true)
case "$remote" in
  git@*|ssh://*)
    host=$(printf '%s' "$remote" | sed -E 's#^(ssh://)?([^@]+@)?([^:/]+).*#\3#')
    found_key=''
    for key in "$HOME"/.ssh/*; do
      case "$key" in
        *.pub|*known_hosts*|*/config|*.txt|*.json|*.ppk|*/authorized_keys) continue ;;
      esac
      [ -f "$key" ] || continue
      reply=$(ssh -i "$key" -o IdentitiesOnly=yes -o BatchMode=yes \
                  -o StrictHostKeyChecking=accept-new -T "git@$host" 2>&1 || true)
      case "$reply" in
        *"successfully authenticated"*|*"Welcome to"*)
          found_key=$key
          break ;;
      esac
    done
    if [ -n "$found_key" ]; then
      git config core.sshCommand "ssh -i $found_key -o IdentitiesOnly=yes"
      echo "1. SSH key for $host: $found_key"
    else
      echo "1. No key without a passphrase was accepted by $host." >&2
      echo "   Interactive git will still work through your ssh-agent. For" >&2
      echo "   sessions without one, set the key by hand:" >&2
      echo "   git config core.sshCommand 'ssh -i ~/.ssh/<key> -o IdentitiesOnly=yes'" >&2
    fi
    ;;
  '')
    echo "1. No remote named origin yet; skipped the SSH key." ;;
  *)
    echo "1. Remote is not SSH ($remote); no key needed." ;;
esac

# 2. Hooks.
git config core.hooksPath .githooks
echo "2. Hooks active from .githooks/"

# 3. Executable bits, which some upload routes lose.
chmod +x .githooks/* bin/*.sh 2>/dev/null || true
echo "3. Scripts executable"

# 4. The ignored private area.
mkdir -p private/people
echo "4. private/people/ ready (git-ignored)"

echo
echo "Done. Check the vault with: sh bin/vault-doctor.sh"
