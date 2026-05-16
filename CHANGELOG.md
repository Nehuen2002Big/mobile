# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-AR/1.1.0/)
y versionado siguiendo [Semantic Versioning](https://semver.org/lang/es/).

## [0.2.0] — 2026-05-06

Sprint **mobile-changes** completo: 9 MCs (MC-001 a MC-009) cerrados
contra el roadmap de `docs/mobile-changes/INDEX.md` del backend.

### Añadido

- **Auth flow robusto** (MC-002 + MC-003 indirectos)
  - Sanity check al login: `GET /me/profile` (Persons) con retry
    exponencial 1s/2s/4s ante 5xx/network.
  - Bloqueo de no-choferes (`driver_profile == null`) con mensaje
    accionable: "Esta app es solo para choferes".
  - Refresh proactivo del JWT cuando faltan <60s para expirar
    (interceptor `onRequest` en `DioClient`).
  - Persistencia de `expires_at` en `flutter_secure_storage`.
  - 403 de tracking → mensaje accionable
    "Tu cuenta no tiene permisos para esta app".
- **Notificaciones del SO con app cerrada o minimizada** (MC-001)
  - Polling de `/alerts/pending-action` cada 15s en el isolate
    background del foreground service GPS.
  - Notificación con dos action buttons: "Estoy bien" (ack desde la
    barra sin abrir la app) y "Abrir app" (deep-link al viaje).
  - Set persistido de alertIds notificados — sin spam en cada tick.
  - Suprime notif del SO si la app está en foreground (banner +
    fake-call ya cubren).
  - Battery optimization opt-out en el `PermisosGateScreen` (no
    bloqueante).
- **Tipos de alerta nuevos** (MC-004)
  - EXCESO_VELOCIDAD, DETENCION_PROLONGADA, DESVIO_HORARIO con icono
    + color + label propios.
  - Helper compartido `lib/features/alertas/data/alert_styles.dart`
    con `alertTypeStyle()`, `escalationStyle()`, `alertSubtitle()`.
  - Insignias L1 / L2 / L3 visibles en chat, banner persistente y
    FakeCall.
  - Sub-texto explicativo para DEVICE_OFFLINE en chat y banner.
  - Campo `simulated: bool` parseado en `TrackingAlert` y
    `MessageAlertRef` (renderiza idéntico a una alerta real).
  - Fallback genérico (icon `error_outline` + label raw) para tipos
    desconocidos — no crashea ante un tipo nuevo del backend.
- **Banner persistente de pending-action** (MC-005)
  - Header con count y plural inteligente: "Tenés N alerta{s}
    que requiere{n} tu confirmación".
  - Lista compacta de hasta 3 items con icon + label + badge nivel
    + título corto + subtexto si DEVICE_OFFLINE.
  - "+ N más" cuando hay más de 3 alertas pendientes.
  - Botón "Ver detalles" abre bottom sheet con la lista completa
    (mensaje del backend, timestamp completo, sub-texto).
  - Botón "Recibido" optimista: oculta el banner instantáneo;
    si el POST falla restaura el snapshot.
- **Mensajes `[ATENDIDO ...]` atenuados** (MC-008)
  - Render con look gris suave + borde verde + icono ✓ "ATENDIDO
    L3 · POR EL OPERADOR".
  - Sin sonido, sin vibración, sin notif del SO al recibirse.
  - No abre fake-call ni dispara banner — la alerta a la que
    refieren ya está resuelta del lado server.

### Cambiado

- **FakeCall optimista** (MC-002)
  - Ringtone se corta antes del round-trip al backend
    (<100ms percibido).
  - Pantalla cierra al toque, sin animación tardía.
  - Si el ACK falla, fake-call se reabre con banner rojo + botón
    "Reintentar".
  - Auto-close cuando `pending-action.total → 0` (chofer postea
    mensaje al chat → backend auto-ackea → fake-call se cierra
    sola en <15s).
  - Race window de 5s: mensajes con alertId ackeado en los últimos
    5s no re-abren fake-call.
  - Header del FakeCall hereda icono + color del tipo de alerta
    (cuando el alertId está en pending-action).
- **Refresh inmediato del estado del viaje** (MC-003)
  - `_finalizar` usa el `Trip` del response del POST (no descarta).
  - Cancelación remota detectada vía `sendDataToMain` desde el
    bg isolate al recibir 409 → main isolate refresca + toast
    informativo "El viaje fue finalizado o cancelado" + vuelve al
    listado.
  - 400 al finish (trip ya cerrado) → snackbar suave
    "El viaje ya estaba cerrado", sin error rojo.
- **Tick inmediato post-acción del chofer** (MC-005)
  - `ChatNotifier.enviar` y `AlertasPanel._enviar` disparan
    `pendingActionNotifier.refrescar(tripId)` después del POST.
    Banner desaparece en <1s en lugar de esperar 12s al próximo
    poll.
- **Manejo de HTTP 423 en phone-location** (MC-009)
  - QA pause silenciosa: drop con log debug, sin error UI.
  - Respeta `seconds_remaining` (body) o `Retry-After` (header)
    para skipear ticks durante toda la pausa, no solo el primero.
  - Polls de mensajes y pending-action siguen corriendo durante la
    pausa.

### Removido

- **ACK manual local post-mensaje / post-alerta** (MC-006).
  El backend auto-ackea L2/L3 cuando el chofer postea un mensaje al
  chat o crea una alerta. La app solo dispara un tick inmediato del
  polling de pending-action — no duplica la lógica del ack.
  - Doc-comment explícito en `AlertasRepository.acknowledge`
    listando los call-sites legítimos para evitar regresiones.

### Verificado sin cambios

- **Suppression de DEVICE_OFFLINE** (MC-007). Audit del foreground
  service confirma que las 3 propiedades del watchdog se cumplen
  sin necesidad de cambios:
  - El ping se dispara aunque speed=0.
  - Intervalo de 15s muy por debajo del margen 1.5× threshold.
  - Loop arranca al ACTIVE y se detiene al finish/cancel.

### Bugfix

- Typo en `api_config.dart`: `personasBaseUrl` apuntaba a
  `api-people.isatech.net` (sin S) que no resuelve en DNS.
  Corregido a `api-persons.isatech.net`.
- Bug D del FakeCall: `Bad state: Cannot use "ref" after the widget
  was disposed` cuando el chofer tocaba "Necesito ayuda". Refactor:
  capturar `ref.read` ANTES del pop optimista.
- Bug F del FakeCall: spinner de "Estoy bien"/"Necesito ayuda" se
  quedaba cargando si `canPop()` devolvía false (deep-link
  cold-start). Ahora hace `navigator.go('/viaje/{id}')` como
  fallback.
- `TrackingAlert.tripId` y `alertType` ahora tienen `@Default('')`
  para tolerar nulls del backend sin crashear el ack del FakeCall.

### Pendiente para próximos sprints

Ver `docs/mobile-changes-followups/`:

- **MC-010** — Push real con FCM/APNs (sucesor robusto del polling
  de MC-001).
- **MC-011** — Refresh broker compartido entre isolates.
- **MC-012** — Exponer la API de Persons públicamente (infra).
- **MC-013** — Filtrar `/alerts/active` por chofer (backend).

---

## [0.1.0] — 2026-04-15

Versión inicial. Cubre login JWT, lista de viajes, detalle con hoja
de ruta, lifecycle PENDING → ACTIVE → FINISHED con validación de
proximidad, foreground service de phone-location, chat con polling
3s, alertas con foto obligatoria, cascada L1/L2/L3 escalonada, fake-
call full-screen, banner persistente, deep-links de notificación,
permisos gate, checkpoints con fotos, navegación turn-by-turn,
simulador de ubicación debug.
