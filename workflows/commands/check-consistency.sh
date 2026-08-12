#!/usr/bin/env bash
# Consistency checker for OpenCode Workbench.
#
# Runs the deterministic (mechanical) checks defined by docs/conventions.md
# (and the agent org-chart rules of docs/organization.md, ADR-0005).
# Semantic checks (language per resource type, SDD process coherence, links,
# conceptual organization) are documented in
# workflows/commands/check-consistency.md and require human/AI review.
#
# Usage (from the repository root):
#   ./workflows/commands/check-consistency.sh [repo-root]
#
# Exit code 0: all checks pass. 1: at least one check failed.
#
# The scan ignores .git and node_modules (content not versioned in the
# repository, so it must not affect the consistency result).
#
# Requirements: Bash 4+ and GNU coreutils (realpath -m, grep --exclude-dir,
# find -print0). Not portable to macOS/BSD without GNU coreutils installed.

set -u

if [[ ${BASH_VERSINFO[0]:-0} -lt 4 ]] || ! realpath -m -- / >/dev/null 2>&1; then
  echo "Se requiere Bash 4+ y GNU coreutils (realpath -m)" >&2
  exit 2
fi

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
ROOT=$(realpath -m -- "$ROOT")
ROOT=${ROOT%/}
PASS=0
FAILURES=0

# Exclude the command's own documentation: it may legitimately reference the
# exact terms these checks detect (e.g. "Test data").
grep_md() {
  grep -rInE --include='*.md' --exclude-dir='.git' \
    --exclude-dir='node_modules' \
    --exclude='check-consistency.md' \
    "$1" "$ROOT" 2>/dev/null || true
}

# Same as grep_md but excluding English-only resource directories (templates/,
# examples/), whose content legitimately uses the English terms these checks
# flag when they appear in Spanish prose (e.g. "edge cases").
grep_md_es() {
  grep -rInE --include='*.md' --exclude-dir='.git' \
    --exclude-dir='node_modules' \
    --exclude='check-consistency.md' \
    --exclude-dir='templates' --exclude-dir='examples' \
    "$1" "$ROOT" 2>/dev/null || true
}

check_pattern() {
  local label="$1"
  local pattern="$2"
  local matches
  matches=$(grep_md "$pattern")
  if [[ -n "$matches" ]]; then
    FAILURES=$((FAILURES + 1))
    echo "FAIL: $label"
    printf '%s\n' "$matches"
  else
    PASS=$((PASS + 1))
    echo "PASS: $label"
  fi
}

check_pattern_es() {
  local label="$1"
  local pattern="$2"
  local matches
  matches=$(grep_md_es "$pattern")
  if [[ -n "$matches" ]]; then
    FAILURES=$((FAILURES + 1))
    echo "FAIL: $label"
    printf '%s\n' "$matches"
  else
    PASS=$((PASS + 1))
    echo "PASS: $label"
  fi
}

# Reports a check that produces a list of violations (newline-separated in $2).
report() {
  local label="$1"
  local out="$2"
  if [[ -n "$out" ]]; then
    FAILURES=$((FAILURES + 1))
    echo "FAIL: $label"
    printf '%s\n' "$out"
  else
    PASS=$((PASS + 1))
    echo "PASS: $label"
  fi
}

# Returns 0 if the file declares frontmatter (an opening '---' fence on the
# first non-blank line plus a closing fence), tolerating a UTF-8 BOM and
# leading blank lines.
has_frontmatter() {
  local file="$1"
  awk '
    NR==1{sub(/^\357\273\277/, "")}
    opened == "" {
      if ($0 ~ /^[[:space:]]*$/) next
      if ($0 ~ /^---[[:space:]]*$/) { opened = 1; next }
      exit 1
    }
    $0 ~ /^---[[:space:]]*$/ { n++ }
    n >= 1 { found = 1; exit }
    END { if (!found) exit 1 }
  ' "$file"
}

# Returns 0 if the file declares a frontmatter field, tolerating spaces
# around the colon and a UTF-8 BOM.
frontmatter_has_field() {
  local file="$1" field="$2"
  awk -v f="$field" '
    NR==1{sub(/^\357\273\277/, "")}
    /^---[[:space:]]*$/{n++}
    n>=2{exit}
    n==1 && match($0, "^[[:space:]]*" f "[[:space:]]*:"){found=1; exit}
    END{if(!found) exit 1}
  ' "$file"
}

# Returns the value of a single-line frontmatter field.
frontmatter_field() {
  local file="$1" field="$2"
  awk -v f="$field" '
    NR==1{sub(/^\357\273\277/, "")}
    /^---[[:space:]]*$/{n++}
    n>=2{exit}
    n==1 && match($0, "^[[:space:]]*" f "[[:space:]]*:"){sub(/^[^:]+:[[:space:]]*/, ""); print; exit}
  ' "$file"
}

# Returns each element of a bracket-list frontmatter field (e.g. [a, b]).
frontmatter_list() {
  local file="$1" field="$2"
  local line
  line=$(frontmatter_field "$file" "$field")
  [[ -z "$line" ]] && return 0
  echo "$line" | tr -d '[]' | tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | grep -v '^$' || true
}

echo "Consistency check for: $ROOT"
echo

# 1. Terminology: the methodology is "Specification-Driven Development".
check_pattern "Terminology: 'Specification-Driven Development' (not 'Spec-Driven')" "Spec-Driven"

# 1b. Terminology: the pre-implementation gate is "puerta pre-implementación".
check_pattern "Terminology: 'puerta pre-implementación' (not 'puerta previa'/'puerta de calidad')" "puerta (previa|de calidad)"

# 1c. Terminology: the conformance check is "validación de conformidad".
check_pattern "Terminology: 'validación de conformidad' (not 'check de conformidad')" "check de conformidad"

# 1d. Terminology: the post-implementation validation is "validación de conformidad".
check_pattern "Terminology: 'validación de conformidad' (not 'Conformidad post-implementación')" "Conformidad post-implementación"

# 1e. Terminology: the rate-limiting example uses "configured limit", not "capacity".
check_pattern "Example terminology: 'configured limit' (not 'capacity' in burst criteria)" "burst[[:space:]]+(up to|exceeding)[[:space:]]+capacity|equals[[:space:]]+the[[:space:]]+capacity"

# 1f. OpenCode install paths use plural dirs (commands/, agents/), not the legacy
# singular (command/, agent/) which OpenCode only keeps for backwards compatibility.
check_pattern "OpenCode install paths: plural 'commands/'/'agents/' (not singular 'command/'/'agent/')" "opencode/(command|agent)/"

# 2. No mixed Spanish/English phrases like "specify ->".
check_pattern "No mixed-language phrase 'specify ->'" "specify[[:space:]]*->"

# 2b. No "edge cases" in Spanish prose (use 'casos límite').
check_pattern_es "No 'edge cases' in Spanish prose (use 'casos límite')" "edge cases"

# 2c. No "la feature" in Spanish prose (use 'la funcionalidad').
check_pattern_es "No 'la feature' in Spanish prose (use 'la funcionalidad')" "la feature"

# 3. No obsolete auxiliary resource "Test data".
check_pattern_es "No auxiliary resource 'Test data'" "Test data"

# 4. Documentation titles in Spanish: "Documentación específica".
check_pattern "Spanish documentation title 'Documentación específica'" "Documentation[[:space:]]+específica"

# 5. Resource type headings use Title Case.
check_pattern "Headings Title Case: '## / ### Skills, Agents, Commands, MCPs'" "^#{2,3} (skills|agents|commands|mcps)([[:space:]]*)$"
check_pattern "No singular type headings: '## / ### Skill, Agent, Command, MCP'" "^#{2,3} (Skill|Agent|Command|MCP)([[:space:]]*)$"

# 6. Type enumerations must include mcp.
# Limitation: only lines containing the exact enumeration phrases below are
# validated; enumerations written with different wording (e.g. "y"/"and", or
# "mcp" listed on a separate line) are not detected.
for base in "skill, agent, command" "skills, agents, commands"; do
  enum_violations=$(grep_md "$base" | grep -viE 'mcp')
  if [[ -n "$enum_violations" ]]; then
    FAILURES=$((FAILURES + 1))
    echo "FAIL: Type enumeration must include 'mcp': $base"
    echo "$enum_violations"
  else
    PASS=$((PASS + 1))
    echo "PASS: Type enumeration includes 'mcp': $base"
  fi
done

# 7. No trailing whitespace in Markdown files.
check_pattern "No trailing whitespace in Markdown" "[[:blank:]]+$"

# 8. Markdown files must not be executable.
exec_violations=""
while IFS= read -r -d '' file; do
  if [[ -x "$file" ]]; then
    exec_violations="${exec_violations}${file}"$'\n'
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
if [[ -n "$exec_violations" ]]; then
  FAILURES=$((FAILURES + 1))
  echo "FAIL: Markdown files must not be executable"
  printf '%s' "$exec_violations"
else
  PASS=$((PASS + 1))
  echo "PASS: Markdown files are not executable"
fi

# 9. No broken relative links in Markdown files.
# Resolves every relative target ([](...) and [id]: ...) to a canonical path
# relative to its referencing file and verifies the target exists.
# Absolute URLs, mailto, anchors, fragments and root-relative paths (-vel code
# spans) are ignored; directory links count as existing.
link_targets() {
  grep -oE '\]\([^)]+\)|\]:[[:space:]]*[^[:space:]]+' "$1" \
    | sed -E 's/^\]\((.*)\)$/\1/; s/^]:[[:space:]]+//' \
    | sed -E 's/[[:space:]]+"[^"]*"$//' \
    | tr -d '"' \
    | grep -vE '^(https?|mailto|ftp):' \
    | grep -vE '^#' \
    | grep -vE '\.\.\.' \
    | grep -vE '^$' \
    || true
}

link_violations=""
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    case "$target" in
      http://*|https://*|mailto:*|ftp://*|'#*'|'/*'|'<*') continue ;;
    esac
    target="${target%%#*}"
    [[ -z "$target" ]] && continue
    if [[ ! -e "$dir/$target" ]]; then
      link_violations="${link_violations}${file}: $target"$'\n'
    fi
  done < <(link_targets "$file")
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
report "No broken relative links in Markdown" "$link_violations"

# 10. Mandatory frontmatter fields in resources that declare frontmatter.
metadata_violations=""
while IFS= read -r -d '' file; do
  if has_frontmatter "$file"; then
    for field in name type version status purpose tags; do
      if ! frontmatter_has_field "$file" "$field"; then
        metadata_violations="${metadata_violations}${file}: missing '$field'"$'\n'
      fi
    done
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
report "Resources with frontmatter have mandatory metadata fields (name, type, version, status, purpose, tags)" "$metadata_violations"

# 11. Valid status values in frontmatter (ficha 3: draft, experimental, stable, deprecated, archived).
status_violations=""
while IFS= read -r -d '' file; do
  st=$(frontmatter_field "$file" status | tr -d '"')
  if [[ -n "$st" ]] && ! echo "$st" | grep -qxE 'draft|experimental|stable|deprecated|archived'; then
    status_violations="${status_violations}${file}: invalid status '$st'"$'\n'
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
report "Resources declare a valid 'status' value" "$status_violations"

# 12. Orphan Markdown files: not linked from any other Markdown resource.
# A file is referenced if another file links it (by path) or links one of its
# ancestor directories. Entry points that are never legitimately referenced are
# explicitly allowlisted (root README, roadmap, ADRs).
ORPHAN_ALLOWLIST=(
  "README.md"
  "docs/roadmap.md"
  "docs/decisions/"
)
# Build the set of canonically-referenced paths (files and directories).
declare -A referenced_targets
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    case "$target" in
      http://*|https://*|mailto:*|ftp://*|'#*'|'<*') continue ;;
    esac
    target="${target%%#*}"
    [[ -z "$target" ]] && continue
    # Normalize ../ and ./ segments with a string rewrite (canonical enough).
    abs=$(realpath -m -- "$dir/$target" 2>/dev/null)
    [[ -z "$abs" ]] && continue
    referenced_targets["$abs"]=1
  done < <(link_targets "$file")
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)

orphan_violations=""
while IFS= read -r -d '' file; do
  rel=${file#"$ROOT"/}
  skip=0
  for allow in "${ORPHAN_ALLOWLIST[@]}"; do
    if [[ "$rel" == "$allow" || "$rel" == "$allow/"* ]]; then
      skip=1
      break
    fi
  done
  [[ $skip -eq 1 ]] && continue
  abs=$(realpath -- "$file")
  referenced=0
  if [[ -n "${referenced_targets[$abs]:-}" ]]; then
    referenced=1
  fi
  # Also referenced if any ancestor directory is referenced.
  if [[ $referenced -eq 0 ]]; then
    d=$(dirname "$abs")
    while [[ "$d" != "$ROOT" && "$d" != "/" ]]; do
      if [[ -n "${referenced_targets[$d]:-}" ]]; then
        referenced=1
        break
      fi
      d=$(dirname "$d")
    done
  fi
  if [[ $referenced -eq 0 ]]; then
    orphan_violations="${orphan_violations}${rel}"$'\n'
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
report "No orphan Markdown resources (excluding allowlist)" "$orphan_violations"

# 15. No public IPv4 addresses in Markdown (potential operator infrastructure
# leak). Private, loopback, link-local, documentation and CGNAT ranges are
# allowed as examples; any other address is flagged.
ip_is_public() {
  local o1=$1 o2=$2 o3=$3 o4=$4 o
  for o in "$o1" "$o2" "$o3" "$o4"; do
    [[ "$o" =~ ^[0-9]{1,3}$ ]] || return 1
    (( 10#$o > 255 )) && return 1
  done
  (( 10#$o1 == 0 || 10#$o1 == 10 || 10#$o1 == 127 )) && return 1      # this/private/loopback
  (( 10#$o1 == 169 && 10#$o2 == 254 )) && return 1                    # link-local
  (( 10#$o1 == 172 && 10#$o2 >= 16 && 10#$o2 <= 31 )) && return 1     # RFC 1918
  (( 10#$o1 == 192 && 10#$o2 == 168 )) && return 1                    # RFC 1918
  (( 10#$o1 == 100 && 10#$o2 >= 64 && 10#$o2 <= 127 )) && return 1    # CGNAT
  (( 10#$o1 == 192 && 10#$o2 == 0 && (10#$o3 == 0 || 10#$o3 == 2) )) && return 1  # IETF / TEST-NET-1
  (( 10#$o1 == 198 && 10#$o2 == 51 && 10#$o3 == 100 )) && return 1    # TEST-NET-2
  (( 10#$o1 == 203 && 10#$o2 == 0 && 10#$o3 == 113 )) && return 1     # TEST-NET-3
  (( 10#$o1 >= 224 )) && return 1                                     # multicast/reserved/broadcast
  return 0
}

public_ip_violations=""
while IFS= read -r -d '' file; do
  while IFS= read -r ip; do
    [[ -z "$ip" ]] && continue
    IFS=. read -r p1 p2 p3 p4 <<< "$ip"
    if ip_is_public "$p1" "$p2" "$p3" "$p4"; then
      public_ip_violations="${public_ip_violations}${file}: $ip"$'\n'
    fi
  done < <(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$file" 2>/dev/null || true)
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
report "No public IPv4 addresses in Markdown" "$public_ip_violations"

# 16. Operator-specific tokens/IPs/aliases must not appear (leak protection).
# Reads a gitignored list file; skipped when absent (public clones, CI).
SECRETS_FILE="$ROOT/.operator-secrets"
secret_violations=""
if [[ -f "$SECRETS_FILE" ]]; then
  while IFS= read -r token; do
    [[ -z "$token" || "$token" == \#* ]] && continue
    # Tokens shorter than 6 chars produce substring false positives in prose.
    if [[ ${#token} -lt 6 ]]; then
      echo "WARN: token demasiado corto (${#token} chars < 6), se omite" >&2
      continue
    fi
    matches=$(grep -rInF --exclude-dir='.git' --exclude-dir='node_modules' --exclude='.operator-secrets' -- "$token" "$ROOT" 2>/dev/null || true)
    if [[ -n "$matches" ]]; then
      # Mask the exact token value within the matched lines (grep -F matched it
      # literally, so the substitution must be literal too).
      masked_matches=${matches//"$token"/***}
      secret_violations="${secret_violations}token: ${token:0:2}… (${#token} chars)"$'\n'"$masked_matches"$'\n'
    fi
  done < "$SECRETS_FILE"
  report "No operator tokens leaked in the repository" "$secret_violations"
else
  PASS=$((PASS + 1))
  echo "PASS: No operator tokens leaked (skip: .operator-secrets absent)"
fi

# 13. No empty directories without a .gitkeep placeholder (Git does not track
# empty directories).
empty_dir_violations=""
while IFS= read -r -d '' dir; do
  if [[ ! -e "$dir/.gitkeep" ]]; then
    empty_dir_violations="${empty_dir_violations}${dir#"$ROOT"/}"$'\n'
  fi
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -type d -empty -print0)
report "No empty directories without .gitkeep" "$empty_dir_violations"

# 14. No explicit references to non-existent files/assets in project prose.
# Only canonical repo-relative references (./ or ../ or a domain root) are
# verified. References inside templates/ and examples/ are exempt: they
# legitimately describe project artifacts (e.g. src/rate-limiter.js, path/to/file)
# that do not exist in the Workbench repository.
missing_ref_violations=""
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  # Skip templates and examples: their prose references project files.
  case "$file" in
    "$ROOT/templates/"*|"$ROOT/examples/"*|"$ROOT/core/sdd/templates/"*|"$ROOT/core/sdd/examples/"*) continue ;;
  esac
  while IFS= read -r ref; do
    case "$ref" in
      http://*|https://*|mailto:*|ftp://*|'#*') continue ;;
    esac
    ref="${ref%%#*}"
    case "$ref" in
      ./*|../*) ;;
      core/*|technologies/*|workflows/*|docs/*) ;;
      *) continue ;;
    esac
    [[ -e "$dir/$ref" ]] || missing_ref_violations="${missing_ref_violations}${file}: $ref"$'\n'
  done < <(grep -oE '\`[^ \`]+\`' "$file" | tr -d '\`' || true)
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -path '*/node_modules' -prune -o -name '*.md' -type f -print0)
report "Markdown inline code references resolve to existing files" "$missing_ref_violations"

# --- Agent org chart governance (ADR-0005): checks 17-22 -------------------
# Applies to resources in workflows/agents/. Implements the org-chart model
# defined in docs/organization.md: role (orchestrator/process/specialist),
# mode coherence, delegation (delegates_to) and knowledge (skills).

# 17. Agents declare full frontmatter (common metadata + mode, role, description).
agent_meta_violations=""
while IFS= read -r -d '' file; do
  for field in name type version status purpose tags mode role description; do
    if ! frontmatter_has_field "$file" "$field"; then
      agent_meta_violations="${agent_meta_violations}${file}: missing '$field'"$'\n'
    fi
  done
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agents declare full frontmatter (name, type, version, status, purpose, tags, mode, role, description)" "$agent_meta_violations"

# 17b. Agents declare type: agent.
agent_type_violations=""
while IFS= read -r -d '' file; do
  t=$(frontmatter_field "$file" type)
  if [[ -n "$t" && "$t" != "agent" ]]; then
    agent_type_violations="${agent_type_violations}${file}: type '$t' (expected 'agent')"$'\n'
  fi
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agents declare type: agent" "$agent_type_violations"

# 18. Agents declare a valid mode (primary, subagent, all).
mode_violations=""
while IFS= read -r -d '' file; do
  m=$(frontmatter_field "$file" mode)
  if [[ -n "$m" ]] && ! echo "$m" | grep -qxE 'primary|subagent|all'; then
    mode_violations="${mode_violations}${file}: invalid mode '$m'"$'\n'
  fi
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agents declare a valid 'mode' (primary, subagent, all)" "$mode_violations"

# 19. Agent name matches the kebab-case filename.
name_violations=""
while IFS= read -r -d '' file; do
  base=$(basename "$file")
  n=$(frontmatter_field "$file" name)
  if ! echo "$base" | grep -qxE '[a-z0-9]+(-[a-z0-9]+)*\.md'; then
    name_violations="${name_violations}${file}: filename not kebab-case"$'\n'
  fi
  if [[ -n "$n" && "$n" != "${base%.md}" ]]; then
    name_violations="${name_violations}${file}: name '$n' != filename"$'\n'
  fi
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agent 'name' matches the kebab-case filename" "$name_violations"

# 20. Agents declare a valid role coherent with mode.
role_violations=""
while IFS= read -r -d '' file; do
  r=$(frontmatter_field "$file" role)
  m=$(frontmatter_field "$file" mode)
  if [[ -n "$r" ]] && ! echo "$r" | grep -qxE 'orchestrator|process|specialist'; then
    role_violations="${role_violations}${file}: invalid role '$r'"$'\n'
  fi
  case "$r" in
    orchestrator) [[ "$m" == "primary" || "$m" == "all" ]] || role_violations="${role_violations}${file}: role 'orchestrator' requires mode primary/all (found '$m')"$'\n' ;;
    process) [[ "$m" == "all" ]] || role_violations="${role_violations}${file}: role 'process' requires mode all (found '$m')"$'\n' ;;
    specialist) [[ "$m" == "subagent" || "$m" == "all" ]] || role_violations="${role_violations}${file}: role 'specialist' requires mode subagent/all (found '$m')"$'\n' ;;
  esac
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agents declare a valid 'role' coherent with 'mode'" "$role_violations"

# 21. Agent delegation references existing agents (or opencode built-ins).
delegation_violations=""
while IFS= read -r -d '' file; do
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    if [[ ! -f "$ROOT/workflows/agents/$target.md" ]] && ! echo "$target" | grep -qxE 'build|plan|general|explore'; then
      delegation_violations="${delegation_violations}${file}: delegates_to '$target' not found"$'\n'
    fi
  done < <(frontmatter_list "$file" delegates_to)
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agent 'delegates_to' references existing agents" "$delegation_violations"

# 22. Agent skills reference an existing SKILL.md in core/ or technologies/.
skill_violations=""
while IFS= read -r -d '' file; do
  while IFS= read -r s; do
    [[ -z "$s" ]] && continue
    if [[ ! -f "$ROOT/core/$s/SKILL.md" && ! -f "$ROOT/technologies/$s/SKILL.md" ]]; then
      skill_violations="${skill_violations}${file}: skill '$s' not found (core/ or technologies/)"$'\n'
    fi
  done < <(frontmatter_list "$file" skills)
done < <(find "$ROOT/workflows/agents" -name '*.md' -type f -print0 2>/dev/null)
report "Agent 'skills' references an existing SKILL.md (core/ or technologies/)" "$skill_violations"

echo
echo "Result: $PASS PASS, $FAILURES FAIL"
if [[ $FAILURES -gt 0 ]]; then
  exit 1
fi
