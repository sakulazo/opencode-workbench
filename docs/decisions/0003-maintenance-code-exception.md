# ADR-0003 — Excepción de código de mantenimiento

## Contexto

El Workbench no almacena código de aplicación: es una biblioteca de
conocimiento, no un proyecto de software (docs/philosophy.md).

Sin embargo, mantener la consistencia del repositorio (terminología, enlaces,
convenciones) requiere comprobaciones mecánicas reproducibles que un documento
markdown por sí solo no puede ejecutar.

## Decisión

Permitir una excepción documentada: `workflows/commands/check-consistency.sh`,
un script ejecutable que acompaña al command `check-consistency.md`.

No es código de producto, sino una herramienta de mantenimiento del propio
Workbench, y vive junto al command que lo utiliza.

## Consecuencias

- El script se excluye de las comprobaciones que él mismo ejecuta.
- La excepción queda documentada en `docs/conventions.md` y en el propio
  command, evitando que se convierta en un precedente para incorporar más
  código de aplicación.
- La validación mecánica es reproducible y no depende de la revisión manual.

## Alternativas descartadas

- **Repositorio separado para el tooling**: sobrecarga de mantenimiento
  innecesaria para un único script.
- **Validación exclusivamente manual/semántica**: pierde las comprobaciones
  mecánicas deterministas y reintroduce las inconsistencias que el script
  detecta.

## Referencias

- [docs/conventions.md](../conventions.md) — sección "Validación de
  consistencia".
- [workflows/commands/check-consistency.md](../../workflows/commands/check-consistency.md)
