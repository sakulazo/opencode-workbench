---
name: check-consistency
description: Repository consistency check for OpenCode Workbench. Runs the mechanical checks (workflows/commands/check-consistency.sh) and reviews the semantic criteria (language per resource type, conceptual organization, SDD process coherence, agent org chart, links) against docs/conventions.md, docs/architecture.md and docs/organization.md. Use after any change before closing the task.
type: command
version: 1.3
status: stable
purpose: Verify that the repository complies with the Workbench consistency and governance conventions after a change.
tags: [governance, consistency]
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
cópialo a `.opencode/commands/check-consistency.md` en el proyecto donde quieras
aplicarlo (junto con `check-consistency.sh` en la misma carpeta).

**Requisito de ejecución**: `check-consistency.sh` requiere Bash 4+ y
coreutils GNU (`realpath -m`, `grep --exclude-dir`, `find -print0`). No es
portátil a macOS/BSD por defecto: allí debe instalarse GNU coreutils.

## Automatización

Para que la validación se ejecute sola y no dependa de la memoria humana:

- **Hook de git**: el repositorio incluye un hook de pre-commit en
  `.githooks/pre-commit`. Actívalo una vez por clon con:
  `git config core.hooksPath .githooks`. Desde entonces, cada `git commit`
  ejecuta `check-consistency.sh` y se aborta si algo falla.
- **CI (GitHub Actions)**: el workflow `.github/workflows/consistency.yml`
  ejecuta el script en cada push y pull request, bloqueando la fusión si hay
  inconsistencias.

## Qué soluciona

Este command previene que vuelvan a introducirse las inconsistencias ya
detectadas en el repositorio: terminología divergente (p. ej. "puerta previa" o
"puerta de calidad" en lugar de "puerta pre-implementación", "check de
conformidad" o "Conformidad post-implementación" en lugar de "validación de
conformidad", "capacity" en los criterios de ráfaga del ejemplo en lugar de
"configured limit"), idiomas mezclados en prosa (p. ej. "edge cases", "la
feature", "specify ->"), encabezados o enumeraciones de tipos incorrectos,
espacios al final de línea, archivos Markdown con permisos de ejecución y,
desde ADR-0004, inconsistencias estructurales (enlaces rotos, metadata
incompleta, estados inválidos, recursos huérfanos, directorios vacíos sin
`.gitkeep` y referencias a ficheros inexistentes).
Convierte la coherencia en algo verificable automáticamente en lugar de depender
de la revisión manual.

## Excepción

`check-consistency.sh` es un script ejecutable asociado a este command. Es una
**excepción documentada** al principio de que el repositorio no almacena código
de aplicación: no es código de producto, sino una herramienta de mantenimiento
del propio Workbench, y se mantiene junto al command que la utiliza.

## Comprobaciones mecánicas

Cubiertas por `check-consistency.sh` (en esta misma carpeta). El scan ignora
`.git` y `node_modules` (contenido no versionado del repositorio):

- Terminología: uso consistente de "Specification-Driven Development".
- Terminología SDD: "puerta pre-implementación" y "validación de conformidad"
  (sin "puerta previa", "puerta de calidad", "check de conformidad" ni
  "Conformidad post-implementación").
- Terminología del ejemplo `rate-limiting`: "configured limit" en los
  criterios de ráfaga (sin "capacity").
- Rutas de instalación de OpenCode en plural: `commands/` y `agents/` (sin las
  obsoletas `command/` y `agent`).
- Sin frases mixtas español/inglés en prosa (p. ej. "edge cases", "la feature",
  "specify ->").
- Recursos auxiliares: sin términos obsoletos (p. ej. "Test data").
- Títulos de secciones en español: "Documentación específica".
- Encabezados de tipos en Title Case (Skills, Agents, Commands, MCPs).
- Enumeraciones de tipos completas (skills, agents, commands, mcps).
- Sin espacios al final de línea en Markdown.
- Archivos `.md` sin permisos de ejecución.

### Integridad estructural (ADR-0004)

Desde ADR-0004 el script verifica también la integridad estructural del
repositorio:

- Enlaces relativos: ningún destino de `[...](...)` o `[id]: ...` debe apuntar
  a un fichero o directorio inexistente.
- Metadata obligatoria: todo recurso con frontmatter debe declarar `name`,
  `type`, `version`, `status`, `purpose` y `tags`. La incorporación es
  incremental: los recursos sin frontmatter no se exigen.
- Estados válidos: `status` solo admite `draft`, `experimental`, `stable`,
  `deprecated` y `archived`.
- Recursos huérfanos: ningún Markdown sin ser referenciado por otro recurso,
  salvo el allowlist (README, roadmap, ADRs).
- Directorios vacíos: deben contener `.gitkeep`.
- Referencias en prosa: las rutas canónicas (`./`, `../` o dominio) deben
  resolver a ficheros existentes. Plantillas y ejemplos están exentos por
  describir artefactos de proyectos externos.

### Protección de fugas (checks 15 y 16)

- IPs públicas: ninguna dirección IPv4 pública en los Markdown del repositorio.
  Los rangos privados y de documentación (RFC 1918, loopback, link-local, CGNAT,
  TEST-NET) están permitidos como ejemplos; cualquier otra IP se considera una
  posible fuga de infraestructura del operador.
- Tokens del operador: si existe `.operator-secrets` en la raíz (fichero local
  gitignored con una IP/token por línea, `#` para comentarios), el script
  comprueba que ninguno aparezca en el repositorio. Si el fichero no existe
  (clones públicos, CI), el check se omite sin fallar.

### Gobernanza del organigrama de agentes (ADR-0005)

Desde ADR-0005 el script verifica también las reglas del organigrama definidas
en [organization.md](../../docs/organization.md):

- Frontmatter completo de agente: todo recurso en `workflows/agents/` declara
  `name`, `type`, `version`, `status`, `purpose`, `tags`, `mode`, `role` y
  `description`, y `type: agent`.
- `mode` válido: solo `primary`, `subagent` o `all`.
- `name` coincide con el nombre de archivo (kebab-case).
- `role` válido y coherente con `mode`: `orchestrator` → primary/all,
  `process` → all, `specialist` → subagent/all.
- `delegates_to` solo a agentes existentes en `workflows/agents/` o a los
  built-ins de OpenCode (`build`, `plan`, `general`, `explore`).
- `skills` solo a `SKILL.md` existentes en `core/` o `technologies/`.

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

### E. Organigrama de agentes

- [ ] Cada agente está documentado en docs/organization.md (matriz de
      delegación) y en el repertorio de usage.md.
- [ ] La matriz de delegación de organization.md es coherente con el
      frontmatter (`role`, `delegates_to`) de cada agente.
- [ ] Todo agente usa skills existentes y delega solo en agentes existentes.
- [ ] Los valores de `role` (orchestrator, process, specialist) y `mode`
      siguen la taxonomía documentada en organization.md.

## Resumen

| Sección | PASS | FAIL | N/A |
| --- | --- | --- | --- |
| Mecánicas (script) |  |  |  |
| A. Idioma |  |  |  |
| B. Organización |  |  |  |
| C. SDD |  |  |  |
| D. Enlaces |  |  |  |
| E. Organigrama |  |  |  |

**Decisión**: APROBADO / REQUIERE CAMBIOS

**Observaciones**: <solo las evidencias y las correcciones necesarias>
