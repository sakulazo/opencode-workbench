# ADR-0001 — Organización conceptual en cuatro dominios

## Contexto

El repositorio debía decidir cómo clasificar los recursos reutilizables
(skills, agents, commands, mcps, templates, ejemplos, documentación).

La alternativa más inmediata era organizar el repositorio por tipo de recurso
(`skills/`, `agents/`, `commands/`, `mcps/`).

## Decisión

Clasificar los recursos por ámbito de conocimiento en cuatro dominios
conceptuales:

- **Core** — conocimiento universal e independiente de tecnología.
- **Technologies** — conocimiento específico de una tecnología.
- **Workflows** — orquestación del trabajo asistido por IA.
- **Docs** — documentación del propio Workbench.

La naturaleza del recurso (skill, agent, command, mcp) nunca es el criterio
principal de clasificación.

## Consecuencias

- La ubicación de un recurso se decide por el ámbito de conocimiento al que
  pertenece, no por su tipo.
- Los skills de tecnología viven junto a los recursos de esa tecnología en
  `technologies/`.
- Los agents, commands y mcps se concentran en `workflows/`.
- El criterio de clasificación permanece estable cuando el repositorio crece.

## Alternativas descartadas

- **Organización por tipo de recurso**: separa conocimiento relacionado, crea
  directorios casi vacíos al inicio y obliga a reorganizaciones frecuentes al
  crecer. Se descartó por no responder a la pregunta guía del Workbench: "¿a
  qué ámbito de conocimiento pertenece?".

## Referencias

- [docs/philosophy.md](../philosophy.md)
- [docs/architecture.md](../architecture.md)
