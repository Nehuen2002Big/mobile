# mobile-changes-followups

Tickets que quedaron fuera del sprint anterior (MC-001 a MC-009) y
están agendados para sprints futuros. Cada uno tiene su archivo `.md`
con contexto, solución propuesta, criterio de aceptación y riesgos.

## Resumen

| ID | Título | Priority | Owner | Estado |
|---|---|---|---|---|
| [MC-010](./MC-010-fcm-push-notifications.md) | Push real con FCM/APNs | medium | mobile + backend + DevOps | pending |
| [MC-011](./MC-011-cross-isolate-refresh-broker.md) | Refresh broker entre isolates | low | mobile | pending |
| [MC-012](./MC-012-persons-public-url.md) | Persons API públicamente accesible | high | DevOps | mostly done |
| [MC-013](./MC-013-filter-alerts-active-by-driver.md) | Filtrar `/alerts/active` por chofer | medium | backend tracking | pending |

## Convenciones

- **MC-NNN** se asigna en orden cronológico, no de prioridad.
- Cuando un ticket se cierra, mover el archivo (o agregar la entrada)
  al `INDEX.md` del repo backend bajo "Hechos" con la fecha. La
  copia del repo mobile queda como histórico.
- Si un ticket termina siendo solo backend (ej. MC-013), igual lo
  documentamos acá porque el contexto operativo es del lado mobile.

## Roadmap original (sprint anterior — referencia)

Estos están **cerrados** y se trackean en `docs/QA.md` del repo
mobile + el `INDEX.md` del backend:

| ID | Título | Estado |
|---|---|---|
| MC-001 | Notif del SO con app cerrada | done (Opción A — polling) |
| MC-002 | FakeCall optimista | done |
| MC-003 | Refresh estado del viaje al finish/cancel | done |
| MC-004 | Tipos de alerta + nivel + DEVICE_OFFLINE render | done |
| MC-005 | Banner persistente pending-action | done |
| MC-006 | Quitar ACK manual local | done (era audit) |
| MC-007 | Suppression DEVICE_OFFLINE | done (era audit) |
| MC-008 | Render `[ATENDIDO]` atenuado | done |
| MC-009 | Manejo HTTP 423 (QA pause) | done |
