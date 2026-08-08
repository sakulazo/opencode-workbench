# SpecKit o el flujo SDD del Workbench

## Propósito

Este documento establece cuándo conviene utilizar **SpecKit** (la herramienta
estándar de la industria) y cuándo el **flujo SDD del Workbench** (el skill
`sdd` en `core/`). Existe una tensión legítima detrás de esta pregunta: el
mercado tiende a valorar a quien maneja las herramientas estándar, no a quien
construye ecosistemas propios. Este documento acepta esa tensión y la convierte
en un criterio de decisión explícito, no en una postura corporativa.

La regla transversal de todo el repositorio es la misma que se documenta en
[docs/usage.md](usage.md): **una sola fuente de verdad por proyecto y un solo
proceso**. Esta ficha no introduce una excepción: define cómo elegir una de las
dos vías en cada contexto.

---

## Posicionamiento

OpenCode Workbench **no compite con SpecKit**. SpecKit es el estándar de facto
de Specification-Driven Development (SDD) mantenido por GitHub; el Workbench es
una biblioteca personal de metodología, gobernanza y validación que se apoya en
los estándares cuando es razonable hacerlo.

La clave conceptual de [docs/philosophy.md](philosophy.md) es aplicable aquí:
la metodología es una capa, la herramienta es un medio. SpecKit implementa un
proceso; el Workbench documenta cómo se define ese proceso y cómo se verifica.
Por eso ambas opciones son compatibles en el repositorio, y en un proyecto real
elegir una no excluye usar la otra como criterio de calidad.

## Los dos caminos en una tabla

| Aspecto | SpecKit (estándar) | Flujo SDD del Workbench |
| --- | --- | --- |
| Origen | Kit open source de GitHub | Biblioteca personal de metodología |
| Instalación | `specify init . --integration opencode` | Copia del skill `sdd` a `.opencode/skills/` |
| Artefactos | `specs/<feature>/{spec,plan,tasks}.md` | `.specs/{requirements,design,tasks,validation}.md` |
| Comandos | `/speckit.*` | Flujo del skill + `validate-spec` |
| Validación | Checklists y análisis de coherencia | `validate-spec.md` (dos momentos) |
| Ecosistema | Extensiones, presets y bundles | Recursos auxiliares propios |
| Madurez del proceso | Sigue el estándar (guardrails, comunidad) | Personalizado y estable |
| Mantenimiento | Sigues la versión de la herramienta | Conservado en este repositorio |
| Portabilidad de artefactos | Convención reconocida por el ecosistema | Artefactos con trazabilidad propia |
| Valor de mercado | Alta alineación con el estándar | Solo si se traduce en criterio de calidad |

## Criterios de decisión

### 1. El contexto del trabajo domina la elección

La elección entre SpecKit y el flujo del Workbench raramente es técnica: es
contextual.

- **En un proyecto personal o una tarea de aprendizaje**: no hay un "guardrail"
  externo; conviene aplicar el flujo SDD del Workbench para fijar el método y
  no sacar nada sin validar.
- **En un entorno profesional o colaborativo**: el estándar se impone. Quien
  llega a un equipo sabe que SpecKit existe y cómo se usa; la adaptación del
  flujo propio es un activo de conversación que muestra criterio, no sustituye
  al estándar.

### 2. La empleabilidad valora el estándar, no la personalización

La pregunta "¿estoy haciendo algo positivo o creando algo que no va a servir?"
tiene una respuesta honesta en este repositorio:

- **SpecKit aporta empleabilidad directa**: es el skill transferible que la
  industria reconoce. Cuando cambies de proyecto o de empresa, `specify init`,
  `specs/<feature>/` y `/speckit.*` serán herramientas del día siguiente.
- **El Workbench aporta una ventaja indirecta**: entender por qué el estándar
  estructura el proceso de esa forma, tener criterio de validación propio y
  transmitir calidad. Eso valoriza la adaptación al estándar, no la rivaliza.

No se debe confundir: **aprender SpecKit es negociable; mantener un skill
propio como práctica principal no lo es**. Si se usa el Workbench, que sea
para profundizar en cómo funciona el estándar o cubrir un vacío específico, no
para reemplazarlo por defecto.

### 3. Portabilidad de los artefactos

- `specs/<feature>/` de SpecKit es una convención que entienden distintos
  agentes y equipos. Si los artefactos van a sobrevivir al proyecto o van a
  leerse fuera, SpecKit gana la elección.
- `.specs/` del flujo SDD propio es autónomo, está pensado para ser consumido
  por el propio skill (`validate-spec`, matrices de trazabilidad). Es más
  autocontenido pero menos interoperable.

### 4. Coste de mantenimiento

- SpecKit se actualiza upstream y tiene un ecosistema (extensiones, presets,
  bundles). El mantenimiento es recibir la nueva versión y reverificar.
- El Workbench es pequeño: un skill, plantillas, un validador. El coste de
  mantenerlo es bajo mientras siga siendo una capa delgada.

Ese coste es una señal de alarma en ambos sentidos: si el Workbench empieza a
exigir mantenimiento de packaging, instaladores o integraciones complejas, es
un factor para volver al estándar en más proyectos.

### 5. Coherencia con el repositorio

El Workbench mismo no usa SpecKit para su propia gobernanza: usa su flujo SDD.
Pero eso no contradice la regla de este documento: en un proyecto real con
OpenCode, el esqueleto del proceso debe reproducir SpecKit como lo hace la
industria, y el skill `sdd` se usa como **criterio de calidad** (`validate-spec`,
checklists) sobre los artefactos del estándar.

Esto se alinea con la primera estrategia documentada en
[docs/usage.md](usage.md): "SpecKit como orquestador, Workbench como criterio
de calidad".

## Árbol de decisión

```
¿Existe ya un flujo instalado en el proyecto (SpecKit o el skill)?
├─ Sí (SpecKit) ────────────────▶ Usa SpecKit; si es preciso, aplica
│                                  validate-spec como criterio de calidad.
├─ Sí (skill del Workbench) ─────▶ Usa el skill; convalida contra el proceso
│                                  definido en su metodología.
└─ No → ¿el proyecto necesita interoperabilidad con un equipo/empresa?
   ├─ Sí ──▶ Inicializa con SpecKit (`specify init`).
   └─ No ──▶ ¿quieres aprender el proceso o cubrir un vacío concreto?
      ├─ Sí ──▶ Usa el flujo SDD del Workbench (con metas docentes).
      └─ No ──▶ Usa SpecKit; el estándar cubre el caso habitual.

En ambos casos: una sola fuente de verdad para los artefactos y un solo
proceso a la vez (regla de [usage.md](usage.md)).
```

## Recomendación pragmática

Para la mayoría de los proyectos y cualquier entorno laboral, la elección por
defecto es **SpecKit**. El Workbench no es una alternativa, es:

- la documentación de *cómo* se define y valida el proceso SDD;
- una capa de gobernanza verificable para este propio repositorio;
- un recurso de aprendizaje que permite **entender** el estándar antes de
  depender de él.

Usa el Workbench desde esa óptica: como conocimiento que valora el uso del
estándar y que recorta el coste de lo que queda. Eso convierte una isla con
potencial de acero en una capa delgada que se apoya en algo que la industria ya
sabe hacer.

## Relación con la gobernanza del repositorio

- La validación de SpecKit para el repositorio se documenta en
  [docs/usage.md](usage.md).
- Las convenciones de lenguaje y estructura que este documento respeta están en
  [docs/conventions.md](conventions.md).
- La metodología SDD del Workbench está en
  [methodology.md](../core/sdd/methodology.md), el proceso en
  [workflow.md](../core/sdd/workflow.md) y las checklists en
  [checklists.md](../core/sdd/checklists.md).
- La decisión de mantener una única fuente de verdad es transversal al
  repositorio y se refleja en [docs/architecture.md](architecture.md).

## Referencias externas

- [SpecKit (GitHub)](https://github.com/github/spec-kit)
- [SpecKit — documentación](https://github.github.io/spec-kit/)
