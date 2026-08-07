# Arquitectura

## Propósito

Este documento define la arquitectura conceptual de **OpenCode Workbench**.

Su objetivo es establecer los tipos de recursos que forman parte del Workbench, sus responsabilidades y la forma en que se relacionan entre sí.

La arquitectura se ha diseñado para favorecer la reutilización, la modularidad y la evolución incremental del conocimiento.

---

# Principios arquitectónicos

Toda decisión arquitectónica deberá respetar los siguientes principios:

- Organización conceptual.
- Separación de responsabilidades.
- Modularidad.
- Reutilización.
- Simplicidad.
- Evolución incremental.

---

# Dominios conceptuales

El Workbench organiza el conocimiento en cuatro grandes dominios.

## Core

Contiene conocimiento independiente de cualquier tecnología.

Su contenido representa metodologías, principios y patrones reutilizables.

Ejemplos:

- Specification-Driven Development.
- Arquitectura de software.
- Documentación.
- Planificación.
- Revisión de código.

---

## Technologies

Contiene recursos específicos de una tecnología determinada.

Cada tecnología constituye un espacio independiente donde se agrupan los recursos relacionados con ella.

Ejemplos:

- Docker.
- React.
- TypeScript.
- Laravel.
- PostgreSQL.

---

## Workflows

Contiene los recursos encargados de coordinar y automatizar el trabajo.

Aquí se define cómo interactúan el conocimiento, las herramientas y los distintos procesos de desarrollo.

---

## Docs

Contiene la documentación del propio Workbench.

Describe su arquitectura, filosofía, convenciones y evolución.

---

# Recursos principales

El Workbench se construye únicamente sobre cuatro tipos de recursos principales.

---

## Skills

Un **skill** encapsula conocimiento reutilizable.

Describe cómo abordar una tarea o resolver un problema determinado.

No coordina procesos ni interactúa directamente con herramientas externas.

### Responsabilidades

- Aportar conocimiento.
- Definir metodologías.
- Establecer buenas prácticas.
- Guiar la resolución de problemas.

---

## Agents

Un **agent** coordina el trabajo.

Su responsabilidad consiste en analizar una situación, decidir cómo abordarla y utilizar los recursos necesarios para alcanzar un objetivo.

Un agent puede utilizar múltiples skills, commands y mcps durante una misma tarea.

### Responsabilidades

- Planificar.
- Coordinar.
- Tomar decisiones.
- Delegar tareas.

---

## Commands

Un **command** automatiza tareas repetitivas.

Su objetivo es proporcionar una forma consistente de ejecutar procesos habituales.

### Responsabilidades

- Automatizar acciones.
- Reducir trabajo manual.
- Estandarizar procesos.

---

## MCPs

Un **mcp** proporciona capacidades externas.

No contiene conocimiento ni define comportamiento.

Permite interactuar con sistemas ajenos al modelo.

Ejemplos:

- GitHub.
- Sistema de archivos.
- APIs.
- Bases de datos.
- Navegadores.
- Documentación externa.

### Responsabilidades

- Proporcionar acceso a recursos externos.
- Ampliar las capacidades del agente.

---

# Ubicación de los recursos

Los tipos principales tienen una ubicación habitual según su naturaleza:

- **skills** → **Core** — el conocimiento reutilizable se agrupa por ámbito
  conceptual (p. ej. `core/sdd`). Un skill específico de una tecnología vive
  en **Technologies** junto a los recursos de esa tecnología.
- **agents**, **commands**, **mcps** → **Workflows** — son recursos de
  orquestación y ejecución (p. ej. `workflows/agents`, `workflows/commands`,
  `workflows/mcps`).
- **Docs** documenta el propio Workbench.

Esta distribución no es excluyente: un dominio puede combinar los tipos que
necesite. La organización seguirá siendo siempre conceptual, y la naturaleza
del recurso (skill, agent, command, mcp) nunca será el criterio principal de
clasificación.

---

# Recursos auxiliares

Existen recursos cuya función es apoyar a los recursos principales.

No constituyen una categoría arquitectónica independiente.

Entre ellos pueden encontrarse:

- Templates.
- Examples.
- Tests.
- Documentación específica.
- Recursos de apoyo.

Estos elementos podrán existir asociados a cualquier skill, agent, command, mcp o tecnología cuando resulte útil.

---

# Relaciones

Los recursos colaboran respetando siempre su responsabilidad.

```text
                  agent
        ┌─────────┼─────────┐
        │         │         │
      skill    command     mcp
```

El agent coordina.

Los skills aportan conocimiento.

Los commands ejecutan procesos.

Los mcps proporcionan capacidades externas.

---

# Dependencias

Se favorecerán las siguientes relaciones:

- Un agent puede utilizar múltiples skills.
- Un agent puede ejecutar commands.
- Un agent puede utilizar mcps.
- Un skill puede disponer de templates y examples propios.
- Un command puede disponer de documentación y ejemplos.
- Un agent puede incluir documentación específica de su comportamiento.

Se evitarán dependencias innecesarias entre recursos del mismo tipo.

---

# Evolución

Todo nuevo recurso deberá responder a una responsabilidad claramente diferenciada.

Antes de crear una nueva categoría arquitectónica deberá evaluarse si el recurso puede formar parte de una categoría ya existente.

La arquitectura priorizará siempre la simplicidad, la cohesión y la mantenibilidad frente al crecimiento innecesario del número de conceptos.

El objetivo del Workbench no es acumular recursos, sino construir una biblioteca coherente de conocimiento reutilizable para OpenCode.