# MC-011 — Refresh broker compartido entre isolates

| Campo | Valor |
|---|---|
| Estado | pending |
| Priority | low |
| Area | auth |
| Estimado | 1-2 días |
| Origen | Inconsistencia menor identificada en el audit de auth durante MC-001/002. Aceptada como out-of-scope hasta cerrar los 9 MCs. |

## Contexto

Hoy `lib/features/ingest/service/gps_foreground_task.dart` corre en
un isolate distinto del main (es un `flutter_foreground_task`
TaskHandler que vive en su propio isolate Dart). Como no comparte
memoria con el `DioClient` del main isolate, **mantiene su propia
copia de `_refrescarToken()`**:

```dart
// gps_foreground_task.dart
Future<bool> _refrescarToken() async {
  if (_refrescando) return false;
  _refrescando = true;
  try {
    final base = _iamBase;
    if (base == null) return false;
    final refresh = await _storage.read(key: _kRefresh);
    if (refresh == null || refresh.isEmpty) return false;
    final iamDio = Dio(BaseOptions(baseUrl: base, ...));
    final res = await iamDio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh',
      data: {'refresh_token': refresh},
    );
    final newAccess = res.data?['access_token'] as String?;
    final newRefresh = res.data?['refresh_token'] as String? ?? refresh;
    if (newAccess == null) return false;
    await _storage.write(key: _kAccess, value: newAccess);
    await _storage.write(key: _kRefresh, value: newRefresh);
    return true;
  } finally {
    _refrescando = false;
  }
}
```

Y el main isolate tiene su propio `_refreshIfPossible` en
`lib/core/network/dio_client.dart`.

Ambos comparten los slots de `flutter_secure_storage` (`isatech_access_token`
y `isatech_refresh_token`), así que se ven los tokens mutuamente —
pero el coordination point es el storage, no la lógica.

## El problema

El IAM rota refresh tokens con `jti` único en cada `POST /auth/refresh`:
el refresh viejo queda invalidado en cuanto se emite uno nuevo. Si los
dos isolates piden refresh **simultáneamente** con el mismo
`refresh_token`:

1. Main isolate y bg isolate leen `refresh_token = R0` casi al mismo
   tiempo.
2. Main isolate hace POST con R0 → IAM responde con `(A1, R1)`,
   invalida R0. Main escribe `(A1, R1)` al storage.
3. Bg isolate hace POST con R0 (ya inválido) → IAM responde `401`.
4. Bg isolate ve que falló su refresh → lógica del catch que asume
   "refresh token revocado" → potencialmente logout espurio del
   chofer.

El IAM hace lo correcto (rotación atómica), no hay corrupción de datos.
El peor caso es **logout espurio** — la app pierde sesión sin razón
visible para el chofer, manejando un camión en ruta. UX feo.

## Mitigación actual (parche, no fix)

Hoy el bug es raro porque:

- El `_refreshIfPossible` del main isolate usa un `Completer` para
  serializar refreshs concurrentes **dentro del main**. Bg vs main
  igual pueden carrerear, pero solo en el momento que ambos detectan
  expiración simultánea.
- El refresh proactivo (<60s antes de expirar) corre solo desde el
  main isolate. El bg isolate refresca solo reactivamente al 401.
  Si la app está abierta, el main es el primero en refrescar y el
  bg ve un token nuevo cuando le toca.

El race solo se materializa cuando:

1. App está minimizada / cerrada (main isolate dormido, no refresca
   proactivo).
2. El bg isolate hace POST a `/phone-location` justo cuando el access
   expiró → 401 → refresh.
3. Casi al mismo tiempo el main isolate vuelve a foreground y dispara
   un fetch que también recibe 401 → refresh.

Es una ventana muy chica pero real.

## Solución propuesta

Refresh broker singleton compartido entre isolates. **3 opciones**
ordenadas de menor a mayor complejidad.

### Opción 1: Mutex via storage (recomendada)

Agregar un slot extra al `flutter_secure_storage`:

```dart
// lib/core/storage/token_storage.dart
static const _kRefreshLock = 'isatech_refresh_lock';

/// Intenta tomar el lock de refresh. Devuelve true si lo tomó (caller
/// hace el refresh), false si ya lo tiene otro isolate (caller debe
/// esperar y re-leer el token).
Future<bool> tryAcquireRefreshLock() async {
  final raw = await _storage.read(key: _kRefreshLock);
  final ahora = DateTime.now().toUtc();
  if (raw != null) {
    final acquired = DateTime.tryParse(raw);
    if (acquired != null && ahora.difference(acquired).inSeconds < 10) {
      return false; // otro isolate está refrescando hace <10s
    }
  }
  await _storage.write(key: _kRefreshLock, value: ahora.toIso8601String());
  return true;
}

Future<void> releaseRefreshLock() async {
  await _storage.delete(key: _kRefreshLock);
}
```

Y en cada isolate, antes de pegarle a `/auth/refresh`:

```dart
final tokenAntes = await storage.readAccessToken();
final tomado = await storage.tryAcquireRefreshLock();
if (!tomado) {
  // Esperar al otro isolate. Polleamos cada 200ms hasta que el
  // access_token cambie o pasen 10s (timeout del lock).
  for (var i = 0; i < 50; i++) {
    await Future.delayed(const Duration(milliseconds: 200));
    final tokenNuevo = await storage.readAccessToken();
    if (tokenNuevo != tokenAntes && tokenNuevo != null) {
      return tokenNuevo; // reusamos el refresh del otro isolate
    }
  }
  return null; // timeout — fallback al refresh propio
}
try {
  // ... POST /auth/refresh ...
} finally {
  await storage.releaseRefreshLock();
}
```

**Ventajas:** simple, idempotente, no requiere comm cross-isolate.
**Desventajas:** polling cada 200ms es feo. El timeout de 10s puede
ser muy largo o muy corto según la red.

### Opción 2: IsolateNameServer + SendPort (más Dart-puro)

El main isolate registra un `SendPort` con un nombre conocido. El bg
isolate lo busca con `IsolateNameServer.lookupPortByName`. Si está,
en lugar de refrescar él mismo, manda un mensaje "refresh_request" y
espera la respuesta con el nuevo token.

**Ventajas:** sin polling, sin uso de storage para coordinación.
**Desventajas:** más código nativo de Dart isolates. El bg isolate
no puede asumir que el main esté vivo (caso app killed donde solo
sobrevive el foreground service).

### Opción 3: MethodChannel + native broker

Native code (Kotlin/Swift) maneja el broker. Los dos isolates
consultan via MethodChannel. Solución más prolija a largo plazo
pero requiere código native — fuera de scope para una app que está
casi 100% en Dart.

## Recomendación

Empezar con **Opción 1 (mutex via storage)**. Es la más simple y
cubre el 99% de los casos del race actual. Si después de QA seguimos
viendo logouts espurios, escalar a Opción 2.

## Criterio de aceptación

- [ ] Test E2E: forzar el isolate principal y el foreground a
      refrescar al mismo tiempo (mock del IAM con delay artificial).
      Solo 1 hace el POST `/auth/refresh`, el otro espera y reusa el
      token nuevo.
- [ ] Logs muestran "refresh ya en flight, esperando..." en lugar de
      dos POSTs concurrentes.
- [ ] No hay logout espurio en sesiones de >24h con app cambiando
      foreground/background varias veces.

## Riesgos

- **Lock con timestamp:** si un isolate crashea con el lock tomado,
  el lock queda hasta que expira el timeout (10s). Aceptable —
  durante esos 10s solo se postergan los refreshs.
- **Race en el read-write del lock:** flutter_secure_storage no
  garantiza atomicidad cross-isolate de un check-and-set. Es posible
  que ambos isolates lean "no hay lock" y ambos escriban.
  Probabilidad muy baja porque el read+write es de microsegundos
  contra una operación de IAM que es de cientos de ms. Si pasara,
  uno de los refreshs falla con 401 y el flujo cae al "siguiente
  tick" — el chofer no se entera. Aceptable.

## Notas para el implementador

- Documentar bien que el slot `isatech_refresh_lock` no es para usar
  como flag de "está autenticado" — es solo coordinación entre
  isolates.
- Asegurar que `releaseRefreshLock()` se llame siempre desde un
  `finally` (incluso en errores y timeouts).
