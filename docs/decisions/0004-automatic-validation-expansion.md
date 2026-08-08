# ADR-0004 — Ampliación de la validación automática

## Contexto

La ficha 8 de la hoja de ruta (docs/roadmap.md) define la mejora de la
validación automática como prioridad: detectar inconsistencias de forma
mecánica y reproducible, en lugar de depender de la revisión manual.

La validación existente (`workflows/commands/check-consistency.sh`, amparada
por ADR-0003) cubre solo comprobaciones de terminología y formato. No detecta
errores de consumo: enlaces rotos, metadata ausente, estados inválidos,
recursos huérfanos, directorios vacíos sin `.gitkeep` o referencias a ficheros
inexistentes.

## Decisión

Ampliar el script único de validación `check-consistency.sh` con seis nuevas
comprobaciones mecánicas, todas verificables de forma determinista:

1. **Enlaces relativos rotos**: todo destino relativo de `[...](...)` o
   `[id]: ...` debe existir respecto al fichero que lo referencia.
2. **Metadata obligatoria**: todo recurso que declare frontmatter debe incluir
   los campos `name`, `type`, `version`, `status`, `purpose` y `tags` (ficha 1).
   La incorporación es incremental: no se exige metadata a los recursos que no
   la declaran.
3. **Estados válidos**: el campo `status` solo admite `draft`, `experimental`,
   `stable`, `deprecated` y `archived` (ficha 3).
4. **Recursos huérfanos**: ningún Markdown debe quedar sin ser referenciado por
   otro recurso, salvo las entradas del allowlist (README, roadmap, ADRs).
5. **Directorios vacíos**: ningún directorio sin contenido puede carecer de
   `.gitkeep`, porque Git no versiona directorios vacíos.
6. **Referencias a ficheros inexistentes**: las referencias canónicas en prosa
   (`./`, `../` o raíces de dominio) deben resolver a ficheros existentes. Las
   plantillas y ejemplos quedan exentos porque describen artefactos de proyecto.

La metadata de los recursos existentes con frontmatter (`SKILL.md` y
`check-consistency.md`) se completa en esta misma decisión para que la
validación pase limpiamente y siente el precedente para recursos futuros.

## Consecuencias

- La validación mecánica pasa de cubrir terminología/formato a cubrir también
  la integridad estructural del repositorio.
- Un cambio que rompa un enlace, deje metadata incompleta o introduzca un
  recurso huérfano falla el script antes de cerrar la tarea.
- Las plantillas y ejemplos describen artefactos de proyectos externos; se
  documenta explícitamente su exención para evitar falsos positivos.
- El script sigue siendo la herramienta única de validación: no se crea un
  script separado, preservando la simplicidad (roadmap, ficha 15).

## Alternativas descartadas

- **Script de validación separado** (`check-validación.sh`): duplica la lógica
  de recorrido de ficheros y fragmenta la validación en dos herramientas,
  contra el principio de simplicidad del Workbench.
- **Herramienta externa de validación (lint de Markdown)**: añade una
  dependencia fuera del repositorio y requiere configuración adicional; el
  script bash cubre las necesidades específicas del repositorio sin coste extra.

## Referencias

- [docs/roadmap.md](../roadmap.md) — ficha 8 (mejora de la validación
  automática) y fichas 1, 3, 9, 14 y 15.
- [docs/conventions.md](../conventions.md) — sección "Validación de
  consistencia".
- [workflows/commands/check-consistency.md](../../workflows/commands/check-consistency.md)
- [workflows/commands/check-consistency.sh](../../workflows/commands/check-consistency.sh)
