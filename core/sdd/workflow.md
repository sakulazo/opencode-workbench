# Workflow SDD

## Propósito

Definir el proceso operativo del **Specification-Driven Development**: fases, artefactos, acciones y Definition of Done. Ninguna fase puede saltarse sin una decisión explícita del humano.

Los principios y criterios que justifican este proceso están en [methodology.md](methodology.md). Las listas de verificación operativas están en [checklists.md](checklists.md).

---

## Visión general

```text
  Contexto ──▶ Especificar ──▶ Diseñar ──▶ Planificar ──▶ Implementar ──▶ Validar
  (fase 0)      (req)         (design)     (tasks)       (1 a la vez)    (verificación)
      ▲              ▲              ▲            ▲               ▲              ▲
      └──────────────┴──────────────┴────────────┴───────────────┴──────────────┘
                  Revisión y aprobación humana en cada fase
```

Los artefactos de especificación se versionan en el repositorio, normalmente en un directorio `.specs/` (p. ej. `.specs/requirements.md`, `.specs/design.md`, `.specs/tasks.md`, `.specs/validation.md`).

---

## Fase 0: Contexto

**Objetivo**: alinear el objetivo del cambio con el contexto del proyecto antes de especificar.

**Entrada**: petición o intención del humano.

**Acciones**:
- Clarificar el objetivo y el resultado esperado.
- Identificar el estado actual: módulos afectados, contratos existentes, convenciones.
- Determinar si el cambio justifica SDD o si debe resolverse de forma directa (ver "Cuándo usar" en [SKILL.md](SKILL.md)).

**Salida**: resumen de contexto (parágrafo breve en las secciones Purpose/Scope de `requirements.md`; el contexto técnico detallado se recogerá en `design.md`).

**Definition of Done**: objetivo unívoco, alcance conocido, se ha decidido aplicar SDD, aprobado por el humano.

---

## Fase 1: Especificar

**Objetivo**: definir *qué* se construye y *por qué*, de forma explícita y verificable.

**Entrada**: contexto de la fase 0.

**Acciones**:
- Redactar `requirements.md` usando [templates/requirements.md](templates/requirements.md).
- Escribir requisitos funcionales con criterios de aceptación **Given / When / Then**.
- Enumerar casos límite y escenarios de error.
- Fijar metas, no-metas y restricciones (rendimiento, seguridad, compatibilidad).

**Salida**: `requirements.md` completado.

**Definition of Done** (revisión humana):
- Cada criterio de aceptación es medible y no ambiguo.
- Los casos límite y errores están cubiertos.
- No hay decisiones de implementación implícitas que la IA deba adivinar.
- Se han detectado preguntas abiertas y se han resuelto o registrado como supuestos.

---

## Fase 2: Diseñar

**Objetivo**: decidir *cómo* se implementa, registrando decisiones con su justificación.

**Entrada**: `requirements.md` aprobado.

**Acciones**:
- Redactar `design.md` usando [templates/design.md](templates/design.md).
- Describir la arquitectura, el modelo de datos y los contratos (API, esquemas, integraciones).
- Listar los módulos/ficheros afectados.
- Documentar las decisiones de diseño con alternativa y justificación (ADR ligero).
- Identificar riesgos y mitigaciones.

**Salida**: `design.md` completado.

**Definition of Done** (revisión humana):
- El diseño cumple todos los requisitos y restricciones.
- Cada decisión relevante tiene justificación.
- Los contratos son explícitos (nombres, tipos, errores).
- No hay dependencias ocultas ni ambigüedad para la implementación.

---

## Fase 3: Planificar

**Objetivo**: descomponer la implementación en tareas pequeñas, ordenadas y verificables.

**Entrada**: `requirements.md` y `design.md` aprobados.

**Acciones**:
- Redactar `tasks.md` usando [templates/tasks.md](templates/tasks.md).
- Numerar las tareas (T1, T2, ...) con alcance, ficheros, criterio de aceptación y dependencias.
- Marcar las dependencias entre tareas y el orden de ejecución.
- Toda tarea debe tener criterios de aceptación que una IA pueda verificar.
- Ejecutar la **puerta pre-implementación** sobre `requirements.md`, `design.md` y `tasks.md` (primer momento de [tests/validate-spec.md](tests/validate-spec.md)) antes de pasar a Implementar.

**Salida**: `tasks.md` completado y puerta pre-implementación pasada.

**Definition of Done** (revisión humana):
- Cada tarea es pequeña, con alcance acotado a ficheros concretos.
- Cada tarea tiene un criterio de aceptación verificable.
- Existe cobertura trazable de todos los requisitos.
- El orden de ejecución respeta las dependencias.
- La puerta pre-implementación de [tests/validate-spec.md](tests/validate-spec.md) pasa sin FAIL (o con excepciones justificadas).

---

## Fase 4: Implementar

**Objetivo**: generar código conforme a la especificación, una tarea a la vez.

**Entrada**: `tasks.md` aprobado.

**Acciones**:
- Ejecutar las tareas en orden, **una a la vez**.
- Antes de pasar a la siguiente tarea, verificar su criterio de aceptación (tests, compilación, revisión).
- No ampliar el alcance de una tarea durante la implementación; los hallazgos nuevos se registran y vuelven a la fase de especificación.
- La IA no decide diseño no especificado; pregunta o registra el supuesto.

**Salida**: código implementado por tarea, con las pruebas correspondientes.

**Definition of Done**:
- Todas las tareas completadas y sus criterios de aceptación verificados.
- No hay código sin tarea asociada (sin *código huérfano*).
- Los cambios de alcance detectados están registrados en la especificación.

---

## Fase 5: Validar

**Objetivo**: comprobar que el resultado cumple la especificación completa.

**Entrada**: implementación terminada y la plantilla `templates/validation.md` copiada a `.specs/validation.md`.

**Acciones**:
- Completar `validation.md` con la matriz de trazabilidad especificación → pruebas (usar [templates/validation.md](templates/validation.md)).
- Re-ejecutar la validación de conformidad sobre el estado final (ver [tests/validate-spec.md](tests/validate-spec.md)): es el segundo de los dos momentos descritos en ese documento, y complementa la matriz de `validation.md`.
- Verificar cada criterio de aceptación y cada caso límite de `requirements.md`.
- Revisar el resultado con criterio de ingeniería (seguridad, rendimiento, mantenibilidad), no solo funcionalidad.

**Salida**: `validation.md` con resultado pass/fail por criterio y evidencia.

**Definition of Done**:
- Todos los criterios de aceptación verificados con evidencia.
- La matriz de trazabilidad no deja requisitos sin cubrir ni código huérfano.
- El humano acepta el resultado o registra excepciones justificadas.

---

## Bucle de retroalimentación

Cualquier hallazgo durante la implementación o validación que modifique requisitos, diseño o alcance **vuelve a la fase correspondiente de la especificación**:

```text
  Implementar / Validar
        │
        ▼
  Hallazgo que cambia alcance ──▶ Actualizar requirements / design / tasks ──▶ Reprobar
```

La especificación es el documento vivo; el código siempre sigue a la especificación, nunca al revés.

### Cambios fuera del flujo SDD

Un cambio de alcance puede llegar por una vía distinta al flujo (p. ej. ajustes
pedidos en una sesión normal, sin pasar por especificar → diseñar → planificar). Trátalo
como un hallazgo del mismo modo:

- Compara el resultado con los artefactos de la especificación de la funcionalidad afectada.
- Si hay discrepancia (campo, contrato, estado o comportamiento nuevos),
  avísala explícitamente al humano y propón actualizar requirements / design /
  tasks **antes de dar la tarea por cerrada**.
- No modifiques la especificación sin aprobación humana. Si el cambio sí pasó por el
  flujo (implementar → validar), deja que la validación lo gestione y no
  dupliques el aviso.

No aplica a cambios triviales de vista sin impacto de comportamiento (p. ej.
renombrar un botón).

---

## Gestión de *spec drift*

- Implementar una tarea a la vez evita que el código se aleje de la especificación.
- Toda desviación de diseño detectada se registra como hallazgo y se decide explícitamente.
- Al validar, la conformidad con la especificación es el criterio principal de aceptación.

---

## Referencias

- Plantillas: [templates/](templates/)
- Ejemplo completo: [examples/rate-limiting/](examples/rate-limiting/)
- Listas de verificación: [checklists.md](checklists.md)
- Validación de conformidad: [tests/validate-spec.md](tests/validate-spec.md)
