# ADR-0005 — Gobernanza del organigrama de agentes

## Contexto

El Workbench ha definido gobernanza y validación para sus recursos en general
(ADR-0001, ADR-0004, fichas 1, 3, 8, 9 y 14 de la hoja de ruta), pero los
agentes han crecido sin una estructura de niveles: hoy conviven un orquestador
(`devops-manager`), un proceso (`sdd-driver`) y tres especialistas
(`vps-manager`, `iac-vps-expert`, `opencode-expert`) sin que el repositorio
defina quién decide, quién ejecuta o cómo se delega. Al añadir un agente o
subagente nuevo no existe ninguna comprobación que garantice que encaja en el
conjunto.

## Decisión

Adoptar un modelo de roles de tres niveles más una capa de conocimiento, y
validar mecánicamente la incorporación de agentes:

1. **Niveles**: `orchestrator` (mode `primary`/`all`), `process` (mode `all`)
   y `specialist` (mode `subagent`/`all`). La capa de conocimiento son los
   skills de `core/` y `technologies/`, que los agentes cargan.
2. **Frontmatter de agente**: además de la metadata común (ficha 1), todo
   agente declara `mode`, `role` y `description`; y opcionalmente
   `delegates_to` (agentes a los que delega) y `skills` (skills que carga).
3. **Validación mecánica**: se amplía el script único `check-consistency.sh`
   con los checks 17 a 22 (frontmatter completo, `mode` válido, `name` igual
   al nombre de archivo, `role` coherente con `mode`, `delegates_to` a agentes
   existentes, `skills` a `SKILL.md` existentes).
4. **Retrolavado**: los agentes existentes se actualizan en esta decisión con
   `role`, `delegates_to` y `skills` para que la validación pase y sienten
   precedente.
5. **Documentación**: el modelo se define en `docs/organization.md`; todo
   agente debe documentarse en `docs/organization.md` y `docs/usage.md`.

## Consecuencias

- La incorporación de un agente nuevo queda verificable mecánicamente: si no
  declara frontmatter completo, un `mode` válido, un `role` coherente, o
  referencia agentes o skills inexistentes, el script falla antes de cerrar la
  tarea.
- Se introduce complejidad deliberada (dos campos nuevos y seis checks), en
  tensión con el principio de simplicidad de la filosofía. Se acepta porque
  responde a una necesidad explícita de gobernanza, se mantiene dentro del
  script único sin tooling nuevo, y solo afecta a `workflows/agents/`.
- Se introduce la dependencia declarativa `delegates_to` entre agentes, en
  tensión con el principio de independencia. Documenta la delegación real
  existente; se almacena en dirección hacia delante (nunca `used_by`, ficha 1).
- El campo `role` extiende la metadata común (ficha 1) de forma graduada para
  agentes, siguiendo el contrato mínimo graduado por tipo de la ficha 6.

## Alternativas descartadas

- **Inferir el nivel desde `mode`** (sin campo `role`): pierde la distinción
  entre `process` y `specialist` (ambos suelen ser `all`) y no permite validar
  la coherencia role ↔ mode.
- **Valores de `role` en español**: contradice la convención de frontmatter en
  inglés (ADR-0002) y dificulta el consumo por herramientas de IA.
- **Script de validación separado para agentes**: duplica el recorrido de
  ficheros y fragmenta la validación, contra el principio de simplicidad y el
  precedente de ADR-0004.

## Referencias

- [docs/organization.md](../organization.md) — modelo de roles y onboarding.
- [docs/conventions.md](../conventions.md) — frontmatter y reglas de agentes.
- [docs/architecture.md](../architecture.md) — responsabilidad de los agentes.
- [docs/roadmap.md](../roadmap.md) — fichas 1, 3, 6, 8, 9, 14 y 16.
- [workflows/commands/check-consistency.sh](../../workflows/commands/check-consistency.sh)
- [workflows/commands/check-consistency.md](../../workflows/commands/check-consistency.md)
- [workflows/templates/agent.md](../../workflows/templates/agent.md)
