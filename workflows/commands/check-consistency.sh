#!/usr/bin/env bash
# Consistency checker for OpenCode Workbench.
#
# Runs the deterministic (mechanical) checks defined by docs/conventions.md.
# Semantic checks (language per resource type, SDD process coherence, links,
# conceptual organization) are documented in
# workflows/commands/check-consistency.md and require human/AI review.
#
# Usage (from the repository root):
#   ./workflows/commands/check-consistency.sh [repo-root]
#
# Exit code 0: all checks pass. 1: at least one check failed.

set -u

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
PASS=0
FAILURES=0

# Exclude the command's own documentation: it may legitimately reference the
# exact terms these checks detect (e.g. "Test data").
grep_md() {
  grep -rInE --include='*.md' --exclude-dir='.git' \
    --exclude='check-consistency.md' \
    "$1" "$ROOT" 2>/dev/null || true
}

# Same as grep_md but excluding English-only resource directories (templates/,
# examples/), whose content legitimately uses the English terms these checks
# flag when they appear in Spanish prose (e.g. "edge cases").
grep_md_es() {
  grep -rInE --include='*.md' --exclude-dir='.git' \
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
    echo "$matches"
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
    echo "$matches"
  else
    PASS=$((PASS + 1))
    echo "PASS: $label"
  fi
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
done < <(find "$ROOT" -path "$ROOT/.git" -prune -o -name '*.md' -type f -print0)
if [[ -n "$exec_violations" ]]; then
  FAILURES=$((FAILURES + 1))
  echo "FAIL: Markdown files must not be executable"
  printf '%s' "$exec_violations"
else
  PASS=$((PASS + 1))
  echo "PASS: Markdown files are not executable"
fi

echo
echo "Result: $PASS PASS, $FAILURES FAIL"
if [[ $FAILURES -gt 0 ]]; then
  exit 1
fi
