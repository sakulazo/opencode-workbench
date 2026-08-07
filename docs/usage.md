# Uso del Workbench

## Propósito

Explicar cómo instalar y utilizar los recursos de **OpenCode Workbench**
(skills, commands, agents, mcps) en proyectos reales con OpenCode, y cómo
combinar la metodología SDD del Workbench con SpecKit.

---

## Instalación en un proyecto con OpenCode

OpenCode descubre los recursos desde ubicaciones documentadas dentro del
git worktree del proyecto y desde rutas globales de usuario. Copia cada
recurso al proyecto donde quieras usarlo.

### Skills

Un skill vive en un directorio llamado igual que su `name` y contiene un
`SKILL.md`. Se instala en:

- Proyecto: `.opencode/skills/<nombre>/SKILL.md`
- Global (todos los proyectos): `~/.config/opencode/skills/<nombre>/SKILL.md`
- Rutas alternativas compatibles: `.claude/skills/<nombre>/SKILL.md` y
  `.agents/skills/<nombre>/SKILL.md` (proyecto o global).

Ejemplo con el skill SDD:

```bash
cp -r core/sdd <proyecto>/.opencode/skills/sdd/
```

El `name` del frontmatter debe coincidir con el nombre del directorio
(`sdd`). Tras instalarlo, el skill aparece en la lista de skills de las
sesiones de OpenCode del proyecto y se carga bajo demanda.

**Nota**: OpenCode también descubre los `SKILL.md` presentes en el workspace
actual (por ejemplo, si el Workbench es un subdirectorio del proyecto), pero
la instalación en una ubicación documentada garantiza la portabilidad entre
proyectos.

### Commands

Un command es un archivo Markdown en `.opencode/command/` y se invoca con
`/nombre`. Si el command necesita recursos asociados (p. ej. scripts), cópialos
junto a él.

Ejemplo con el check de consistencia:

```bash
mkdir -p <proyecto>/.opencode/command/
cp workflows/commands/check-consistency.md <proyecto>/.opencode/command/
cp workflows/commands/check-consistency.sh <proyecto>/.opencode/command/
```

### Agents y mcps

- Los agents se copian a `.opencode/agent/` (o `~/.config/opencode/agent/`).
- Los mcps se configuran en `opencode.json` del proyecto (bloque `mcp`); el
  dominio `workflows/mcps` del Workbench almacena plantillas y documentación
  de referencia para esas configuraciones.

---

## Uso del skill SDD

1. Confirma que la tarea justifica SDD (ver `core/sdd/SKILL.md`, "Cuándo usar").
2. Copia las plantillas de `core/sdd/templates/` al directorio de trabajo
   (normalmente `.specs/`).
3. Completa las fases en orden: Contexto → Especificar → Diseñar → Planificar
   → Implementar → Validar, con revisión y aprobación humana en cada fase.
4. Tras Planificar, ejecuta la **puerta pre-implementación** sobre
   `requirements.md`, `design.md` y `tasks.md`
   (`core/sdd/tests/validate-spec.md`, primer momento).
5. Implementa una tarea a la vez, verificando cada criterio de aceptación.
6. Cierra con la validación de conformidad
   (`core/sdd/tests/validate-spec.md`, segundo momento) y la matriz de
   `validation.md`.

---

## Combinación con SpecKit

[SpecKit](https://github.com/github/spec-kit) es un kit de Specification-Driven
Development compatible con OpenCode. Instálalo y configura la integración:

```bash
specify init . --integration opencode
```

Esto instala los comandos `/speckit.*` (o skills equivalentes con `--skills`).

### Equivalencias

SpecKit y el skill SDD del Workbench definen el mismo proceso con artefactos
distintos:

| Fase / momento (Workbench) | Artefacto (Workbench) | Command SpecKit | Artefacto SpecKit |
| --- | --- | --- | --- |
| Contexto (Fase 0) | — | — | — |
| Especificar | `.specs/requirements.md` | `/speckit.specify` | `.specify/spec.md` |
| Diseñar | `.specs/design.md` | `/speckit.plan` | `.specify/plan.md` |
| Planificar | `.specs/tasks.md` | `/speckit.tasks` | `.specify/tasks.md` |
| Puerta pre-implementación | `core/sdd/tests/validate-spec.md` | `/speckit.checklist`, `/speckit.analyze` | — |
| Implementar | código (tarea a tarea) | `/speckit.implement` | — |
| Validar / conformidad | `core/sdd/tests/validate-spec.md` + `.specs/validation.md` | `/speckit.converge` | — |

### Estrategias

1. **SpecKit como orquestador**: genera los artefactos con los comandos
   `/speckit.*` y usa el Workbench (metodología, checklists, validate-spec)
   como criterio de calidad sobre esos artefactos.
2. **Workbench como proceso único**: instala el skill `sdd` en el proyecto y
   usa su flujo completo; SpecKit queda disponible para automatización
   (workflows, extensions) si se desea.

En ambos casos se aplica una única regla para evitar duplicidad: **una sola
fuente de verdad para los artefactos** (`.specs/` del Workbench **o**
`.specify/` de SpecKit) y **un solo proceso**, nunca ambos a la vez.

---

## Verificación tras los cambios

Ejecuta el check de consistencia desde la raíz del Workbench tras cualquier
cambio:

```bash
./workflows/commands/check-consistency.sh
```

O, si lo has instalado en un proyecto, úsalo como `/check-consistency`.
