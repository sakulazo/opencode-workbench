# Checklists SDD

## Propósito

Listas de verificación operativas para ejecutar el [workflow.md](workflow.md). Se usan en cada fase y se responden con evidencia, no con suposiciones.

---

## 1. Decidir si aplicar SDD

- [ ] El cambio tiene lógica, alcance o acoplamiento no trivial.
- [ ] Existen decisiones de diseño que deben tomarse antes de codificar.
- [ ] La ambigüedad tendría un coste alto (reescrituras, alucinaciones).
- [ ] No es un cambio trivial ni un prototipo descartable.
- [ ] Se confirma la aplicación de SDD (si no, resolver de forma directa).

---

## 2. Calidad de la especificación (aplica a requirements y design)

- [ ] Cada requisito describe **comportamiento externo**, no intención vaga.
- [ ] Entradas, salidas y condiciones son concretas (nombres, tipos, valores).
- [ ] Precondiciones y postcondiciones están definidas.
- [ ] Los criterios de aceptación son **medibles y verificables**.
- [ ] No hay "funciona bien", "carga rápido" ni otras valoraciones no medibles.
- [ ] Casos límite y escenarios de error están cubiertos.
- [ ] Las restricciones (rendimiento, seguridad, compatibilidad) están escritas.
- [ ] El lenguaje es del dominio, sin decisiones de implementación implícitas.
- [ ] La especificación es completa en el camino crítico y concisa.

---

## 3. Revisión de requirements.md (Fase 1)

- [ ] Objetivo y alcance están definidos.
- [ ] Metas y no-metas son explícitas.
- [ ] Todo requisito funcional tiene criterios de aceptación Given / When / Then.
- [ ] Casos límite y errores enumerados.
- [ ] Supuestos y preguntas abiertas resueltos o registrados.
- [ ] No hay comportamiento que la IA deba adivinar.
- [ ] Aprobado por el humano.

---

## 4. Revisión de design.md (Fase 2)

- [ ] El diseño cubre todos los requisitos y restricciones.
- [ ] Decisiones relevantes tienen justificación y alternativa.
- [ ] Contratos explícitos (nombres, tipos, errores, integraciones).
- [ ] Modelo de datos y módulos afectados definidos.
- [ ] Riesgos identificados con mitigación.
- [ ] Aprobado por el humano.

---

## 5. Descomposición en tasks.md (Fase 3)

- [ ] Cada tarea es pequeña y con alcance acotado a ficheros concretos.
- [ ] Cada tarea tiene un criterio de aceptación verificable.
- [ ] Tareas numeradas (T1, T2, ...) con orden de ejecución.
- [ ] Dependencias entre tareas marcadas y respetadas por el orden.
- [ ] Todos los requisitos tienen tareas que los cubren (trazabilidad).
- [ ] Puerta pre-implementación ejecutada ([tests/validate-spec.md](tests/validate-spec.md)) sin FAIL sin excepción.
- [ ] Aprobado por el humano.

---

## 6. Durante la implementación (Fase 4)

- [ ] Se trabaja **una tarea a la vez**.
- [ ] Cada tarea se verifica (tests, compilación, revisión) antes de avanzar.
- [ ] No se amplía el alcance de una tarea en curso.
- [ ] Los hallazgos que cambian alcance se registran y vuelven a la especificación.
- [ ] La IA no decide diseño no especificado; pregunta o registra supuesto.
- [ ] Los cambios de alcance que llegan **fuera del flujo SDD** (sesión normal, sin pasar por especificar → diseñar → planificar) se avisan al humano y se propone actualizar la especificación antes de cerrar.

---

## 7. Verificación de cumplimiento antes de aceptar (Fase 5)

- [ ] Todos los criterios de aceptación verificados con evidencia.
- [ ] Todos los casos límite y errores probados.
- [ ] Matriz de trazabilidad especificación → pruebas completa.
- [ ] No hay requisitos sin cubrir ni código huérfano (código sin tarea).
- [ ] Revisión de ingeniería: seguridad, rendimiento, mantenibilidad.
- [ ] El humano acepta o registra excepciones justificadas.

---

## 8. Anti-patrones y señales de alarma

- [ ] Especificación vaga que la IA debe completar por su cuenta.
- [ ] Implementar "la feature completa" en lugar de tarea a tarea.
- [ ] Aceptar resultados porque "funcionan" sin comprobar la especificación.
- [ ] Especificaciones que envejecen sin reflejar cambios de alcance (*spec drift*).
- [ ] Decisiones de diseño tomadas durante la implementación sin registrarlas.
- [ ] Sobre-proceso: aplicar SDD a cambios triviales.

---

## Referencias

- Proceso: [workflow.md](workflow.md)
- Criterios de una buena especificación: [methodology.md](methodology.md)
- Validación automática: [tests/validate-spec.md](tests/validate-spec.md)
