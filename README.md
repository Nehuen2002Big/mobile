# mobile_isatech

App móvil (Flutter, Android-first) para los **choferes** de la
plataforma IsaTech Fleet Monitoring. Se conecta a los backends de
IsaTech (IAM, Persons, Tracking, Routes) para que el chofer pueda:

- Ver la hoja de ruta del viaje asignado (origen, destino,
  checkpoints, contactos, ETA).
- Iniciar / finalizar el viaje con validación de proximidad
  server-side.
- Reportar GPS continuo (foreground service Android, ~15 s).
- Recibir y atender alertas L1/L2/L3 con cascada de notificaciones,
  banner persistente y pantalla fake-call.
- Reportar alertas del chofer: TRAFICO, PARADA_COMER,
  PARADA_DESCANSAR (con/sin foto según tipo), AVERIA, ACCIDENTE.
- Chatear con el centro de monitoreo durante el viaje.
- Navegar turn-by-turn con voz, dibujo dinámico y auto-reroute.

---

## Para retomar el contexto en un chat nuevo

Esta sección es lo primero que tiene que leer cualquier asistente
que arranque a colaborar sobre este repo.

### Estado actual

- **Versión**: `0.2.0+2` (ver `pubspec.yaml`).
- **Sprint cerrado del lado código**: MC-014 a MC-021 (8 tickets de
  la iteración 2 de `mobile-changes`). Detalle de cada ticket en la
  sección "Sprint actual" abajo.
- **QA en curso**: ver `docs/qa-mc-014-mc-021.md` para el checklist
  con estado por ticket (✅ probado, ⏳ pendiente, ❌ rompe, ⚠️
  parcial).
- **Device de QA**: Moto G52, Android 13, serial `ZY22FTZNBH`.
- **Credenciales de QA**: chofer `chofer / chofer123`. Trip
  histórico de prueba: `VS-20260502-170827`.

### Reglas operativas (críticas, regla del ecosistema IsaTech)

1. **Español sin emojis** en todas las respuestas y en código.
   Documentación, comentarios y commits también en español.
2. **No buildear sin que el usuario lo pida explícito.** Cuando
   pida "buildear", arrancar `flutter run -d ZY22FTZNBH` (o el
   device que tenga). El usuario suele pedir solo análisis estático
   con `flutter analyze`.
3. **No correr `dart run build_runner`** sin avisar — modifica
   archivos `.freezed.dart` / `.g.dart` que el usuario quizá
   prefiera regenerar él. Cuando se pueda, evitar tocar modelos
   `@freezed` y usar clases planas con `fromJson` manual.
4. **Backend NO se toca desde acá.** Si hace falta un endpoint o
   cambio server-side, documentarlo y armar un prompt para que el
   usuario se lo pase al backend dev en otro chat.
5. **Cada ticket termina con criterio de aceptación probado** en
   QA real contra el device. La documentación de QA es
   `docs/qa-mc-014-mc-021.md`.
6. **Stay in scope**: si encontrás un refactor de paso, dejalo
   como `// TODO: ...` y avisá al usuario, no lo hagas inline.

### Cómo arrancar una sesión de trabajo

1. Leer este README completo.
2. Leer `docs/qa-mc-014-mc-021.md` (estado del sprint).
3. Leer `CHANGELOG.md` (qué se implementó cuándo).
4. Si vas a tocar un ticket nuevo, pedir al usuario que pegue el
   MD del ticket (formato `MC-XXX-titulo.md` que vive en el repo
   backend `isatech_tracking/docs/mobile-changes/`).
5. Plan corto (5-10 líneas) → OK del usuario → código → análisis
   estático → confirmación antes de buildear.

### Stack assumptions

- Flutter `>= 3.19`, Dart `>= 3.3`.
- Dio para HTTP, Riverpod 2.x para state, flutter_secure_storage
  para tokens, go_router para nav, flutter_foreground_task para el
  service de GPS, flutter_local_notifications para notif del SO,
  audioplayers + vibration para FakeCall y directivas, flutter_tts
  para voz turn-by-turn (MC-021), flutter_map para el mapa.
- Modelos con `@freezed` + `json_serializable` salvo donde aclare
  "clase plana" (ver `ResolvedRoadSheet`, `TripPauseStatus`).

---

## Sprint actual — MC-014 a MC-021

| ID | Título | QA |
|----|--------|-----|
| MC-014 | `PARADA_DESCANSAR` + sin foto para descansos + speed=0 pre-pause | ✅ (falta 422 `trip_not_stopped`) |
| MC-015 | UI de viaje en pausa + countdown + suppression awareness | ✅ |
| MC-016 | Movimiento durante pausa (alerta L3 + confirm/deny) | ⏳ |
| MC-017 | Render `[VIAJE ASIGNADO]` / `[VIAJE EN COLA]` / `[VIAJE LISTO]` | ⏳ |
| MC-018 | Directivas preset del operador `[OPERADOR · ...]` con overlay | ⏳ |
| MC-019 | Detect new trip assignments (background fetch + notif local) | ⏳ |
| MC-020 | Botón "Llevarme al origen" (deep link a Maps/Waze) | ✅ |
| MC-021 | Navegación turn-by-turn con voz + dibujo + auto-reroute | ⏳ |

Detalle exhaustivo de cada cambio en `CHANGELOG.md`. Detalle del
QA en `docs/qa-mc-014-mc-021.md`.

### Bug colateral resuelto durante MC-020

`origin` / `destination` se renderizaban como UUID/hash/`new:...`
crudos. Causa: la app asumía que todo string era UUID y hacía
lookup individual a `isatech_routes`. Fix: el backend agregó
`road_sheet._resolved` con nombres ya resueltos para los 3
formatos (UUID, `new:<lat>,<lon>:<base64>`, free-form), y la app
ahora usa los getters `trip.nombreOrigen` / `trip.nombreDestino`
con fallback al raw. Ver detalle en `docs/qa-mc-014-mc-021.md`
sección "Bugs encontrados".

`NombreUbicacion`, `LocationsRepository` y `locationByIdProvider`
quedaron deprecated de facto (sin callers). Se pueden borrar en un
follow-up.

---

## Arquitectura

```
lib/
  core/
    config/api_config.dart            Base URLs (IAM, Persons, Tracking, Routes)
    network/
      dio_client.dart                 Interceptors: JWT, refresh proactivo, 401 retry
      api_exception.dart
    storage/token_storage.dart        Secure storage de tokens + expires_at
    router/app_router.dart            GoRouter con guards
    providers.dart                    Riverpod providers
    utils/
      geo.dart                        haversineMeters + projectOnPolyline (MC-021)
      external_navigation.dart        Deep link a Maps/Waze (MC-020)

  features/
    auth/                             Login JWT, refresh, bootstrap
    perfil/                           GET /me/profile → person_id
    permisos/                         Gate de permisos (location, notifications,
                                      battery optimization opt-out)
    hoja_ruta/
      models/
        trip.dart                     Trip + getters nombreOrigen/Destino/origenLat/Lon
        road_sheet.dart               RoadSheet (origin/destination raw + 3 formatos)
        resolved_road_sheet.dart      Camino A: nombres resueltos por backend
      ui/trips_list_screen.dart       Home

    viaje/
      models/trip_pause_status.dart   MC-015: TripPauseStatus (clase plana)
      state/trip_pause_state.dart     MC-015: TripPauseNotifier (polling + ticker 1Hz)
      ui/
        viaje_pendiente_card.dart     MC-020: botón "Llevarme al origen"
        viaje_activo_screen.dart      Pantalla principal del viaje (banner, recorrido, etc)
        trip_pause_banner.dart        MC-015: banner verde/violeta con countdown

    alertas/
      models/
        alerta.dart                   AlertaTipo enum (con PARADA_DESCANSAR — MC-014)
        tracking_alert.dart           Con ruleType + extra (MC-016)
      data/
        prefijos_alerta.dart          Parser de prefijos del MONITOR (incluye los 4
                                      nuevos: viajeAsignado/EnCola/Listo + directivaOperador)
        alert_styles.dart             alertTypeStyle + alertHeaderStyle (con
                                      MOVEMENT_DURING_PAUSE override) + alertSubtitle
        alertas_repository.dart       Mapea 422 trip_not_stopped (MC-014)
        notificaciones_alertas.dart   3 canales: alertas críticas, chat normal,
                                      chat silencioso (MC-017)
      state/pending_action_state.dart Notifier con acknowledgeMovementDuringPause (MC-016)
      ui/
        alertas_panel.dart            Grid 5 botones + ramificado por requiereFoto (MC-014)
        pending_action_banner.dart    Sub-card "¿Fuiste vos?" para MOVEMENT (MC-016)
        fake_call_screen.dart         Cascada L3 (MC-002)
        operator_directive_overlay.dart  Overlay global (MC-018)

    chat/
      models/trip_message.dart
      state/
        chat_state.dart               4 ramas nuevas: viaje*/directivaOperador (MC-017+18)
        operator_directive.dart       Snapshot de directiva preset
      ui/chat_screen.dart             Render distintivo de 4 prefijos nuevos

    checkpoints/
      ui/recorrido_section.dart       Timeline con origen/destino/checkpoints

    ingest/
      service/
        gps_service.dart              Main isolate GPS
        gps_foreground_task.dart      BG isolate: ingest + polling /messages +
                                      pending-action + /trips (MC-019)

    navegacion/
      models/trip_navigation.dart     TripNavigation + Maneuver + Step
      data/navigation_repository.dart recomputar() acepta startLat/Lon (MC-021)
      service/
        turn_by_turn_voice.dart       MC-021: FlutterTts + buckets [1000,500,200,50]
        route_watcher.dart            MC-021: detect desvio + auto-reroute con debounce
      state/navegacion_state.dart     Con aplicarRecompute (MC-021)
      ui/navegacion_screen.dart       Mapa + 2 polylines (recorrido/restante) + snap

    uploads/                          Fotos de evidencia (camera + upload)
    locations/                        Deprecated tras Camino A — sin callers
    shared/                           proximity_error_helpers, etc.
    debug/                            Simulador de ubicación

  app.dart                            MaterialApp con OperatorDirectiveOverlay (MC-018)
  main.dart                           ProviderScope + bootstrap
  ui/theme/app_theme.dart
```

### Foreground service Android

`gps_foreground_task.dart` es el isolate separado que mantiene
vivo:

- Loop de ingest GPS (~15 s).
- Polling de `/messages` con detección de prefijos para disparar
  notif del SO (suprime cuando la app está en foreground vía
  `fgKeyAppForeground`).
- Polling de `/alerts/pending-action` con set persistente para no
  re-disparar notif por la misma alerta.
- Polling de `/trips` (MC-019, cada 2 ticks ≈ 30 s) con diff
  contra `fgKeyKnownTripIds` para detectar viajes nuevos.

---

## Endpoints consumidos

| Servicio | Método | Path | Uso |
|---|---|---|---|
| IAM | POST | `/api/v1/auth/login` | Login |
| IAM | POST | `/api/v1/auth/refresh` | Refresh JWT |
| IAM | GET | `/api/v1/auth/me` | Bootstrap de sesión |
| Persons | GET | `/api/v1/me/profile` | Resolver `person_id` + driver_profile |
| Tracking | GET | `/api/v1/trips` | Listado de viajes del chofer (filtrado server-side) |
| Tracking | GET | `/api/v1/trips/{id}` | Detalle + `params.road_sheet._resolved` |
| Tracking | POST | `/api/v1/trips/{id}/start` | Iniciar viaje con proximity check |
| Tracking | PATCH | `/api/v1/trips/{id}/finish` | Finalizar viaje |
| Tracking | GET | `/api/v1/trips/{id}/route-progress` | Cursor de step actual (MC-021) |
| Tracking | GET | `/api/v1/trips/{id}/navigation` | Polyline + steps + maneuvers (MC-021) |
| Tracking | POST | `/api/v1/trips/{id}/navigation/recompute?start_lat=&start_lon=` | Auto-reroute (MC-021) |
| Tracking | GET | `/api/v1/trips/{id}/pause/status` | Estado de pausa (MC-015) |
| Tracking | POST | `/api/v1/trips/{id}/pause/end` | Cancelar pausa (MC-015) |
| Tracking | POST | `/api/v1/trips/{id}/alerts` | Reportar alertas del chofer |
| Tracking | GET | `/api/v1/trips/{id}/alerts/pending-action` | L2/L3 pendientes de ack |
| Tracking | POST | `/api/v1/alerts/acknowledge` | Ack de alertas |
| Tracking | GET | `/api/v1/trips/{id}/messages` | Chat |
| Tracking | POST | `/api/v1/trips/{id}/messages` | Postear mensaje al chat |
| Tracking | POST | `/api/v1/ingest/{imei}` | Phone-location ingest |
| Tracking | POST | `/api/v1/uploads/evidence` | Subir foto |

---

## Setup

1. Flutter `>= 3.19` instalado + SDK de Android.
2. Conectar device (USB debugging) o emulador.
3. Instalar deps:
   ```
   flutter pub get
   ```
4. Confirmar entorno en `lib/core/config/api_config.dart`:
   ```
   static const ApiConfig current = ApiConfig.production;
   ```
   (Para emulador Android contra backend local usar `ApiConfig.local`
   — `10.0.2.2` mapea al `localhost` del host).
5. Correr:
   ```
   flutter run -d <serial-del-device>
   ```

### Permisos Android

`android/app/src/main/AndroidManifest.xml` ya tiene declarados:
INTERNET, ACCESS_FINE_LOCATION, ACCESS_BACKGROUND_LOCATION,
FOREGROUND_SERVICE, FOREGROUND_SERVICE_LOCATION, POST_NOTIFICATIONS,
VIBRATE, CAMERA, plus el bloque `<queries>` para `url_launcher` (geo
URIs + Maps/Waze deep links).

`minSdkVersion = 23` (requisito de `flutter_secure_storage`).

---

## Documentación interna

- `CHANGELOG.md` — cada release con detalle de añadidos / cambiados
  / removidos / verificados / bugfix.
- `docs/QA.md` — QA del sprint 0.1.0..0.2.0 (MC-001..MC-009).
- `docs/qa-mc-014-mc-021.md` — QA del sprint actual.
- `docs/mobile-changes-followups/` — tickets MC-010..MC-013 que
  quedaron pendientes (FCM real, refresh broker, etc).
- `docs/auth.md` — flujo de auth y refresh.

---

## Convenciones

- **Idioma**: español (UI, comentarios, commits, docs).
- **Sin emojis** en código ni respuestas.
- **Modelos**: preferir `@freezed` para shapes complejos del API;
  usar **clase plana con `fromJson` manual** cuando es chico y se
  quiere evitar codegen (ver `ResolvedRoadSheet`, `TripPauseStatus`,
  `OperatorDirective`).
- **Providers**: `core/providers.dart` centraliza todos los
  Provider/NotifierProvider/StateProvider.
- **Family providers** parametrizados por `tripId` para state por
  viaje (chat, pending-action, navegación, pausa, checkpoints).
- **Notifiers**: limpiar timers con `ref.onDispose` y arrancar polling
  con `Future.microtask(() => ...)` en el `build()`.
- **Naming**: snake_case para JSON del backend, camelCase para Dart
  (resuelto con `@JsonSerializable(fieldRename: FieldRename.snake)`).

---

## Pendientes / follow-ups

Ver `docs/mobile-changes-followups/`:

- **MC-010** — Push real con FCM/APNs (sucesor robusto del polling de
  MC-001 + MC-019).
- **MC-011** — Refresh broker compartido entre isolates.
- **MC-012** — Exponer Persons API públicamente (infra).
- **MC-013** — Filtrar `/alerts/active` por chofer (backend).
- **Limpieza opcional**: borrar `NombreUbicacion`,
  `LocationsRepository`, `locationByIdProvider` que quedaron
  deprecated tras el fix `_resolved`.
