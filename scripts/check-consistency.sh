#!/usr/bin/env bash
# Consistency checker for OpenCode Workbench.
#
# Runs the deterministic (mechanical) checks defined by docs/conventions.md.
# Semantic checks (language per resource type, SDD process coherence, links,
# conceptual organization) are documented in
# workflows/commands/check-consistency.md and require human/AI review.
#
# Usage (from the repository root):
#   ./scripts/check-consistency.sh [repo-root]
#
# Exit code 0: all checks pass. 1: at least one check failed.

set -u

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
PASS=0
FAILURES=0

grep_md() {
  grep -rInE --include='*.md' --exclude-dir='.git' "$1" "$ROOT" 2>/dev/null || true
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

echo "Consistency check for: $ROOT"
echo

# 1. Terminology: the methodology is "Specification-Driven Development".
check_pattern "Terminology: 'Specification-Driven Development' (not 'Spec-Driven')" "Spec-Driven"

# 2. No mixed Spanish/English phrases like "specify ->".
check_pattern "No mixed-language phrase 'specify ->'" "specify[[:space:]]*->"

# 3. No obsolete auxiliary resource "Test data".
check_pattern "No auxiliary resource 'Test data'" "Test data"

# 4. Documentation titles in Spanish: "Documentación específica".
check_pattern "Spanish documentation title 'Documentación específica'" "Documentation[[:space:]]+específica"

# 5. Resource type headings use Title Case.
check_pattern "Headings Title Case: '## Skills, ## Agents, ## Commands, ## MCPs'" "^## (skills|agents|commands|mcps)([[:space:]]*)$"
check_pattern "No singular type headings: '## Skill, ## Agent, ## Command, ## MCP'" "^## (Skill|Agent|Command|MCP)([[:space:]]*)$"

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
