---
name: <agent-name>
description: <English description with activation keywords>
type: agent
version: 0.1
status: draft
purpose: <one sentence stating the agent responsibility>
tags: [<tags>]
model: opencode/big-pickle
mode: subagent
role: specialist
delegates_to: []
skills: []
permission:
  edit: ask
  bash:
    "*": ask
  webfetch: allow
  websearch: allow
---

# Rol: <Nombre del agente>

## Responsabilidades

1. <responsabilidad 1>
2. <responsabilidad 2>

## Conocimiento (skills que carga)

- `<skill>` de `core/` o `technologies/`.

## Reglas

- <regla 1>

## Formato de respuesta

1. **Diagnóstico**: qué se va a hacer y por qué.
2. **Plan**: pasos propuestos.
3. **Verificación**: cómo validar.
