---
name: sdd
description: Specification-Driven Development (SDD) for AI-assisted development. Use when starting a new feature, complex task, refactor, or AI-assisted implementation that requires specifications, acceptance criteria, and task breakdown before coding.
---

# Specification-Driven Development (SDD)

Metodología de desarrollo asistido por IA en la que **la especificación es la fuente de verdad** y el código se genera después, a partir de ella.

El humano orquesta y revisa; la IA implementa. Las decisiones de diseño se toman antes de escribir código, y la validación comprueba que el resultado cumple la especificación, no solo que "funciona".

---

## Cuándo usar

- Cambios o funcionalidades con lógica, alcance o acoplamiento no triviales.
- Tareas que requieren tomar decisiones de diseño antes de implementar.
- Implementación asistida por IA donde la ambigüedad provoca reescrituras.
- Refactorizaciones, migraciones o cambios con impacto en varios módulos.

## Cuándo NO usar

- Cambios triviales de una sola línea o sin lógica.
- Exploración y prototipado rápido ("vibe coding") donde el resultado se descarta.
- Tareas urgentes de corrección puntual sin alcance material.

---

## Proceso en una frase

> **Contexto → Especificar → Diseñar → Planificar → Implementar → Validar**, con la especificación versionada como artefacto y el humano aprobando cada fase.

Fases resumidas:

0. **Contexto** — recopilar objetivo, contexto del proyecto y restricciones.
1. **Especificar** — escribir `requirements.md` (alcance, criterios de aceptación, edge cases).
2. **Diseñar** — escribir `design.md` (decisiones, contratos, arquitectura).
3. **Planificar** — descomponer en `tasks.md` (tareas numeradas y verificables).
4. **Implementar** — ejecutar una tarea a la vez, verificando cada una.
5. **Validar** — comprobar el cumplimiento contra la especificación.

Detalle completo en [workflow.md](workflow.md).

---

## Documentos de referencia

- [methodology.md](methodology.md) — principios, qué es una buena especificación y cuándo aplicar SDD.
- [workflow.md](workflow.md) — proceso detallado, artefactos y Definition of Done por fase.
- [checklists.md](checklists.md) — listas de verificación operativas para revisar y validar.
- [templates/](templates/) — plantillas reutilizables (`requirements.md`, `design.md`, `tasks.md`, `validation.md`).
- [examples/](examples/) — caso de ejemplo completo (`rate-limiting/`).
- [tests/](tests/) — validación de la especificación en dos momentos: puerta previa a la implementación y check de conformidad final.

---

## Cómo empezar

1. Confirma que la tarea justifica SDD (ver "Cuándo usar").
2. Lee [workflow.md](workflow.md) y [checklists.md](checklists.md).
3. Copia las plantillas de [templates/](templates/) al directorio de trabajo (p. ej. `.specs/`).
4. Completa cada fase en orden, sin saltar a la implementación hasta que el humano apruebe la especificación.
5. Implementa **una tarea a la vez**, verificando cada una antes de avanzar.
6. Cierra con la validación de conformidad (ver [tests/validate-spec.md](tests/validate-spec.md)).
