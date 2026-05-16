# MC-010 — Push real con FCM / APNs

| Campo | Valor |
|---|---|
| Estado | pending |
| Priority | medium |
| Area | alerts / infra |
| Estimado | 1.5 sprints (~10 días code + setup) |
| Reemplaza | Opción A de MC-001 (background fetch + local notif) |
| Coordinación | Backend tracking + DevOps (cuenta Firebase + APNs cert) |

## Contexto

MC-001 se cerró con la **Opción A**: el isolate del foreground service
GPS pollea `/alerts/pending-action` y `/messages` cada 15s y dispara
notificaciones locales con `flutter_local_notifications`. Funciona
bien en celulares con la app activa, pero tiene tres limitaciones
operativas:

1. **Android Doze / battery saver agresivo** puede pausar el
   foreground service si el SO entra en idle profundo. Mitigamos
   con el opt-out de battery optimization en el `PermisosGateScreen`,
   pero algunos OEMs (Xiaomi, Oppo, Huawei) ignoran ese flag y
   matan el service igual.
2. **Polling cada 15s gasta batería innecesariamente** cuando no
   hay tráfico de alertas reales (90% del tiempo).
3. **iOS BGTaskScheduler es no-determinista** — el SO decide cuándo
   correr la tarea de background. No podemos garantizar latencia
   <30s para alertas L2/L3 en iOS sin push real.

## Solución

Implementar push real vía **Firebase Cloud Messaging** (cubre
Android + iOS desde un único stack) o **APNs directo** para iOS si
querés evitar el dependency a Firebase.

Recomendación: FCM para los dos OS — es lo más simple, Firebase ya
maneja el bridge a APNs internamente.

## Cambios mobile

### Setup

- Agregar `firebase_core` + `firebase_messaging` al `pubspec.yaml`.
- `android/app/build.gradle.kts`: agregar plugin `com.google.gms.google-services`.
- `android/build.gradle.kts`: classpath del plugin.
- `android/app/google-services.json` (gitignore-ado, lo provee DevOps).
- iOS: `GoogleService-Info.plist` + APNs certificate uploaded a
  Firebase Console.
- En `main.dart`, después de `WidgetsFlutterBinding.ensureInitialized()`:
  ```dart
  await Firebase.initializeApp();
  ```

### Token registration

Al loguearse OK (después del sanity check de `/me/profile`):

```dart
final fcmToken = await FirebaseMessaging.instance.getToken();
if (fcmToken != null) {
  await pushTokenRepo.registrar(token: fcmToken, provider: 'fcm');
}
// Renovaciones automaticas:
FirebaseMessaging.instance.onTokenRefresh.listen((nuevoToken) {
  pushTokenRepo.registrar(token: nuevoToken, provider: 'fcm');
});
```

### Endpoint nuevo (a coordinar con backend tracking)

```http
POST /api/v1/devices/me/push-token
Authorization: Bearer ...
Content-Type: application/json

{
  "provider": "fcm",
  "token": "...",
  "device_info": {
    "platform": "android",
    "os_version": "13",
    "app_version": "0.2.0+2"
  }
}
```

Respuesta 200: `{ "registered": true }`.

### Handler del push

```dart
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  // Tap en push con app en background → deep-link al viaje.
  final tripId = message.data['tripId'];
  final kind = message.data['kind']; // 'alerta' | 'llamada' | 'chat'
  // Reusar la lógica de NotificacionesAlertas tapStream.
});

FirebaseMessaging.onMessage.listen((message) {
  // App en foreground recibe el push. NO hacer nada — el polling
  // foreground (ChatNotifier) ya cubre el caso. Si lo dispatcheamos
  // de nuevo desde acá, duplicamos.
});

FirebaseMessaging.onBackgroundMessage(
  // Top-level @pragma('vm:entry-point').
  // Solo para iOS — Android usa el handler default que ya muestra
  // la notif. Si el payload trae kind=llamada, bumpear a fullScreenIntent.
  _onBgMessage,
);
```

### Logout

Al cerrar sesión:

```dart
await FirebaseMessaging.instance.deleteToken();
await pushTokenRepo.desregistrar(); // backend marca el token inactive
```

## Cambios backend (coordinar con equipo tracking)

- **Endpoint nuevo:** `POST /api/v1/devices/me/push-token`
  (gated por `tracking:write`).
- **Tabla nueva:** `push_tokens(user_id, token, provider, device_info, created_at, last_active_at, deleted_at)`.
- **Servicio nuevo:** `PushDispatchService` que se llama desde
  `MessageService.create_message` cuando el sender_role=MONITOR y
  el contenido es `[LLAMADA · ...]` o `[ACCION REQUERIDA · ...]` o
  `[ESCALADO A SUPERVISOR · ...]`. Resuelve el token activo del
  driver_person_id del trip y dispara FCM.
- **Cleanup job:** borrar tokens con `last_active_at < NOW() - 30d`
  o `deleted_at != NULL`.

Payload del push:

```json
{
  "data": {
    "kind": "llamada",
    "tripId": "VS-...",
    "alertId": 12345,
    "regla": "HIGH_SPEED",
    "contenido": "Velocidad 120 km/h"
  },
  "notification": {
    "title": "Llamada del monitoreo",
    "body": "120 km/h (límite 80)"
  },
  "android": {
    "priority": "high",
    "ttl": "60s"
  },
  "apns": {
    "headers": { "apns-priority": "10" },
    "payload": {
      "aps": { "interruption-level": "time-sensitive" }
    }
  }
}
```

## Migración Opción A → push real

Una vez que el push esté funcionando confirmado en QA:

1. Mantener el polling de Opción A activo durante 1 sprint como
   fallback (defensa en profundidad).
2. Reducir el intervalo del polling de 15s a 60s (para ahorrar
   batería pero mantener disponibilidad si Firebase tiene downtime).
3. Después del sprint, considerar bajarlo a 120s o eliminarlo si
   confiamos 100% en el push.

## Criterio de aceptación

- [ ] App **killeada** (no minimizada) recibe push <5s después de
      disparar L3 desde el simulador del operador.
- [ ] Tap en push abre la app directo en `/viaje/{id}` (o
      `/viaje/{id}/llamada` si es kind=llamada).
- [ ] Logout limpia el token del backend (no más pushes a ese device
      ni después de cerrar sesión).
- [ ] El polling de Opción A sigue funcionando como fallback durante
      1 sprint mínimo.
- [ ] Tokens viejos se purgan (>30d sin activity).

## Riesgos / decisiones abiertas

- **Costo Firebase**: el tier free de FCM cubre cantidades enormes
  de mensajes (no hay límite duro hoy). Confirmar con DevOps que
  la cuenta esté activa antes de empezar.
- **APNs cert renovation**: se vence cada año. Setear alarma en el
  calendario del equipo.
- **Privacy**: el `device_info` (versión OS + versión app) puede
  considerarse PII en algunas jurisdicciones. Revisar con legal
  antes de loggearlo del lado backend.
