# Auth flow — mobile_isatech

Documenta el flujo de autenticación de la app móvil del chofer contra
los servicios IAM y Persons del backend IsaTech.

## Servicios involucrados

| Servicio | Base URL (production)                | Endpoints usados                   |
| -------- | ------------------------------------ | ---------------------------------- |
| IAM      | `https://iam.isatech.net/api/v1`     | `POST /auth/login`, `POST /auth/refresh`, `GET /auth/me` |
| Persons  | `https://api-persons.isatech.net/api/v1` | `GET /me/profile` (sanity check de chofer) |
| Tracking | `https://api-tracking.isatech.net/api/v1` | todo el resto (trips, alerts, messages, ingest, …) |
| Routes   | `https://api-routes.isatech.net/api/v1` | navegación turn-by-turn |

Las URLs viven en `lib/core/config/api_config.dart` (`ApiConfig.production`
+ `ApiConfig.local` para desarrollo en emulador). El switch entre
ambas se hace cambiando la constante `ApiConfig.current`.

## Storage de tokens

Los tokens se persisten en `flutter_secure_storage`:

- iOS → Keychain (clase `FlutterSecureStorage` lo usa automáticamente).
- Android → EncryptedSharedPreferences (idem).

**No usar `SharedPreferences` plain ni `AsyncStorage` para tokens.**

Wrapper: `lib/core/storage/token_storage.dart`. Keys:

| Key                            | Contenido                              |
| ------------------------------ | -------------------------------------- |
| `isatech_access_token`         | JWT access (corto, ~15 min)            |
| `isatech_refresh_token`        | JWT refresh (largo, rotativo)          |
| `isatech_token_expires_at`     | ISO 8601 UTC del expiry del access     |
| `isatech_user_id`              | UUID del user IAM (cache)              |
| `isatech_person_id`            | UUID de la Person en Persons (cache)   |

Las keys `isatech_access_token` y `isatech_refresh_token` están
**duplicadas como constantes string en
`lib/features/ingest/service/gps_foreground_task.dart`** (`_kAccess`,
`_kRefresh`) — el isolate del foreground service no comparte memoria
con la UI y necesita leer los mismos slots. Si cambiás los nombres
acá, hay que cambiarlos allá.

## Flow de login

```
Usuario tipea credenciales
      │
      ▼
POST /auth/login           ← IAM
  body: { identifier, password }
      │
      ▼ 200 OK
{ access_token, refresh_token, expires_in, user }
      │
      ▼
TokenStorage.saveTokens(
  accessToken,
  refreshToken,
  expiresAt = now + expires_in,
)
      │
      ▼
GET /me/profile            ← Persons (sanity check)
  con bearer recién guardado
      │
      ├── 200 + driver_profile != null  → status=autenticado, perfil cacheado
      ├── 200 + driver_profile == null  → tokens.clear() + error
      │                                    "Esta app es solo para choferes"
      ├── 404                           → tokens.clear() + error
      │                                    "Tu cuenta no tiene perfil de chofer"
      └── 5xx / network                 → retry 1s, 2s, 4s; si sigue,
                                          tokens.clear() + error
                                          "Servicio no disponible — Reintentar"
```

`/me/profile` reemplaza la validación de scopes IAM
(`tracking:read` / `tracking:write`) — ya no es necesaria en mobile
porque el backend de Tracking filtra trips automáticamente cuando el
JWT corresponde a un chofer (lookup transparente vía Persons).

## Flow de refresh

### Refresh proactivo (preferido)

Cada `Dio` instance con `attachToken: true` tiene un interceptor
`onRequest` que:

1. Lee `expires_at` de TokenStorage.
2. Si falta menos de **60 segundos** para expirar, dispara
   `POST /auth/refresh` antes de adjuntar el token.
3. El refresh es serializado por un `Completer` — múltiples
   requests concurrentes esperan el mismo refresh, no triplican
   llamadas.

Esto evita el roundtrip extra de un retry post-401 cuando el chofer
abre la app después de un rato.

### Refresh reactivo (fallback)

Si una request devuelve `401`:

1. El interceptor `onError` chequea el flag `__retriedRefresh` en
   `request.extra` para evitar loops.
2. Llama a `_refreshIfPossible` (mismo `Completer` para
   serialización).
3. Si el refresh devuelve un nuevo `access_token`, retry-ea la
   request original UNA sola vez con el nuevo bearer.
4. Si el refresh también falla → llama al callback
   `onUnauthorized` configurado en el constructor del `DioClient`
   (en la app: `authNotifier.logout()`) y rechaza la request con
   `UnauthorizedException`.

### Body y response del refresh

```
POST /auth/refresh
{ "refresh_token": "..." }

→ 200
{ "access_token": "...", "refresh_token": "...", "expires_in": 900 }
```

`expires_in` es opcional en la response — si no viene, asumimos 900s
(default IAM). El nuevo `expires_at` se calcula y persiste.

## Flow de bootstrap (app abre con sesión guardada)

```
TokenStorage.readAccessToken()
  ├── null/empty → status=anonimo
  └── presente
       │
       ▼
GET /auth/me               ← IAM (verifica que el token sigue valido)
       │
       ▼ ok
GET /me/profile + retry    ← Persons (mismo sanity check del login)
       │
       ▼
status=autenticado
```

Si `/me/profile` rechaza al user (no es chofer / no tiene perfil), se
borran los tokens y el chofer cae en login con el mensaje del rechazo
visible en un banner persistente. La pantalla de login lo limpia con
la X o cuando arranca un nuevo intento.

## Manejo de 403

Algún endpoint de Tracking puede devolver `403 Forbidden` si el rol
del user no le alcanza. Estos casos se mapean en `mapDioError`
(`lib/core/network/dio_client.dart`) a un mensaje accionable:

> **"Tu cuenta no tiene permisos para esta app. Contactá al
> administrador."**

Si el backend incluye un `detail` específico en la response, se usa
ese en lugar del genérico.

## Logout

```
authNotifier.logout()
  ├── TokenStorage.clear()        ← borra access, refresh, expires_at,
  │                                  user_id, person_id
  └── state = AuthStateData(status: anonimo)
        │
        ▼
GoRouter detecta status=anonimo (vía `routerProvider.refreshListenable`)
        │
        ▼
redirect → /login
```

## Foreground service GPS — refresh independiente

El isolate del foreground service GPS
(`lib/features/ingest/service/gps_foreground_task.dart`) no comparte
estado con el isolate principal y **tiene su propio refresh** contra
`/auth/refresh`. Lee y escribe los mismos slots de `flutter_secure_storage`
(`isatech_access_token`, `isatech_refresh_token`).

**Edge case conocido:** si los dos isolates piden refresh simultáneamente
con el mismo refresh_token, IAM rota el jti — el primer refresh
invalida el segundo. El peor caso es un 401 → logout reactivo. No hay
corrupción de datos. Aceptable hasta cerrar los 9 MCs; refactor
posible: que el background isolate consulte al main por canal en
lugar de refrescar él mismo.

## Criterio de aceptación cumplido

- [x] Login con usuario válido devuelve access_token, se guarda
      seguro (Keychain / EncryptedSharedPreferences).
- [x] El token se refresca automáticamente antes de expirar
      (proactivo, <60s a expiry) y reactivamente al 401.
- [x] El interceptor HTTP retry-ea 1 vez con refresh si una request
      vuelve 401.
- [x] Logout borra los tokens y el router redirige a login.
- [x] Sanity check al login: `GET /me/profile` valida que sea chofer
      con retry exponencial 1s/2s/4s ante 5xx/network.
- [x] 403 de Tracking devuelve mensaje accionable
      ("Tu cuenta no tiene permisos…").
- [x] `/trips` filtra server-side por chofer — la app no necesita
      filtrar client-side.
