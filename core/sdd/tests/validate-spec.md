<!--
  Validación de la especificación SDD — la herramienta de validación del skill.

  Se ejecuta en dos momentos:
  (a) Puerta pre-implementación: tras la fase de planificación (tasks.md
      aprobado), validar los DOCUMENTOS de la especificación (requirements.md,
      design.md, tasks.md) y obtener la aprobación antes de escribir código.
  (b) Validación de conformidad: durante la fase de validación,
      re-ejecutarla contra el estado final (resultado implementado +
      validation.md) para confirmar que la especificación se cumple.

  En ambos momentos devuelve PASS/FAIL por criterio con evidencia. Cualquier
  FAIL debe resolverse (o exceptuarse explícitamente) antes de aprobar la
  especificación (a) o de aceptar el resultado (b).
-->

# Validación de especificación SDD

## Propósito

Comprobar que una especificación producida con el skill SDD cumple los criterios mínimos de calidad. Se aplica en dos momentos:

- **Tras Planificar (Fase 3)**: como puerta pre-implementación sobre los documentos (`requirements.md`, `design.md`, `tasks.md`) antes de aprobar e implementar la especificación.
- **Durante Validar (Fase 5)**: como validación de conformidad sobre el resultado final, complementando la matriz de `validation.md`.

En ambos momentos, un criterio en FAIL debe resolverse (o exceptuarse explícitamente) antes de la aprobación correspondiente.

## Instrucciones para el agente

1. Lee los documentos de especificación del cambio (y, en el momento de Validar, el resultado implementado y `validation.md`).
2. Evalúa cada criterio de la sección "Criterios" contra el contenido real de los documentos.
3. Marca cada criterio como **PASS**, **FAIL** o **N/A**, citando la evidencia concreta (sección, requisito, tarea o línea) en la que te basas. Un criterio marcado PASS sin evidencia no es válido.
4. Si algo es FAIL, indica exactamente qué falta y dónde debería añadirse.
5. Devuelve un resumen final: número de PASS/FAIL y decisión de aprobación (APROBADO / REQUIERE CAMBIOS / RECHAZADO), indicando el momento en que se ha ejecutado la validación.

## Criterios

### A. Estructura y contenido de `requirements.md`

- [ ] Define propósito y alcance.
- [ ] Incluye metas y no-metas explícitas.
- [ ] Enumera supuestos.
- [ ] Cada requisito funcional está identificado (FR-N).
- [ ] Cada requisito funcional tiene criterios de aceptación en formato Given / When / Then.
- [ ] Existe una sección de casos límite y escenarios de error.
- [ ] Existe una sección de restricciones.
- [ ] Los no-metas que difieren trabajo indican dónde se hace seguimiento.

### B. Calidad del contenido de `requirements.md`

- [ ] Los criterios de aceptación son medibles y verificables (no hay "funciona bien", "carga rápido").
- [ ] Entradas, salidas y condiciones son concretas.
- [ ] Los casos límite y errores definen comportamiento esperado, no solo los enumeran.
- [ ] No hay decisiones de implementación implícitas que la IA deba adivinar.
- [ ] No quedan preguntas abiertas sin resolver ni supuestos sin registrar.

### C. Estructura y contenido de `design.md`

- [ ] Describe el contexto y el estado actual.
- [ ] Incluye una vista general de la arquitectura.
- [ ] Documenta decisiones relevantes con justificación y alternativas consideradas.
- [ ] Define el modelo de datos relevante.
- [ ] Define contratos explícitos (nombres, tipos, respuestas, errores).
- [ ] Enumera ficheros/módulos afectados.
- [ ] Identifica riesgos con mitigación.

### D. Estructura y contenido de `tasks.md`

- [ ] Las tareas están numeradas (T1, T2, ...) y ordenadas.
- [ ] Cada tarea es pequeña y con alcance acotado a ficheros concretos.
- [ ] Cada tarea tiene un criterio de aceptación verificable.
- [ ] Las dependencias entre tareas están marcadas y son coherentes con el orden.
- [ ] Existe una matriz de trazabilidad requisito → tarea.

### E. Trazabilidad y coherencia global

- [ ] Todo requisito funcional (FR) tiene al menos una tarea que lo cubre.
- [ ] Todo caso límite está cubierto por una tarea o una prueba explícita.
- [ ] No hay tareas sin requisito asociado (código huérfano potencial).
- [ ] El diseño no contradice ningún requisito ni restricción.
- [ ] Los nombres de artefactos, contratos y ficheros son coherentes entre los tres documentos.

## Resumen

| Sección | PASS | FAIL | N/A |
| --- | --- | --- | --- |
| A. Estructura y contenido de `requirements.md` |  |  |  |
| B. Calidad del contenido de `requirements.md` |  |  |  |
| C. Estructura y contenido de `design.md` |  |  |  |
| D. Estructura y contenido de `tasks.md` |  |  |  |
| E. Trazabilidad y coherencia global |  |  |  |

**Decisión**: APROBADO / REQUIERE CAMBIOS / RECHAZADO

**Observaciones**: <solo las evidencias y las correcciones necesarias>

## Referencias

- Criterios de calidad: [methodology.md](../methodology.md), [checklists.md](../checklists.md)
- Proceso: [workflow.md](../workflow.md)
- Ejemplo validable: [examples/rate-limiting/](../examples/rate-limiting/)
