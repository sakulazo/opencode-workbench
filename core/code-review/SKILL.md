---
name: code-review
description: Checklists and severity criteria for rigorous code review. Use when reviewing diffs, pull requests or commits for correctness, security, performance, maintainability or tests. Triggers on review, revisar, PR, pull request, diff, code review.
type: skill
version: 1.0
status: experimental
purpose: Provide a structured review method and checklists (correctness, security, performance, maintainability, tests) with severity criteria so reviews are consistent and prioritized.
tags: [code-review, checklist, quality, security, review]
---

# Code Review

Skill de apoyo para el agente `code-reviewer` (y para cualquier revisión de
código en el Workbench). Define el método, las checklists por categoría y los
criterios de severidad.

## Cuándo usar

- Antes de fusionar un PR o aceptar un cambio.
- Después de implementar una tarea, como control de calidad.
- Cuando se sospecha una regresión, un problema de seguridad o deuda técnica.

## Método de revisión

1. **Entiende el cambio**: qué problema resuelve y por qué existe (contexto
   del PR, tests asociados).
2. **Lee el diff completo** antes de opinar; revisa también el contexto
   circundante.
3. **Aplica las checklists** de abajo a las líneas tocadas.
4. **Verifica**: ejecuta tests/build/lint dirigidos si es posible (no
   adivinanzas).
5. **Reporta**: hallazgos priorizados con ubicación, explicación y sugerencia.

## Categorías y checklists

### 1. Corrección

- Condiciones límite y casos vacíos (0 elementos, `null`, `undefined`,
  cadenas vacías).
- Errores de rango/índice (off-by-one), desbordamientos.
- Manejo de errores: excepciones capturadas y propagadas correctamente, sin
  tragarse errores.
- Estado compartido: carreras, concurrencia, mutaciones inesperadas.
- Cierre de recursos (archivos, conexiones, streams, timers, listeners).
- Cambios de formato/parseo con entradas no esperadas.
- Contratos de API: tipos, nullabilidad, compatibilidad hacia atrás.

### 2. Seguridad

- Inyección: SQL, comandos, path traversal, XSS (escape de salida).
- Autenticación/autorización: el cambio no elude controles ni amplía
  privilegios.
- Secretos: no se hardcodean claves, tokens ni credenciales; no se loguean.
- Entradas no confiables: validación en el límite de confianza (SSRF,
  deserialización).
- Dependencias: versiones vulnerables conocidas, lockfiles actualizados.
- Datos sensibles: cifrado en tránsito/reposo, minimización de datos
  personales.

### 3. Rendimiento

- Bucles anidados innecesarios, consultas N+1, repetición de trabajo costoso.
- Operaciones pesadas en el camino crítico sin carga diferida ni caché.
- Asignaciones o fugas de memoria en bucles o listeners.
- Índices de base de datos adecuados a las nuevas consultas.

### 4. Mantenibilidad

- Nombres claros y coherentes con el dominio.
- Complejidad ciclomática razonable: funciones cortas, sin banderas profundas.
- Sin duplicación evitable; extracción correcta de abstracciones.
- Documentación o ejemplos actualizados si el cambio afecta el comportamiento
  público.

### 5. Tests

- El cambio está cubierto por tests que fallan sin él (o justificación
  explícita).
- Casos límite y de error cubiertos, no solo el camino feliz.
- Los tests no son triviales ni están acoplados a la implementación interna.

## Criterios de severidad

| Severidad | Definición | Acción |
| --- | --- | --- |
| Blocker | Bug real, vulnerabilidad o regresión que rompe el comportamiento esperado. | Impide el merge. |
| Warning | Riesgo latente, deuda que empeorará o mantenibilidad deficiente. | Corregir pronto; puede esperar al merge. |
| Nit | Estilo, convenciones, mejoras menores. | Opcional; no bloquea. |

## Formato de salida

Veredicto (`approve` / `request changes`) → Resumen → Hallazgos priorizados →
Fortalezas → Verificación → Siguientes pasos.
