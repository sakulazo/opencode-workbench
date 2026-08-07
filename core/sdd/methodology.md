# Metodología SDD

## Propósito

Definir los principios y criterios del **Specification-Driven Development (SDD)** en su orientación moderna: una metodología de desarrollo asistido por IA en la que la especificación es el artefacto central y la fuente de verdad.

Este documento es independiente de tecnología. Las decisiones de implementación concretas se describen en [workflow.md](workflow.md).

---

## Filosofía

SDD invierte el flujo habitual de desarrollo asistido por IA.

En el desarrollo conversacional ("vibe coding") se describe, se genera código y se itera hasta que "funciona". En SDD, primero se recoge el contexto, después se especifica, se diseña, se planifica y finalmente se implementa para validarlo contra la especificación.

La premisa central:

> **La especificación es una fuente de verdad ejecutable.** Define el comportamiento antes de que exista código, guía su generación y permite validar el resultado.

Cuando la IA hace que escribir código sea barato, el cuello de botella deja de ser la generación de código y pasa a ser **la definición del comportamiento correcto**.

---

## Principios

### 1. Spec-first

El *qué* y el *por qué* se definen antes que el *cómo*. Ningún código se genera hasta que la especificación esté aprobada.

### 2. Explicitud

La ambigüedad es la principal fuente de reescrituras y alucinaciones. Una especificación debe ser específica: entradas, salidas, condiciones, restricciones y comportamientos de error quedan escritos, no implícitos.

### 3. El humano orquesta, la IA ejecuta

Las decisiones de diseño las toma el humano (o se aprueban por él). La IA genera propuestas e implementa. El humano revisa en cada fase antes de avanzar.

### 4. Trazabilidad

Todo código generado debe poder trazarse hasta un requisito de la especificación, y toda la especificación debe estar cubierta por la implementación o explícitamente descartada.

### 5. Ejecutabilidad

La especificación debe ser directamente interpretable por herramientas de IA: tareas pequeñas y numeradas, criterios de aceptación verificables y lenguaje determinista.

### 6. Refinamiento iterativo

La especificación es un documento vivo. Se revisa, se cuestiona y se ajusta antes de implementar; los cambios de alcance durante la implementación vuelven a la especificación.

---

## Qué es una buena especificación

Una buena especificación define el **comportamiento externo** del software, no solo las intenciones del negocio:

- Mapeos de entrada → salida concretos.
- Precondiciones y postcondiciones.
- Invariantes y restricciones.
- Contratos e integraciones.
- Criterios de aceptación expresados con **Given / When / Then**.
- Casos límite y escenarios de error.
- Lenguaje ubicuo del dominio, no implementación concreta.
- Completa y concisa: cubre el camino crítico sin enumerar todos los casos.

### Señales de una especificación débil

- "El usuario puede iniciar sesión" (sin condiciones, contratos ni errores).
- Criterios de aceptación no medibles ("funciona bien", "carga rápido").
- Sin casos límite ni escenarios de error.
- Decisiones de diseño implícitas que la IA tendrá que adivinar.

---

## SDD frente a otras prácticas

| Aspecto | Vibe coding | SDD |
| --- | --- | --- |
| Proceso | Describir → Generar → Probar | Contexto → Especificar → Diseñar → Planificar → Implementar → Validar |
| Decisiones de diseño | La IA las toma | El humano las toma |
| Especificación | Vive en el historial del chat | Artefacto versionado |
| Aceptación | Aceptar si funciona | Aceptar si cumple la especificación |
| Mejor para | Prototipos, exploración | Sistemas complejos, cambios acoplados |

**SDD y TDD no son lo mismo**: TDD escribe primero las pruebas que guían el código; SDD escribe primero la especificación de comportamiento que guía el diseño, las tareas y la validación. Son complementarias: TDD se usa durante la implementación para verificar una tarea contra su criterio de aceptación.

**SDD y BDD comparten el lenguaje** (Given / When / Then) pero BDD formaliza escenarios en tests ejecutables; SDD usa ese lenguaje para especificar el alcance completo antes de la implementación.

---

## Cuándo usar SDD

Usar SDD cuando:

- El cambio tiene alcance, lógica o acoplamiento no trivial.
- Existen decisiones de diseño que deben tomarse antes de codificar.
- Se delega la implementación a una IA y la ambigüedad tiene coste.
- El cambio afecta a varios módulos o a contratos externos.

No usar SDD cuando:

- El cambio es trivial y su comportamiento no admite duda.
- Se explora o se prototipa con resultados descartables.
- La velocidad de experimentación importa más que la precisión.

---

## Roles

- **Humano**: define el objetivo, aprueba la especificación, revisa el diseño, acepta o rechaza el resultado.
- **IA**: transforma la intención en artefactos estructurados, propone diseño, implementa tareas y genera las pruebas.

La IA actúa como redactor técnico y ejecutor; el juicio de ingeniería permanece en el humano.

---

## Límites y riesgos

- **Spec drift**: el código se aleja de la especificación durante la implementación. Se mitiga implementando una tarea a la vez y validando al final.
- **Alucinación**: la IA inventa comportamiento no especificado. Se mitiga con especificaciones explícitas y verificación de conformidad.
- **Sobre-proceso**: especificar en exceso tareas triviales añade fricción. La elección de cuándo aplicar SDD es parte del método.
- **Especificaciones obsoletas**: una especificación que no evoluciona con el código pierde su valor. Toda modificación de alcance debe reflejarse en la especificación.

El proceso operativo se describe en [workflow.md](workflow.md).
