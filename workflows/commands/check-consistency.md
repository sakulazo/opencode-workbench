---
name: check-consistency
description: Repository consistency check for OpenCode Workbench. Runs the mechanical checks (scripts/check-consistency.sh) and reviews the semantic criteria (language per resource type, conceptual organization, SDD process coherence, links) against docs/conventions.md and docs/architecture.md. Use after any change before closing the task.
---

# Check de consistencia del Workbench

## Propósito

Verificar que el repositorio cumple las convenciones definidas en
[conventions.md](../../docs/conventions.md) y
[architecture.md](../../docs/architecture.md) tras un cambio.

## Uso

1. Ejecuta las comprobaciones mecánicas desde la raíz del repositorio:
   ```bash
   ./scripts/check-consistency.sh
   ```
   Corrige cualquier FAIL antes de continuar.
2. Revisa cada criterio de la sección "Criterios semánticos" contra el estado
   real del repositorio.
3. Marca cada criterio como **PASS**, **FAIL** o **N/A**, citando evidencia
   concreta (archivo y línea).
4. Si algo es FAIL, indica exactamente qué falta y dónde debería corregirse.

Este recurso es un command reutilizable: para usarlo como command de OpenCode,
cópialo a `.opencode/command/check-consistency.md` en el proyecto donde quieras
aplicarlo.

## Comprobaciones mecánicas

Cubiertas por `scripts/check-consistency.sh`:

- Terminología: uso consistente de "Specification-Driven Development".
- Sin frases mixtas español/inglés en prosa.
- Recursos auxiliares: lista unificada entre README.md y architecture.md.
- Títulos de secciones en español: "Documentación específica".
- Encabezados de tipos en Title Case (Skills, Agents, Commands, MCPs).
- Enumeraciones de tipos completas (skills, agents, commands, mcps).
- Sin espacios al final de línea en Markdown.
- Archivos `.md` sin permisos de ejecución.

## Criterios semánticos

### A. Idioma por tipo de recurso

- [ ] Documentación (docs/, guías, checklists, SKILL.md): español.
- [ ] Plantillas (templates/) y ejemplos (examples/): inglés.
- [ ] Frontmatter: inglés.
- [ ] No hay frases mixtas español/inglés en prosa.

### B. Organización conceptual

- [ ] Ningún recurso está clasificado principalmente por su tipo.
- [ ] skills → Core (o Technologies si son específicos de tecnología).
- [ ] agents, commands, mcps → Workflows.
- [ ] Nuevos directorios en minúscula e inglés.

### C. Coherencia del skill SDD

- [ ] Las seis fases son idénticas en SKILL.md, workflow.md y methodology.md
      (Contexto → Especificar → Diseñar → Planificar → Implementar → Validar).
- [ ] Contexto es la Fase 0.
- [ ] Los artefactos `.specs/` se listan de forma idéntica
      (requirements, design, tasks, validation).
- [ ] El ejemplo `rate-limiting` mantiene trazabilidad coherente entre
      requirements, design, tasks y validation.

### D. Enlaces y recursos

- [ ] Todas las referencias relativas apuntan a archivos existentes.
- [ ] La lista de recursos auxiliares es idéntica entre README.md y
      architecture.md (templates, examples, tests, documentación específica,
      recursos de apoyo).
- [ ] Las enumeraciones de tipos incluyen siempre los cuatro tipos
      (skills, agents, commands, mcps).

## Resumen

| Sección | PASS | FAIL | N/A |
| --- | --- | --- | --- |
| Mecánicas (script) |  |  |  |
| A. Idioma |  |  |  |
| B. Organización |  |  |  |
| C. SDD |  |  |  |
| D. Enlaces |  |  |  |

**Decisión**: APROBADO / REQUIERE CAMBIOS

**Observaciones**: <solo las evidencias y las correcciones necesarias>
