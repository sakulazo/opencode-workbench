<!--
  Design specification template (Specification-Driven Development).

  Copy this file to your spec directory (e.g. .specs/design.md) and fill
  every section. This document decides HOW the requirements are implemented.
  Record every relevant decision with its rationale. See the SDD skill.
-->

# Design — <Feature or change name>

## Context

<Current state of the affected modules and why this design is needed. Links to the requirements spec.>

## Architecture overview

<High-level description of the solution: components, flow, interactions.>

## Decisions

### Decision 1: <Short name>

- **Decision**: <What was decided>.
- **Rationale**: <Why>.
- **Alternatives considered**: <Option A rejected because ...>.

### Decision 2: <Short name>

- **Decision**: <What was decided>.
- **Rationale**: <Why>.
- **Alternatives considered**: <Option A rejected because ...>.

## Data model

<Entities, fields, types, relationships. Only what is relevant to this change.>

## Contracts

<APIs, schemas, integration points. For each: names, signatures/types, request/response shapes, error cases.>

## Affected files / modules

- `path/to/file1` — <what changes>.
- `path/to/file2` — <what changes>.

## Risks and mitigations

- <Risk 1> → <Mitigation>.
- <Risk 2> → <Mitigation>.
