#!/bin/sh
#
# vault-doctor.sh - mechanical health checks for a knowledge vault.
#
# Structural problems are machine-decidable, so a machine reports them and
# nobody has to be asked. See AGENTS.md section 6 ("Health checks").
#
# Usage, from anywhere inside the vault:
#   sh bin/vault-doctor.sh                  report on the whole vault
#   sh bin/vault-doctor.sh --strict         the same, but exit 1 on any finding
#   sh bin/vault-doctor.sh --range A..B     also check the notes changed between
#                                           commits A and B (the pre-push hook
#                                           passes the range being pushed)
#
# Warn only by default: it always exits 0 unless --strict is given, and the
# pre-push hook never blocks on it.
#
# Whole-vault checks:
#   1. missing type          every note needs `type:` in its frontmatter
#   2. unregistered          every note appears in some index.md
#   3. broken related        every `related:` target exists on disk
#   4. off-vocabulary tags   every tag is listed under "Tag vocabulary" in index.md
#   5. orphans               every topic, project and institutional note has at
#                            least one inbound link from another note
#   6. unlinked mentions     a note naming someone who has a people/ note links
#                            to it (the title, or any of the person's `aliases:`)
#   7. revisit overdue       a `revisit:` date in the past
#   8. stale active          `status: active` with `updated` over a year old
#   9. state behind record   a "## State as of" date older than the newest
#                            entry below the `<!-- timeline -->` marker
#
# Range checks (--range):
#  10. no log line           every note changed in the range is named in log.md
#  11. timeline edited       nothing below a `<!-- timeline -->` marker was
#                            changed or removed; that zone is append-only
#
# Portable sh, awk, grep and sed: runs on macOS, Linux and GitHub Actions alike.

set -u

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "vault-doctor: not inside the vault, nothing checked." >&2
  exit 0
}
cd "$root" || exit 0

strict=0
range=''
while [ $# -gt 0 ]; do
  case "$1" in
    --strict) strict=1 ;;
    --range)  shift; range=${1:-} ;;
    *) echo "vault-doctor: unknown option $1" >&2 ;;
  esac
  shift
done

today=$(date +%Y-%m-%d)
year_ago=$(awk -v t="$today" 'BEGIN { print (substr(t,1,4) - 1) substr(t,5) }')
tmp=$(mktemp -d 2>/dev/null || mktemp -d -t vaultdoctor)
trap 'rm -rf "$tmp"' EXIT INT TERM
findings=0

# --- helpers -----------------------------------------------------------------

# fm FILE KEY: the scalar value of KEY in FILE's frontmatter.
fm() {
  awk -v k="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---"  { exit }
    NR > 1 && index($0, k ":") == 1 {
      s = $0; sub("^" k ":[ \t]*", "", s); sub(/[ \t]+#.*$/, "", s); print s; exit
    }' "$1"
}

# fmlist FILE KEY: the items of list KEY, inline [a, b] or block "  - a" form.
fmlist() {
  awk -v k="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---"  { exit }
    NR > 1 && blk {
      if ($0 ~ /^[ \t]+- /) {
        s = $0; sub(/^[ \t]+- [ \t]*/, "", s); sub(/[ \t]+#.*$/, "", s)
        gsub(/^["'\'']|["'\'']$/, "", s); if (s != "") print s; next
      }
      blk = 0
    }
    NR > 1 && index($0, k ":") == 1 {
      s = $0; sub("^" k ":[ \t]*", "", s); sub(/[ \t]+#.*$/, "", s)
      if (s ~ /^\[/) {
        gsub(/[][]/, "", s); n = split(s, a, ",")
        for (i = 1; i <= n; i++) {
          t = a[i]; gsub(/^[ \t"'\'']+|[ \t"'\'']+$/, "", t); if (t != "") print t
        }
      } else if (s == "") blk = 1
      else print s
    }' "$1"
}

# report TITLE FILE: print a section if FILE has lines, and count them.
report() {
  if [ -s "$2" ]; then
    n=$(wc -l < "$2" | tr -d ' ')
    findings=$((findings + n))
    echo "$1 ($n)"
    sed 's/^/  /' "$2"
  fi
}

# --- the note set ------------------------------------------------------------

find topics projects people institutional inbox -name '*.md' ! -name index.md \
  2>/dev/null | sort > "$tmp/notes"
grep -v '^people/' "$tmp/notes" > "$tmp/nonpeople"
grep -E '^(topics|projects|institutional)/' "$tmp/notes" > "$tmp/linkable"
cat index.md */index.md > "$tmp/indexes" 2>/dev/null
awk '/^## Tag vocabulary/ { t = 1; next } /^## / { t = 0 }
     t && /^- `/ { s = $0; sub(/^- `/, "", s); sub(/`.*/, "", s); print s }' \
  index.md > "$tmp/vocab"

: > "$tmp/c1"; : > "$tmp/c2"; : > "$tmp/c3"; : > "$tmp/c4"
: > "$tmp/c5"; : > "$tmp/c6"; : > "$tmp/c7"; : > "$tmp/c8"; : > "$tmp/c9s"

while read -r f; do
  b=$(basename "$f")
  d=$(dirname "$f")

  # 1. missing type
  [ -n "$(fm "$f" type)" ] || echo "$f" >> "$tmp/c1"

  # 2. unregistered
  grep -qF "$b" "$tmp/indexes" || echo "$f" >> "$tmp/c2"

  # 3. broken related
  fmlist "$f" related | while read -r t; do
    case "$t" in http*|'') continue ;; esac
    [ -e "$d/$t" ] || echo "$f -> $t"
  done >> "$tmp/c3"

  # 4. off-vocabulary tags
  fmlist "$f" tags | while read -r t; do
    grep -qxF "$t" "$tmp/vocab" || echo "$f: $t"
  done >> "$tmp/c4"

  # 7. revisit overdue
  r=$(fm "$f" revisit | cut -c1-10)
  case "$r" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])
      awk -v a="$r" -v b="$today" 'BEGIN { exit !(a < b) }' \
        && echo "$f: revisit was due $r ($(fm "$f" revisit | cut -c12- | sed 's/^[ ,;:]*//'))" >> "$tmp/c7"
      ;;
  esac

  # 8. stale active
  if [ "$(fm "$f" status)" = active ]; then
    u=$(fm "$f" updated | cut -c1-10)
    [ -n "$u" ] && awk -v a="$u" -v b="$year_ago" 'BEGIN { exit !(a < b) }' \
      && echo "$f: active, last updated $u" >> "$tmp/c8"
  fi

  # 9. state behind record
  if grep -qxF '<!-- timeline -->' "$f"; then
    sd=$(grep -m1 '^## State as of [0-9]' "$f" | sed 's/^## State as of //' | cut -c1-10)
    td=$(awk '
      seen && match($0, /\*\*[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\*\*/) {
        print substr($0, RSTART + 2, 10)
      }
      $0 == "<!-- timeline -->" { seen = 1 }' "$f" | sort | tail -1)
    [ -n "$sd" ] && [ -n "$td" ] && awk -v a="$sd" -v b="$td" 'BEGIN { exit !(a < b) }' \
      && echo "$f: state as of $sd, newest timeline entry $td" >> "$tmp/c9s"
  fi
done < "$tmp/notes"

# 5. orphans: inbound links from any other note (frontmatter or body).
while read -r f; do
  b=$(basename "$f")
  xargs grep -lF "$b" < "$tmp/notes" 2>/dev/null | grep -vxF "$f" | grep -q . \
    || echo "$f" >> "$tmp/c5"
done < "$tmp/linkable"

# 6. unlinked mentions of people who have a note: the title, plus any
#    `aliases:` the person note declares (a surname for an influence cited
#    academic-style, say). Whole words, case-sensitive.
for p in people/*.md; do
  [ "$(basename "$p")" = index.md ] && continue
  name=$(fm "$p" title)
  [ -n "$name" ] || continue
  pb=$(basename "$p")
  { echo "$name"; fmlist "$p" aliases; } > "$tmp/names"
  : > "$tmp/hits"
  while IFS= read -r n; do
    [ -n "$n" ] && xargs grep -lwF -- "$n" < "$tmp/nonpeople" >> "$tmp/hits" 2>/dev/null
  done < "$tmp/names"
  sort -u "$tmp/hits" | while read -r f; do
    grep -qF "$pb" "$f" || echo "$f names $name without linking $p"
  done
done >> "$tmp/c6"

# --- range checks ------------------------------------------------------------

: > "$tmp/c9"; : > "$tmp/c10"
if [ -n "$range" ]; then
  a=${range%%..*}
  z=${range##*..}
  case "$a" in
    ''|0000000000000000000000000000000000000000)
      git diff-tree --no-commit-id --name-only -r "$z" > "$tmp/changed" ;;
    *)
      git diff --name-only "$a" "$z" > "$tmp/changed" ;;
  esac
  git show "$z:log.md" > "$tmp/log" 2>/dev/null || : > "$tmp/log"

  grep -E '^(topics|projects|people|institutional|inbox)/.*\.md$' "$tmp/changed" \
    | grep -v '/index\.md$' | while read -r f; do
    git cat-file -e "$z:$f" 2>/dev/null || continue

    # 10. no log line
    grep -qF "$f" "$tmp/log" || echo "$f" >> "$tmp/c9"

    # 11. timeline edited
    case "$a" in ''|0000000000000000000000000000000000000000) continue ;; esac
    git show "$a:$f" > "$tmp/old" 2>/dev/null || continue
    grep -qxF '<!-- timeline -->' "$tmp/old" || continue
    git show "$z:$f" > "$tmp/new"
    awk 'seen && NF { print } $0 == "<!-- timeline -->" { seen = 1 }' "$tmp/old" \
      | while IFS= read -r line; do
          grep -qxF -- "$line" "$tmp/new" || echo "$f: changed or removed: $line"
        done >> "$tmp/c10"
  done
fi

# --- report ------------------------------------------------------------------

{
  report "Missing type" "$tmp/c1"
  report "Not registered in any index.md" "$tmp/c2"
  report "Broken related targets" "$tmp/c3"
  report "Tags not in the index.md vocabulary" "$tmp/c4"
  report "Orphans: no other note links here" "$tmp/c5"
  report "People named but not linked" "$tmp/c6"
  report "Revisit dates passed" "$tmp/c7"
  report "Active but not updated for a year" "$tmp/c8"
  report "State older than its own timeline" "$tmp/c9s"
  report "Changed notes with no log.md line" "$tmp/c9"
  report "Timeline entries edited (append only)" "$tmp/c10"
} > "$tmp/out"

total=$(wc -l < "$tmp/notes" | tr -d ' ')
if [ "$findings" -eq 0 ]; then
  echo "vault-doctor: clean ($total notes checked)."
else
  echo "vault-doctor: $findings finding(s) in $total notes."
  cat "$tmp/out"
fi

[ "$strict" -eq 1 ] && [ "$findings" -gt 0 ] && exit 1
exit 0
