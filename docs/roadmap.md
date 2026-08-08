# Hoja de ruta

## Propósito

Este documento registra la evolución planificada de **OpenCode Workbench**.

No es un checklist de tareas pendientes, sino un registro de decisiones de
evolución: qué se adopta, qué se adopta de forma parcial, qué se aplaza y qué
se rechaza, junto con la justificación de cada caso.

Las decisiones arquitectónicas ya tomadas se documentan en
[docs/decisions/](decisions/). Cada ficha puede enlazar con el ADR que la
fundamenta.

## Criterios de evaluación

Las propuestas de evolución se evalúan frente a los principios del
Workbench:

- Simplicidad sobre complejidad.
- Consistencia y mantenibilidad.
- Evolución incremental.
- Independencia de los recursos.

## Resumen

| # | Propuesta | Intención | Estado |
| --- | --- | --- | --- |
| 1 | Metadatos en todos los recursos | Que cada recurso explique qué hace, cuándo usarlo y de qué depende, sin abrir el archivo. | ADOPTADA (versión mínima) |
| 2 | Índices automáticos (INDEX.md) | Que cada directorio se descubra por sí solo con un índice. | APLAZADA |
| 3 | Estados de madurez | Que cada recurso indique su nivel de confianza. | ADOPTADA |
| 4 | Versionado interno | Saber cuándo y cómo cambia cada metodología. | PARCIAL |
| 5 | Architecture Decision Records | Registrar por qué se tomaron las decisiones. | ADOPTADA |
| 6 | Contrato mínimo de secciones | Estructura esencial común en todos los recursos. | ADOPTADA (graduada) |
| 7 | Grafo de dependencias | Ver cómo se relacionan los recursos. | APLAZADA |
| 8 | Mejora de la validación automática | Detectar inconsistencias automáticamente. | ADOPTADA (implementada) |
| 9 | Ciclo de vida del recurso | Definir el flujo de madurez de un recurso. | ADOPTADA |
| 10 | Métricas automáticas | Evaluar la salud del Workbench. | APLAZADA |
| 11 | Manifiesto del Workbench | Describir el Workbench de forma máquina-legible. | APLAZADA |
| 12 | Preparación para consumo por IA | Índices globales para agentes. | APLAZADA |
| 13 | Sistema de etiquetas | Localizar recursos relacionados por tema. | PARCIAL |
| 14 | Reglas de gobernanza | Evitar el crecimiento descontrolado. | ADOPTADA |
| 15 | Mantenimiento de la filosofía actual | Construir sobre la estructura existente. | RESTRICCIÓN |

## Detalle

### 1. Metadatos en todos los recursos — ADOPTADA (versión mínima)

**Intención**: que todo recurso reutilizable comience con un bloque de
metadatos uniforme —qué hace, cuándo utilizarlo, de qué depende, qué otros
recursos lo utilizan— para poder indexarlo sin abrir cada archivo y ahorrar
tokens de contexto.

Los recursos reutilizables llevarán un frontmatter uniforme en inglés.

Campos obligatorios:

- `name`
- `type`
- `version`
- `status`
- `purpose`
- `tags`

Campos opcionales:

- `dependencies`

**No** se almacena `used_by`: es una relación inversa que se queda obsoleta
al escribirse. Debe derivarse del análisis, no mantenerse a mano.

Hoy disponen de frontmatter `core/sdd/SKILL.md` y
`workflows/commands/check-consistency.md`. La incorporación de metadata es
incremental: ningún recurso existente se rompe por carecer de ella, pero todo
recurso nuevo deberá incluirla.

Relacionado: ADR 0002 (idioma del frontmatter), fichas 3, 13 y 14.

### 2. Índices automáticos (INDEX.md) — APLAZADA

**Intención**: que cada directorio importante contenga un `INDEX.md` con su
propósito, los recursos disponibles, una breve descripción, sus dependencias y
los documentos relacionados, generado automáticamente a partir de la metadata.

Con el volumen actual el árbol de directorios ya permite descubrir los
recursos. Un índice manual duplicaría información y quedaría desactualizado.

Solo tiene sentido cuando exista un script que lo genere a partir de la
metadata de la ficha 1. Se retoma junto a las fichas 7, 10 y 12.

### 3. Estados de madurez — ADOPTADA

**Intención**: que un agente o una persona sepa de inmediato si un recurso está
terminado o es un borrador, sin depender de leerlo completo.

Todo recurso indicará su estado mediante el campo `status`:

- `draft`
- `experimental`
- `stable`
- `deprecated`
- `archived`

El estado debe reflejarse en la metadata y mantenerse sincronizado con el ciclo
de vida de la ficha 9. La validación de la ficha 8 comprobará que los valores
son válidos.

Relacionado: fichas 1, 8, 9 y 14.

### 4. Versionado interno — PARCIAL

**Intención**: evitar que los agentes utilicen metodologías antiguas sin saberlo
y poder saber cuándo cambió cada recurso.

Se adopta únicamente el campo `version` en la metadata, y solo aporta valor
cuando el contenido de la metodología cambia de forma relevante (no en cada
edición del fichero).

**No** se incorpora un changelog por recurso: `git log` ya constituye el
historial del repositorio, y duplicarlo viola el principio de simplicidad.

Relacionado: ficha 1.

### 5. Architecture Decision Records — ADOPTADA

**Intención**: que las decisiones arquitectónicas relevantes no se pierdan y que
dentro de un tiempo se pueda recordar por qué se tomó cada una.

Las decisiones arquitectónicas relevantes se documentan como ADR en
`docs/decisions/`, con formato `NNNN-titulo.md`.

Cada ADR responde a:

- contexto
- decisión
- consecuencias
- alternativas descartadas

Ya se han registrado las decisiones tomadas hasta la fecha (ADR 0001 a 0004).
No se crea un ADR por cada recurso, solo por decisiones que afecten a la
arquitectura o las convenciones del conjunto.

### 6. Contrato mínimo de secciones — ADOPTADA (graduada)

**Intención**: que todos los recursos respondan a las mismas preguntas
esenciales (propósito, responsabilidades, cuándo usar, cuándo no, dependencias,
ejemplos, relacionados) para que la estructura sea predecible y fácil de
aprender por máquinas y personas.

Los recursos responden como mínimo a las siguientes preguntas, pero el contrato
se gradúa por tipo para no añadir ruido:

- **Skills y commands**: propósito, responsabilidades, cuándo usar, cuándo no
  usar, dependencias, ejemplos y recursos relacionados.
- **Templates y examples**: solo propósito y ámbito de aplicación.

`SKILL.md` ya cubre las secciones "Cuándo usar" y "Cuándo NO usar"
(`core/sdd/SKILL.md`, secciones "Cuándo usar" y "Cuándo NO usar"). El contrato
completa la estructura existente, no la sustituye.

### 7. Grafo de dependencias — APLAZADA

**Intención**: disponer de una visión global de cómo se relacionan los recursos
entre sí, generada automáticamente a partir de la metadata (p. ej. en Mermaid),
para facilitar el mantenimiento.

Con un skill y cuatro tipos de recursos, el grafo estaría vacío. Es un
subproducto de la metadata de la ficha 1: se genera automáticamente cuando
exista una red de dependencias que merezca visualizarse (por ejemplo, en
Mermaid).

### 8. Mejora de la validación automática — ADOPTADA (implementada)

**Intención**: detectar automáticamente inconsistencias (enlaces rotos, recursos
sin metadata, versiones duplicadas, recursos huérfanos, estados inválidos,
dependencias circulares, etc.) en lugar de depender de la revisión manual.

La validación ya existe y funciona (`workflows/commands/check-consistency.sh`
más el command `workflows/commands/check-consistency.md`). Es el punto de apoyo
de la gobernanza y encaja con la filosofía del repositorio.

Ampliaciones implementadas (ver ADR 0004), todas verificables mecánicamente:

- enlaces relativos rotos
- recursos sin metadata obligatoria
- estados (`status`) inválidos
- recursos huérfanos
- directorios vacíos sin `.gitkeep`
- referencias a ficheros inexistentes

La metadata de los recursos con frontmatter (`SKILL.md` y
`check-consistency.md`) se completó como parte de la adopción para que la
validación pase limpiamente y siente precedente.

Relacionado: fichas 1, 3, 14 y 10 (informe de métricas).

### 9. Ciclo de vida del recurso — ADOPTADA

**Intención**: definir un flujo de madurez claro (Draft → Experimental →
Stable → Deprecated → Archived) que facilite la gobernanza del repositorio y
dé significado a los estados de la ficha 3.

Se documenta el ciclo de vida de un recurso:

```
draft → experimental → stable → deprecated → archived
```

La transición a `stable` o `deprecated` requiere una revisión explícita. La
gobernanza de la ficha 14 se apoya en este ciclo.

Relacionado: ficha 3.

### 10. Métricas automáticas — APLAZADA

**Intención**: generar un informe automático (número de skills, workflows,
tecnologías, documentos sin revisar, cobertura de metadata, recursos huérfanos,
etc.) para evaluar la salud del Workbench.

Con el volumen actual las métricas son triviales de obtener a mano. Cuando el
repositorio crezca, el informe de métricas (nº de recursos por tipo, cobertura
de metadata, recursos huérfanos, estados) se generará como salida del mismo
tooling de validación de la ficha 8.

### 11. Manifiesto del Workbench — APLAZADA

**Intención**: disponer de un fichero máquina-legible (`workbench.manifest.json`
o `workbench.yaml`) que describa el Workbench completo: nombre, versión, módulos
y requisitos, para facilitar futuras herramientas automáticas.

Un `workbench.manifest.json` solo aporta valor cuando existen consumidores
automáticos. Hoy los únicos consumidores son opencode y un humano, que ya
disponen del árbol y del README. Se evalúa cuando aparezca tooling externo.

### 12. Preparación para consumo por IA — APLAZADA

**Intención**: que un agente pueda descubrir recursos sin recorrer todo el árbol,
mediante índices globales generados automáticamente (por tipo, por etiqueta, por
dependencia, por tecnología, por workflow).

Los índices globales (por tipo, por etiqueta, por tecnología, por workflow) son
subproductos de la metadata y del tooling. Se retoman junto a las fichas 2, 7 y
10, cuando el repositorio lo justifique.

### 13. Sistema de etiquetas — PARCIAL

**Intención**: permitir localizar recursos relacionados mediante etiquetas
temáticas (docker, security, architecture, frontend, backend, testing, ci,
deployment, sdd).

Se incorpora el campo `tags` al esquema de metadata de la ficha 1, con una
taxonomía inicial acotada (p. ej. `sdd`, `architecture`, `testing`, `ci`,
`deployment`).

**No** se construyen índices por etiqueta todavía: quedan pendientes de la
generación automática de las fichas 2 y 12.

### 14. Reglas de gobernanza — ADOPTADA

**Intención**: evitar que el repositorio se convierta en un "cajón de sastre"
estableciendo reglas verificables (ningún recurso sin metadata, sin propósito,
sin estado, sin versión, sin relaciones conocidas).

Se codifican como convenciones verificables las reglas que ya existen o se
adoptan aquí:

- ningún recurso sin propósito
- ningún recurso sin documentación mínima
- ningún recurso sin estado
- ningún recurso sin metadata (ficheros nuevos)

El campo `owner` de la propuesta original se descarta: en un repositorio
personal la propiedad es implícita y añade ruido. Las reglas se verifican con la
validación de la ficha 8.

Relacionado: ADR 0003, ficha 8.

### 15. Mantenimiento de la filosofía actual — RESTRICCIÓN

**Intención**: garantizar que todas las mejoras se construyan sobre la
estructura existente —autodescriptiva, indexable, validable, gobernable y
escalable— sin sustituir su organización conceptual.

No es una acción, sino la restricción que condiciona todas las demás: las
mejoras se construyen sobre la estructura existente, sin reemplazarla. La
organización conceptual en cuatro dominios (core, technologies, workflows,
docs) se mantiene. Ver ADR 0001.

## Cómo usar este documento

- Al adoptar una ficha aplazada, se mueve a ADOPTADA con la justificación de
  cuándo y por qué.
- Al tomar una decisión arquitectónica nueva, se crea un ADR en
  `docs/decisions/` y se enlaza desde la ficha correspondiente.
- Los estados se mantienen sincronizados con `docs/conventions.md`,
  `docs/architecture.md` y el command de consistencia.
