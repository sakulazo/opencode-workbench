---
name: check-consistency
description: Repository consistency check for OpenCode Workbench. Runs the mechanical checks (workflows/commands/check-consistency.sh) and reviews the semantic criteria (language per resource type, conceptual organization, SDD process coherence, links) against docs/conventions.md and docs/architecture.md. Use after any change before closing the task.
---

# Check de consistencia del Workbench

## Propósito

Verificar que el repositorio cumple las convenciones definidas en
[conventions.md](../../docs/conventions.md) y
[architecture.md](../../docs/architecture.md) tras un cambio.

## Uso

1. Ejecuta las comprobaciones mecánicas desde la raíz del repositorio:
   ```bash
   ./workflows/commands/check-consistency.sh
   ```
   Corrige cualquier FAIL antes de continuar.
2. Revisa cada criterio de la sección "Criterios semánticos" contra el estado
   real del repositorio.
3. Marca cada criterio como **PASS**, **FAIL** o **N/A**, citando evidencia
   concreta (archivo y línea).
4. Si algo es FAIL, indica exactamente qué falta y dónde debería corregirse.

Este recurso es un command reutilizable: para usarlo como command de OpenCode,
cópialo a `.opencode/command/check-consistency.md` en el proyecto donde quieras
aplicarlo (junto con `check-consistency.sh` en la misma carpeta).

## Qué soluciona

Este command previene que vuelvan a introducirse las inconsistencias ya
detectadas en el repositorio: terminología divergente, idiomas mezclados en
prosa, encabezados o enumeraciones de tipos incorrectos, espacios al final de
línea y archivos Markdown con permisos de ejecución. Convierte la coherencia
en algo verificable automáticamente en lugar de depender de la revisión manual.

## Excepción

`check-consistency.sh` es un script ejecutable asociado a este command. Es una
**excepción documentada** al principio de que el repositorio no almacena código
de aplicación: no es código de producto, sino una herramienta de mantenimiento
del propio Workbench, y se mantiene junto al command que la utiliza.

## Comprobaciones mecánicas

Cubiertas por `check-consistency.sh` (en esta misma carpeta):

- Terminología: uso consistente de "Specification-Driven Development".
- Sin frases mixtas español/inglés en prosa.
- Recursos auxiliares: sin términos obsoletos (p. ej. "Test data").
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
