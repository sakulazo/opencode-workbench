# Conventions

## Propósito

Este documento define las convenciones generales del repositorio **OpenCode Workbench**.

Su objetivo es garantizar la coherencia, mantenibilidad y escalabilidad del proyecto a medida que evolucione.

Toda nueva incorporación al repositorio deberá respetar estas convenciones, salvo que exista una decisión de diseño debidamente documentada que justifique una excepción.

---

# Principios generales

Las siguientes reglas se aplican a todo el repositorio.

- La organización será siempre **conceptual**, nunca basada únicamente en el tipo de recurso.
- Cada recurso tendrá una única responsabilidad.
- Se favorecerá la reutilización frente a la duplicación.
- La simplicidad tendrá prioridad sobre la complejidad.
- La documentación formará parte del recurso, no será un añadido opcional.

---

# Organización

Todo recurso deberá clasificarse siguiendo este orden de decisión:

1. ¿Pertenece al conocimiento universal?
   - **Core**

2. ¿Pertenece a una tecnología concreta?
   - **Technologies**

3. ¿Describe cómo coordinar recursos para realizar una tarea?
   - **Workflows**

4. ¿Documenta el propio Workbench?
   - **Docs**

La naturaleza del recurso (skill, agent, command, mcp, template, ejemplo, etc.) nunca será el criterio principal de clasificación.

---

# Idioma

Se utilizarán las siguientes convenciones lingüísticas:

- Los nombres de archivos estarán en inglés.
- Los nombres de directorios estarán en inglés.
- La documentación estará preferentemente en español.
- El código utilizará las convenciones habituales de cada lenguaje.
- Los identificadores seguirán el idioma predominante de la tecnología utilizada, normalmente inglés.

**Excepción de idioma**: las plantillas (templates) y los ejemplos (examples)
se redactan en inglés, por ser artefactos reutilizables orientados al código y
al trabajo con IA. El frontmatter de los recursos (p. ej. `description` en
`SKILL.md`) también se redacta en inglés por estandarización: las herramientas
de IA lo consumen de forma más fiable en ese idioma. El resto de la
documentación asociada a un recurso (SKILL.md, guías, checklists) se mantiene
en español.

---

# Nomenclatura

Los nombres deberán ser:

- Claros.
- Descriptivos.
- Concisos.
- Consistentes.

Se evitarán:

- Abreviaturas innecesarias.
- Acrónimos poco conocidos.
- Versiones en el nombre.
- Prefijos redundantes.

---

# Diseño de recursos

Todo recurso debería ser:

- Cohesionado.
- Reutilizable.
- Fácil de comprender.
- Fácil de mantener.
- Independiente siempre que sea posible.

Cuando un recurso comience a asumir varias responsabilidades, deberá dividirse.

---

# Evolución

El repositorio evolucionará mediante pequeñas mejoras incrementales.

Antes de crear un nuevo recurso se recomienda comprobar:

- Si ya existe uno equivalente.
- Si puede ampliarse uno existente.
- Si realmente aporta valor como elemento independiente.

---

# Documentación

Todo recurso relevante debería incluir la documentación necesaria para comprender:

- Su propósito.
- Su ámbito de aplicación.
- Sus limitaciones.
- Su forma de utilización.

La documentación deberá mantenerse sincronizada con la evolución del recurso.

---

# Compatibilidad

Siempre que sea posible:

- Los cambios deberán preservar la compatibilidad con recursos existentes.
- Las modificaciones importantes deberán estar justificadas.
- Las decisiones arquitectónicas relevantes deberán documentarse.

---

# Mejora continua

Estas convenciones no son inmutables.

Podrán modificarse cuando exista una razón técnica o metodológica que mejore la calidad, coherencia o mantenibilidad del Workbench.

Toda modificación deberá perseguir un beneficio claro para el conjunto del repositorio.

---

# Validación de consistencia

La coherencia del repositorio se verifica con el command
[check-consistency.md](../workflows/commands/check-consistency.md):
comprobaciones mecánicas mediante `scripts/check-consistency.sh` y revisión
semántica guiada. Se recomienda ejecutarlo tras cada cambio, antes de cerrar la
tarea o el commit.