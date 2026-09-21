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
- **MC-022 (checklist de salida)**: implementado del lado app. El
  operador define los ítems en la hoja de ruta y el chofer los tilda
  antes de salir; el botón "Iniciar viaje" queda bloqueado hasta
  completarlo. Ver "Checklist de salida (MC-022)" abajo.
- **Design system**: la app corre el **dark theme de la plataforma
  IsaTech** (zinc-950 / cyan-400 / botón primario blanco, tipografías
  Syne + Plus Jakarta Sans). Ver "Design system" abajo.
- **QA en curso**: ver `docs/qa-mc-014-mc-021.md` para el checklist
  con estado por ticket (✅ probado, ⏳ pendiente, ❌ rompe, ⚠️
  parcial).
- **Device de QA**: Moto G52, Android 13, serial `ZY22FTZNBH`.
- **Emulador de QA** (alternativa al device físico, útil para iterar
  UI sin cable): AVD `moto_g52_sim` — perfil Pixel 6 (1080×2400, misma
  resolución que el G52) con system image `android-33;google_apis;
  x86_64`. Ojo: en ese AVD **el GPS no se puede setear por consola**
  (`adb emu geo fix` no se aplica, los 4 providers quedan en
  `last location=null`). Para tener ubicación ahí, ver "GPS en
  emulador" abajo.
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

## Checklist de salida (MC-022)

El operador arma la lista de ítems al crear la hoja de ruta y **el
chofer los tilda desde la app** antes de salir. Eso convierte al
checklist en una verificación real de salida en vez de una marca
pro-forma del operador.

**Endpoints** (los tres son nuevos de MC-022):

| Método | Path | Uso |
|---|---|---|
| GET | `/trips/{id}/checklist` | Estado completo del checklist |
| POST | `/trips/{id}/checklist/items/{key}/check` | Tildar un ítem |
| POST | `/trips/{id}/checklist/items/{key}/uncheck` | Destildar un ítem |

**Comportamiento de la app**:

- La sección se muestra en viajes `PENDING` y `ACTIVE`, con progress
  bar `N / M` y timestamps relativos ("Marcado hace 2 min").
- El botón **"Iniciar viaje" queda bloqueado** hasta completarlo, con
  label dinámico `Falta completar checklist (N/M)`. Ese gate tiene
  prioridad sobre el de proximidad: primero verificás, después te
  movés al origen.
- **Tildar es optimista**: la UI cambia al instante y el POST va
  detrás. Si falla por red, el tilde queda visible y se reintenta en
  el próximo refresh (cola in-memory). Si el backend rechaza por
  permiso o estado (403 / 404 / 409), se revierte y se avisa.
- **Viajes sin checklist**: si el backend devuelve `items: []` o
  **404**, se trata como "no hay checklist" — la sección se
  autocolapsa y el botón "Iniciar viaje" no se bloquea. Es el caso de
  los viajes creados antes de MC-022.

Archivos: `features/viaje/models/trip_checklist.dart`,
`features/viaje/state/trip_checklist_state.dart`,
`features/viaje/ui/checklist_section.dart`, más los tres métodos en
`features/hoja_ruta/data/trips_repository.dart`.

---

## Design system

La app usa el **dark theme de la plataforma IsaTech**, el mismo
lenguaje visual que el SPA del operador.

- **Fondo** `zinc-950` (`#09090B`), cards `zinc-900`, bordes
  `zinc-800`.
- **Botón primario BLANCO** (`zinc-100` con texto `zinc-900`). El
  cyan **no** es el primario: se reserva como acento (cursor y
  selección de texto, label flotante de inputs, acción de SnackBar,
  branding).
- **Semánticos**: emerald (ok), amber (warning/pendiente), rose/red
  (danger), purple (eventos especiales L3).
- **Tipografías** vía `google_fonts`: Syne (headings), Plus Jakarta
  Sans (body), Space Mono (IDs técnicos y badges).

`lib/ui/theme/app_theme.dart` expone `buildAppTheme()` + las paletas
crudas `IsaColors` e `IsaRadii`. `lib/ui/widgets/isa_widgets.dart`
suma `IsaStatusPill`, `IsaStatusDot`, `IsaTopoBackground` e
`IsaGradientText`.

**Regla al agregar UI**: no hardcodear colores de Material
(`Colors.blue.shade50` y compañía son del theme light y sobre
`zinc-950` quedan como bloques claros). Usar `Theme.of(context)` o, si
hace falta un tint semántico, los valores de `IsaColors` con la misma
opacidad que `IsaStatusPill` (fondo `/10`–`/20`, texto en `300`/`400`,
borde `/30`–`/55`).

**Migración pendiente**: `fake_call_screen`, `navegacion_screen` (el
mapa) y el simulador de ubicación siguen con paleta propia
hand-rolled. El badge de estado de `trips_list_screen` todavía usa un
`_StatusChip` local en vez de `IsaStatusPill`.

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

### GPS en emulador

En el AVD `moto_g52_sim` el GPS **no engancha por consola**: `adb emu
geo fix` responde `OK` pero no se aplica (los cuatro providers quedan
en `last location=null`), así que `ubicacionActual()` siempre cae en
`TimeoutException` y las pantallas se quedan en "Buscando GPS...".

Hay dos caminos para darle ubicación:

**1. Inyectar coordenadas al compilar (recomendado, sin clicks)**

```
flutter run -d emulator-5554 \
  --dart-define=ISA_LAT=-34.6334845162455 \
  --dart-define=ISA_LON=-58.4616820881942
```

`GpsService` las levanta en el constructor y llama a `setOverride()`
— el mismo camino que usa el simulador de ubicación — así que el
ingest sigue reportando al backend, pero con esas coordenadas. Sin los
defines la app usa el GPS real y el branch se elimina por
tree-shaking en release.

Para usar **la ubicación real de la máquina de desarrollo** (Windows),
sacarla con la Location API del SO y pasarla a los defines:

```powershell
Add-Type -AssemblyName System.Device
$w = New-Object System.Device.Location.GeoCoordinateWatcher
$w.Start(); Start-Sleep -Seconds 3
"$($w.Position.Location.Latitude) $($w.Position.Location.Longitude)"
$w.Stop()
```

**2. Panel gráfico del emulador**

Botón `...` (Extended Controls) → **Location** → cargar Latitude /
Longitude → **SET LOCATION**. Sirve además para simular una ruta con
GPX/KML si hace falta probar movimiento.

### Permisos Android

`android/app/src/main/AndroidManifest.xml` declara exactamente estos
(verificado 2026-09-20 contra el manifest real):

| Permiso | Para qué |
|---|---|
| `INTERNET` | Todas las llamadas HTTP |
| `ACCESS_NETWORK_STATE` | Chequeo de conectividad |
| `ACCESS_FINE_LOCATION` | GPS del chofer |
| `ACCESS_COARSE_LOCATION` | Fallback de red |
| `FOREGROUND_SERVICE` | Service de ingest GPS |
| `FOREGROUND_SERVICE_LOCATION` | Tipo `location` del service (Android 14+) |
| `WAKE_LOCK` | Mantener el CPU despierto reportando GPS |
| `POST_NOTIFICATIONS` | Notif del SO (Android 13+) |
| `USE_FULL_SCREEN_INTENT` | Fake-call a pantalla completa (Android 14+) |
| `CALL_PHONE` | Llamar a los contactos de la hoja de ruta |
| `CAMERA` | Fotos de evidencia (AVERIA / ACCIDENTE / checkpoints) |

Más `<uses-feature android:name="android.hardware.camera"
android:required="false"/>` para no excluir del Play Store a devices
sin cámara.

**NO están declarados** (y no hacen falta):

- **`ACCESS_BACKGROUND_LOCATION`** — la app reporta GPS en background a
  través de un **foreground service de tipo `location`**, que es la vía
  legítima desde Android 10: mientras el service corra con su
  notificación visible alcanza con `ACCESS_FINE_LOCATION`. Pedir el
  permiso de background sumaría la fricción del flow "Permitir siempre"
  sin beneficio. (Versiones previas de este README afirmaban que estaba
  declarado — era incorrecto; `pm grant` lo rechaza con
  `has not requested permission`.)
- **`VIBRATE`** — la declara el AAR de `vibration` vía manifest merge;
  no hace falta repetirla acá.

El bloque `<queries>` (visibilidad de paquetes, Android 11+) declara
solo `PROCESS_TEXT`, `VIEW + tel:` y `VIEW + https:`. **No incluye
`geo:`** y no hace falta: `abrirNavegacionAOrigen()` usa `launchUrl()`
directo (no `canLaunchUrl`, que sí exigiría el query) y cae a
portapapeles si ningún app resuelve el URI. Ver
`lib/core/utils/external_navigation.dart`.

`minSdkVersion` lo fija Flutter (`flutter.minSdkVersion`): hoy **24**
con Flutter 3.44. `flutter_secure_storage` requiere ≥ 23, así que el
default lo cubre.

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
