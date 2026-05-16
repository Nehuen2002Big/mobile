# MC-012 — Exponer Persons API públicamente

| Campo | Valor |
|---|---|
| Estado | **DONE — pero documentar/auditar** |
| Priority | high |
| Area | infra / DevOps |
| Estimado | 0.5 día (config + smoke test) |
| Owner | DevOps / infra (NO mobile, NO backend tracking) |

## Contexto

El servicio de Persons (`isatech_persons_api`) expone, entre otros,
`GET /api/v1/me/profile`, que la app móvil del chofer usa al login
para validar que el user es chofer (`driver_profile != null`). Sin
acceso público al servicio, la app NO funciona en builds de
producción.

Durante el sprint anterior **se descubrió un bug de DNS**: el config
del mobile apuntaba a `https://api-people.isatech.net` (sin S al
final), que **no resuelve**. El subdominio correcto es
`https://api-persons.isatech.net` (con S). Confirmado responde 401
sin bearer (señal de servicio vivo). Lo arreglé en
`lib/core/config/api_config.dart`.

Sin embargo, vale la pena dejar un ticket para:

1. **Documentar oficialmente** la URL pública en el README del mobile
   (hoy solo está en el comentario de `api_config.dart`).
2. **Auditar el setup de proxy/CORS** del lado infra:
   - ¿Está apuntando al mismo container que el resto de los `api-*`?
   - ¿Tiene CORS habilitado para el caso de testing en web?
   - ¿Tiene rate limiting?
3. **Confirmar que el flow funciona desde una red móvil real**
   (no solo LAN dev).

## Tareas

### DevOps

- [x] DNS: `api-persons.isatech.net` resuelve OK (verificado por
      mobile durante MC-005).
- [ ] Confirmar que el reverse proxy / cloud-load-balancer apunta al
      container `isatech_persons_api:8000`.
- [ ] CORS: si la app web (operator) lo necesita, agregar el origen.
      Para mobile no hace falta — mobile no es un browser.
- [ ] Rate limiting: ¿hay alguno hoy? `/me/profile` se llama 1 vez al
      login + 1 vez al bootstrap. Aunque haya 1000 choferes
      concurrentes, son ~2k req/min — bajo. Pero confirmar que el
      límite no nos joda en picos.

### Mobile

- [ ] Documentar en `README.md` la lista completa de URLs:
      ```
      Production:
        IAM:      https://iam.isatech.net
        Persons:  https://api-persons.isatech.net
        Tracking: https://api-tracking.isatech.net
        Routes:   https://api-routes.isatech.net
      Local dev (emulador Android):
        IAM:      http://10.0.2.2:8010
        Persons:  http://10.0.2.2:8011
        Tracking: http://10.0.2.2:8014
      ```
- [ ] Agregar a `docs/auth.md` la lista de servicios + el flow
      completo de login que pega a IAM y a Persons.

### Backend tracking

- [ ] Asegurar que el servicio de Persons que llama tracking
      internamente (para resolver `driver_profile_id` desde el bearer)
      use la URL **interna** (`http://isatech_persons_api:8000`),
      NO la pública. La pública es solo para clientes externos.

## Criterio de aceptación

- [ ] `curl` con bearer válido a
      `https://api-persons.isatech.net/api/v1/me/profile` desde fuera
      de la red privada (red móvil 4G del chofer) devuelve 200 con el
      profile completo.
- [ ] La app móvil release-build se loguea correctamente con
      `chofer/chofer123` desde una red móvil real (no LAN dev). Test
      ya parcialmente cubierto cuando arreglamos el typo de DNS.
- [ ] Documentación en README + docs/auth.md actualizada.

## Notas

Este ticket está **mayormente cerrado** del lado mobile (config
correcto, audit hecho). Lo dejamos en el roadmap para que
DevOps/infra hagan el doble-check de producción (rate limiting,
CORS, monitoring) y para que el README quede oficialmente alineado.
