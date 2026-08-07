# OpenCode Workbench

## Descripción

OpenCode Workbench es una biblioteca personal de recursos reutilizables para OpenCode.

Su finalidad es centralizar el conocimiento, las metodologías y los flujos de trabajo utilizados durante el desarrollo asistido por inteligencia artificial, proporcionando una base sólida, mantenible y reutilizable para cualquier proyecto.

Este repositorio no pertenece a ningún proyecto de software concreto. Constituye una base de conocimiento independiente, diseñada para evolucionar de forma continua.

---

## Filosofía

La organización del Workbench responde a un criterio **conceptual**, no técnico.

Antes de decidir dónde almacenar un recurso, debe responderse una única pregunta:

> **¿A qué ámbito de conocimiento pertenece?**

Este enfoque permite mantener una arquitectura coherente y escalable incluso cuando el repositorio crezca considerablemente.

El detalle de esta filosofía se documenta en [docs/philosophy.md](docs/philosophy.md).

---

## Arquitectura conceptual

El Workbench se divide en cuatro grandes dominios de conocimiento.

```text
.
├── core/
├── technologies/
├── workflows/
├── docs/
└── README.md
```

- **Core** — conocimiento universal e independiente de tecnología: metodologías, principios y patrones reutilizables.
- **Technologies** — conocimiento específico de una tecnología concreta (Docker, React, TypeScript, Laravel, PostgreSQL, ...).
- **Workflows** — orquestación del desarrollo asistido por IA: cómo combinar Core y Technologies para resolver tareas reales.
- **Docs** — documentación del propio Workbench: arquitectura, filosofía y convenciones.

La validación de consistencia del repositorio se realiza con el command
`workflows/commands/check-consistency.md`, acompañado del script
`workflows/commands/check-consistency.sh` — una excepción documentada al
principio de no almacenar código de aplicación, pues es una herramienta de
mantenimiento del propio Workbench. Más detalle en
[docs/conventions.md](docs/conventions.md).

El detalle de cada dominio y de los tipos de recursos se documenta en [docs/architecture.md](docs/architecture.md).

---

## Organización interna

Cada dominio organiza sus recursos en torno a cuatro tipos principales:

- **skills** — encapsulan conocimiento reutilizable.
- **agents** — coordinan el trabajo y deciden cómo abordar una tarea.
- **commands** — automatizan procesos repetitivos.
- **mcps** — proporcionan capacidades externas.

Los **templates**, **examples**, **tests**, la **documentación específica** y los **recursos de apoyo** son recursos **auxiliares**: apoyan a los tipos principales sin constituir una categoría arquitectónica propia.

En la práctica, los **skills** se alojan habitualmente en **Core** (o en **Technologies** cuando son específicos de una tecnología), y los **agents**, **commands** y **mcps** en **Workflows**. El detalle de esta correspondencia está en [docs/architecture.md](docs/architecture.md).

La estructura interna debe responder siempre a las necesidades del dominio, manteniendo la máxima cohesión posible.

---

## Objetivos

- Construir una biblioteca reutilizable para OpenCode.
- Separar metodología, tecnología y orquestación.
- Evitar duplicidades.
- Favorecer la modularidad.
- Facilitar el mantenimiento a largo plazo.
- Mantener una evolución incremental mediante control de versiones.

---

## Convenciones generales

El repositorio adopta las siguientes convenciones generales:

- Los nombres de archivos y directorios estarán siempre en **inglés**.
- La documentación estará redactada preferentemente en **español**.
- El código y los identificadores seguirán las convenciones propias de cada tecnología.
- Cada recurso tendrá una única responsabilidad siempre que sea posible.
- Se favorecerá la composición frente a la duplicación.
- La organización del repositorio será siempre conceptual.

Las convenciones completas se documentan en [docs/conventions.md](docs/conventions.md).

---

## Uso del Workbench

El modo de instalar y utilizar los recursos del Workbench en proyectos con
OpenCode, así como su combinación con SpecKit, se documenta en
[docs/usage.md](docs/usage.md).

---

## Estado del proyecto

OpenCode Workbench es un proyecto en evolución continua.

Su contenido crecerá progresivamente conforme se identifiquen nuevas metodologías, tecnologías y patrones reutilizables para el desarrollo asistido por IA, priorizando siempre la calidad, la coherencia y la mantenibilidad sobre la cantidad de recursos disponibles.
