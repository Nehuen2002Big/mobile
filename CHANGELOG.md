# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-AR/1.1.0/)
y versionado siguiendo [Semantic Versioning](https://semver.org/lang/es/).

## [No publicado]

### Añadido

- **Design system dark IsaTech** — la app pasa de light Material 3
  (seed `#0A5CA8`) al theme oscuro de la plataforma.
  - `lib/ui/theme/app_theme.dart` reescrito: `ColorScheme` hand-rolled
    con paleta zinc, fondo `zinc-950`, cards `zinc-900`, botón primario
    **blanco** (`zinc-100`), cyan-400 como acento (cursor, selección,
    label flotante, acción de SnackBar), FAB amber. Exporta `IsaColors`
    e `IsaRadii`.
  - Tipografías vía `google_fonts ^6.2.1`: Syne (headings), Plus
    Jakarta Sans (body).
  - `lib/ui/widgets/isa_widgets.dart` (nuevo): `IsaStatusPill`,
    `IsaStatusDot`, `IsaTopoBackground`, `IsaGradientText`.
- **Checklist de salida (MC-022)** — el chofer verifica los ítems que
  definió el operador antes de salir.
  - `GET /trips/{id}/checklist` + `POST .../items/{key}/check` +
    `.../uncheck` en `TripsRepository`.
  - `TripChecklist` / `ChecklistItem` planos (sin `build_runner`).
  - `TripChecklistNotifier` family por `tripId`: toggle optimista con
    cola in-memory que se vacía al volver la red.
  - `ChecklistSection` con progress bar, haptic al tildar y timestamps
    relativos.
  - Botón "Iniciar viaje" bloqueado hasta completar, con label
    `Falta completar checklist (N/M)`; el gate tiene prioridad sobre el
    de proximidad.
- **Gate de admin para el simulador de ubicación** — `AuthUser.esAdmin`
  (rol `admin` en el JWT). El botón del AppBar y la ruta
  `/debug/ubicacion` ahora exigen `kDebugMode && esAdmin`; el chofer
  común no puede llegar al simulador ni por deep-link.

### Cambiado

- **Chat migrado al dark theme** — las burbujas de `[VIAJE ASIGNADO]`,
  `[VIAJE EN COLA]` y `[VIAJE LISTO]` usaban `Colors.*.shade50` con
  texto `shade900` (theme light): sobre `zinc-950` se veían como
  bloques claros que rompían la pantalla. Pasan a tints translúcidos
  cyan / zinc / emerald con los mismos valores que `IsaStatusPill`.
- **Textos**: agregadas tildes y ñ en ~13 strings visibles al chofer
  ("Contraseña", "Tu posición", "Sesión expirada", "ubicación",
  "teléfono", "camión", "No tenés viajes asignados", "Estás en el
  origen. Ya podés iniciar", entre otros).
- **`README.md`**: corregida la sección de permisos Android, que
  afirmaba tener declarados `ACCESS_BACKGROUND_LOCATION` y `VIBRATE`
  (ninguno de los dos está en el manifest) y un `<queries>` con `geo:`
  (solo tiene `tel:` y `https:`). Documentado por qué no hacen falta.
  `minSdkVersion` actualizado: lo fija Flutter (24), no 23.

### Bugfix

- **AppBar con el título pegado al borde izquierdo** — el
  `titleSpacing: 0` del theme nuevo dejaba "Mis viajes" sin margen en
  pantallas sin botón de back. Vuelve al default de Material (16).
- **404 del checklist tratado como error** — `GET /checklist` devuelve
  404 en viajes sin checklist definido (todos los previos a MC-022) y
  la app mostraba "Not Found" al abrir el viaje. Ahora se interpreta
  como checklist vacío: la sección se autocolapsa y no bloquea el
  inicio.
- **Flicker del banner "No estás reportando ubicación"** — aparecía
  1-2s al abrir un viaje activo mientras el watchdog todavía arrancaba
  el GPS. `_BannerGpsCaido` ahora espera un warmup de 1.5s antes de
  renderizar.

### Verificado

- `flutter analyze`: 134 issues, idéntico al baseline previo (todos
  `info` pre-existentes: `require_trailing_commas` en `.g.dart`
  generados, `avoid_print` en debug).
- QA en emulador (AVD `moto_g52_sim`, Android 13, 1080×2400) contra
  backend de producción: login, listado de viajes, detalle de viaje
  pendiente, chat y **"Llevarme al origen"** (dispara
  `action.VIEW dat=geo:` → Google Maps, confirmado por logcat).

### Pendiente / detectado sin resolver

- **MC-011 reproducido en vivo**: el chat cobra `401 Sesión expirada`
  a los ~6 minutos del login y **la app no hace logout** — el error se
  traga en `ChatNotifier` sin llegar a `onUnauthorized`. Compatible con
  dos isolates (principal + foreground service) refrescando tokens en
  paralelo y pisándose la rotación del refresh token.
- `gps.ultimoError` se renderiza crudo en la pantalla de viaje activo
  (el chofer ve `TimeoutException after 0:00:08.000000...`). Ver
  `TODO(MC-022-followup)` en `viaje_activo_screen.dart`.
- Textos sin tildes restantes en `gps_service`, `recorrido_section`,
  `navegacion_screen`, repos de red y el simulador de ubicación.

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
