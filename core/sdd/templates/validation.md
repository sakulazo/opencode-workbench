<!--
  Validation template (Spec-Driven Development).

  Copy this file to your spec directory (e.g. .specs/validation.md) and fill
  it during the validation phase. It maps every requirement and edge case to
  the test or evidence that proves it. The result must be PASS/FAIL per row
  with evidence. See the SDD skill: workflow phase 5 and tests/validate-spec.md.
-->

# Validation — <Feature or change name>

## Traceability matrix

| Requirement / edge case | Acceptance criterion | Test / evidence | Result |
| --- | --- | --- | --- |
| FR-1 | Given ..., when ..., then ... | <test or evidence> | PASS / FAIL |
| FR-2 | Given ..., when ..., then ... | <test or evidence> | PASS / FAIL |
| Edge case 1 | <expected behavior> | <test or evidence> | PASS / FAIL |

## Conformance check

<Results of running the SDD spec validation — tests/validate-spec.md.>

- Required sections present: PASS / FAIL
- Acceptance criteria measurable: PASS / FAIL
- Edge cases covered: PASS / FAIL
- Tasks small and verifiable: PASS / FAIL
- No orphan code / no uncovered requirement: PASS / FAIL

## Exceptions

<Any justified deviation from the spec, with reason and approver.>

## Result

- **Approved**: <yes / no>
- **Signed off by**: <name>
- **Date**: <date>
