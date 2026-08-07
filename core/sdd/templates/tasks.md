<!--
  Task breakdown template (Spec-Driven Development).

  Copy this file to your spec directory (e.g. .specs/tasks.md) and fill it.
  Each task must be small, scoped to concrete files, and have a verifiable
  acceptance criterion. Tasks are executed ONE AT A TIME in order. The AI
  must not skip ahead to the next task until the current one is verified.
  See the SDD skill.
-->

# Tasks — <Feature or change name>

Dependencies between tasks must be respected by the execution order.

## T1: <Short task name>

- **Scope**: <What is built/refactored>.
- **Files**: <file paths>.
- **Depends on**: <T-ID or "—">.
- **Acceptance**: <Verifiable check: test, command, or observable result>.

## T2: <Short task name>

- **Scope**: <What is built/refactored>.
- **Files**: <file paths>.
- **Depends on**: <T1 or "—">.
- **Acceptance**: <Verifiable check>.

## T3: <Short task name>

- **Scope**: <What is built/refactored>.
- **Files**: <file paths>.
- **Depends on**: <T-ID or "—">.
- **Acceptance**: <Verifiable check>.

## Traceability

| Requirement | Covered by |
| --- | --- |
| FR-1 | T2 |
| FR-2 | T1, T3 |
| Edge case 1 | T3 |
