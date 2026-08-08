# ADR-0002 — Idioma de los recursos

## Contexto

El Workbench necesitaba definir convenciones lingüísticas para documentos,
plantillas, ejemplos y frontmatter.

La documentación conceptual la leen personas en español, pero los artefactos
reutilizables (plantillas, ejemplos) y el frontmatter los consume
mayoritariamente tooling de IA, que los interpreta de forma más fiable en
inglés.

## Decisión

- Nombres de archivos y directorios en inglés.
- Documentación en español.
- Plantillas (templates) y ejemplos (examples) en inglés.
- Frontmatter de los recursos en inglés.

## Consecuencias

- `SKILL.md` describe sus recursos en español pero con frontmatter en inglés.
- Las plantillas y ejemplos son artefactos directamente reutilizables en
  inglés.
- El command de consistencia verifica que no aparezcan frases mixtas
  español/inglés en la prosa.

## Alternativas descartadas

- **Todo en español**: reduce la fiabilidad del consumo por herramientas de IA
  y dificulta la reutilización directa de plantillas en proyectos.
- **Todo en inglés**: dificulta la lectura de la documentación conceptual para
  el autor y los lectores habituales.

## Referencias

- [docs/conventions.md](../conventions.md) — sección "Idioma".
