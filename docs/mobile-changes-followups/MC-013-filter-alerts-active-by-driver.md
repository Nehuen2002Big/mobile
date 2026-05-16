# MC-013 — Filtrar `/alerts/active` por chofer

| Campo | Valor |
|---|---|
| Estado | pending |
| Priority | medium |
| Area | backend tracking |
| Estimado | 1 día |
| Owner | Equipo backend tracking |

## Contexto

En el sprint anterior, el equipo backend implementó **filtrado
automático** de `GET /api/v1/trips` cuando el JWT pertenece a un
chofer:

1. El tracking server lee el bearer del request.
2. Forwardea a Persons `GET /api/v1/me/profile`.
3. Si la response trae `driver_profile != null`, filtra los trips
   por `WHERE trip.driver_person_id = me.person.id`.
4. Si es operator/admin, devuelve la vista global como antes (zero
   regression para la SPA del operador).

Eso permite que la app móvil del chofer NO necesite filtrar
client-side — `/trips` ya devuelve solo lo que le corresponde.

**Pero `GET /api/v1/alerts/active` sigue siendo global.** Devuelve
alertas activas de toda la flota. Hoy la app móvil del chofer no
usa este endpoint (usa `/trips/{id}/alerts/pending-action` que sí
está filtrado por trip). Sin embargo:

- Si en el futuro la app del chofer pega a `/alerts/active` por
  error o por una feature nueva, el chofer leería data de otros
  choferes. **Privacy leak.**
- Hay un check de seguridad implícito que hoy depende de cada
  endpoint por separado. Mejor unificar el comportamiento.

## Tareas backend tracking

### Modificar `app/api/v1/routes/alerts.py` route `active_alerts`

Mismo approach que `list_trips` en `trips.py`:

```python
@router.get("/active", response_model=AlertListResponse)
async def active_alerts(
    current_user: CurrentUser = Depends(get_current_user),
    persons_client: PersonsClient = Depends(get_persons_client),
    alert_service: AlertService = Depends(get_alert_service),
):
    # Resolver driver_person_id del JWT (cache 5 min keyed por sub).
    driver_person_id = await persons_client.resolve_driver_person_id(
        bearer_token=current_user.raw_bearer,
    )
    return await alert_service.list_active(
        driver_person_id=driver_person_id,  # None = vista global
    )
```

### Modificar `app/services/alert_service.py` `list_active`

Si todavía no acepta el parámetro:

```python
async def list_active(
    self,
    *,
    driver_person_id: str | None = None,
) -> AlertListResponse:
    query = (
        select(Alert)
        .join(Trip, Alert.trip_id == Trip.id)
        .where(Alert.acknowledged_at.is_(None))
        .where(Trip.status == "ACTIVE")
    )
    if driver_person_id is not None:
        query = query.where(Trip.driver_person_id == driver_person_id)
    # ... resto igual ...
```

### Edge case: fail-open vs fail-closed

El sprint anterior dejó `/trips` **fail-open**: si Persons cae,
tracking devuelve la vista global como fallback. Trade-off elegido
por disponibilidad sobre privacidad estricta.

Para `/alerts/active` propongo **fail-closed**: si Persons cae,
devolver 503 (o lista vacía). Razonamiento:

- En `/trips`, el peor caso del fail-open es que el chofer ve trips
  ajenos por unos segundos. Le da curiosidad pero no rompe nada.
- En `/alerts/active`, el peor caso del fail-open es que el chofer
  ve alertas L3 de otros camiones (potencialmente accidentes,
  emergencias). Eso sí es leak operativo.

Si el equipo prefiere mantener la consistencia con `/trips`, fail-open
también es aceptable.

## Cambios mobile

**Ninguno hoy.** La app móvil no usa `/alerts/active`. Solo
preventivo: si en el futuro alguien lo agregue (ej. una pantalla
"todas las alertas históricas" del chofer), el endpoint ya estaría
filtrado.

## Criterio de aceptación

- [ ] `curl` con bearer del chofer (Nehuen) a `/alerts/active`
      devuelve **solo alertas de SUS trips activos**.
- [ ] `curl` con bearer de operator/admin devuelve todas las alertas
      activas (sin regresión).
- [ ] Test E2E: con `chofer/chofer123` y trip
      `VS-20260502-170827`, las alertas que devuelve el endpoint
      coinciden 1:1 con las del trip; no aparecen alertas de otros
      trips.
- [ ] Si Persons cae:
  - **Si fail-open elegido:** vista global devuelta (mismo
    comportamiento que `/trips`).
  - **Si fail-closed elegido:** 503 con detail
    `"persons_service_unavailable"`.

## Riesgos

- Performance: agregar el JOIN con `trips` en cada llamada al endpoint
  no debería ser problema — el query plan ya lo hace para el filtro
  de `Trip.status == ACTIVE`. Confirmar con `EXPLAIN ANALYZE` antes
  de mergear.
- Cache de `resolve_driver_person_id`: ya existe (5min TTL) por la
  implementación de `/trips`. Reusar el mismo client sin cambios.

## Notas para el implementador

- Tests unitarios: agregar al menos uno que cubra el caso "alerta
  L3 en trip de otro chofer NO aparece para el chofer X".
- Tests de integración: verificar que la SPA del operador sigue
  recibiendo todas las alertas.
- Documentar en el OpenAPI / README de tracking que el endpoint
  ahora filtra por chofer transparente.
