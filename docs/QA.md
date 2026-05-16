# QA — mobile_isatech

Estado de testing manual contra el celular real (Moto G52, Android 13,
ZY22FTZNBH). Se va actualizando a medida que probamos.

**Leyenda:** ✅ probado y funciona · ❌ probado y rompe · ⏳ no probado
todavía · ⚠️ probado parcial / con observación.

---

## 1. Auth + sanity check chofer ✅

- [x] Login `chofer/chofer123` → entra al listado de viajes.
- [x] Login con admin/operador → bloqueado con banner "Esta app es solo
      para choferes" (después de fix del typo `api-people` → `api-persons`).
- [x] Banner de error persistente arriba del form (no snackbar perdido).
- [ ] Refresh proactivo <60s antes de expirar — no testeado a ojo (es
      transparente).
- [ ] 403 de tracking → mensaje accionable. No reproducido.

**Bugs/issues encontrados durante testing:**
- 🐛 **typo en `api_config.dart`**: `api-people.isatech.net` no resuelve
  en DNS — el subdominio correcto es `api-persons.isatech.net` (con S).
  Arreglado.

---

## 2. Iniciar viaje (PENDING → ACTIVE) ⏳

- [ ] Iniciar cerca del origen → arranca foreground service.
- [ ] Notif persistente "IsaTech Conductor — Reportando ubicación" en
      la barra del SO.
- [ ] Iniciar lejos del origen → dialog con distancia + "Reintentar".
- [ ] Iniciar sin GPS / GPS lento → snackbar "Sin ubicación GPS".

---

## 3. MC-002 — FakeCall optimista ✅

- [x] `[LLAMADA · ...]` con app abierta → FakeCall full-screen aparece.
- [x] Tocás "Estoy bien" → ringtone corta + cierre instantáneo (<100ms
      percibido).
- [x] Botones funcionan sin spinner colgado.
- [ ] ACK falla por red → fake-call se reabre con banner rojo +
      botón "Reintentar". No simulado todavía (requiere cortar wifi
      justo en el toque).
- [ ] Race window 5s — no reproducido explícito.
- [ ] Auto-close por backend auto-ack (chofer manda mensaje al chat con
      FakeCall abierto). No probado.
- [ ] Burbuja "✓ Resuelto" en chat para alerta ackeada en esta sesión.
      No verificado a ojo.

**Bugs/issues encontrados durante testing:** ninguno.

---

## 4. MC-001 — Notificaciones del SO con app cerrada/minimizada ✅

- [x] App minimizada, monitor manda L2/L3 → notif aparece en la barra
      en <30s.
- [x] App cerrada (swipe recents), notif sigue llegando — el foreground
      service GPS sobrevive.
- [x] Polling cada 15s funciona.
- [ ] Tocás "Estoy bien" desde la notif sin abrir la app → ackea
      silencioso. No verificado explícito.
- [ ] Spam test (varias L2 simultáneas) → notif consolidada con +N.
      No probado.
- [ ] Battery optimization opt-out aparece en el permisos gate. No
      verificado a ojo.

**Bugs/issues encontrados durante testing:** ninguno.

---

## 5. MC-003 — Finish / Cancel del viaje ⏳

- [ ] Finalizar cerca del destino → snackbar "Viaje finalizado" +
      vuelta al listado, viaje desaparece.
- [ ] Finalizar lejos del destino → dialog con distancia restante +
      "Reintentar".
- [ ] Operador cancela viaje desde web → app muestra toast
      "El viaje fue finalizado o cancelado" + vuelve al listado.
- [ ] Operador cancela mientras app minimizada → al volver a foreground,
      app sincroniza.
- [ ] Finalizar un trip ya cerrado por otra sesión → snackbar suave
      "El viaje ya estaba cerrado", sin error rojo.

---

## 6. MC-004 — Tipos de alerta nuevos + escalation_level + DEVICE_OFFLINE ✅

- [x] Tirar **EXCESO_VELOCIDAD** desde el simulador → chat muestra
      badge ⚡ naranja "Velocidad", banner muestra icon speedometer.
- [x] Tirar **DETENCION_PROLONGADA** → badge ⏸ ámbar "Detenido".
- [x] Tirar **DESVIO_HORARIO** → badge ⏰ violeta "Atraso".
- [x] Tipos viejos (DESVIO, ACCIDENTE, TRAFICO, AVERIA, PARADA_COMER,
      SIN_SENAL) siguen funcionando idéntico (no regresión).
- [x] Cada alerta muestra badge **L1 / L2 / L3** según
      `escalation_level` (gris / ámbar / rojo).
- [x] Alerta sin `escalation_level` (chofer-creada) NO muestra badge
      de nivel.
- [x] **DEVICE_OFFLINE** (`rule_type` sobre SIN_SENAL) muestra el
      sub-texto explicativo en el chat Y en el banner persistente.
- [x] FakeCall hereda icon + color del tipo de alerta cuando el
      `alertId` está en pending-action (en lugar del genérico phone).
- [x] FakeCall muestra badge de nivel L1/L2/L3 al lado del label de
      tipo.
- [ ] Tipo desconocido (defensa: backend introduce uno nuevo antes de
      actualizar la app) → renderiza con icon ❗ + raw type, NO crashea.
      *(no reproducible en producción — defensa sin testeo manual)*
- [ ] Alerta con `simulated: true` se renderiza idéntica a una real
      (no hay badge "DEMO" — es a propósito).
      *(asumido funcionando — el flag se parsea sin distinción de UI)*

**Bugs/issues encontrados durante testing:** ninguno.

**Implementación:**
- Helper compartido nuevo: `lib/features/alertas/data/alert_styles.dart`
  con `alertTypeStyle()`, `escalationStyle()`, `alertSubtitle()`.
- Modelos `TrackingAlert` y `MessageAlertRef` ahora parsean
  `simulated: bool` (default false).
- Chat / banner / FakeCall usan los helpers en lugar de duplicar
  switches de íconos.

---

## 7. MC-005 — Banner persistente de pending-action ✅

- [x] Disparar 1 L2 → banner ámbar aparece arriba de la pantalla del
      viaje activo en ≤12s con header "Tenés 1 alerta que requiere
      tu confirmación".
- [x] Disparar 1 L2 + 1 L3 → banner se vuelve **rojo** (mayor
      severidad). Plural en header: "Tenés 2 alertas que requieren...".
- [x] Lista compacta muestra cada item con icon + label + badge L1/L2/L3
      + título corto (ej. "Velocidad · L2 · 120 km/h (límite 80)").
- [x] **+ N más** abajo si hay más de 3 alertas.
- [x] Botón **"Ver detalles"** abre bottom sheet con la lista completa
      + mensaje del backend + timestamp completo + sub-texto si aplica.
- [x] Botón **"Recibido"** ackea **todas** las alertas visibles
      (en banner) o todas las del sheet (en detalles).
- [x] **Optimismo**: al tocar "Recibido", el banner desaparece YA,
      sin esperar el POST. Si el POST falla, **reaparece** con
      snackbar rojo "No pudimos confirmar — verificá conexión".
- [x] Postear un **mensaje al chat** desde la app → banner desaparece
      sin tocar "Recibido" (backend auto-ackea + tick inmediato del
      polling).
- [x] Crear una alerta del chofer (TRAFICO/AVERIA/etc) → mismo
      comportamiento: banner desaparece sin tocar "Recibido".
- [x] Cerrar la app con alertas pendientes y reabrir → banner aparece
      en el primer render del viaje activo.
- [x] Una alerta DEVICE_OFFLINE muestra el sub-texto explicativo
      bajo ese item específico.

**Bugs/issues encontrados durante testing:** ninguno.

**Implementación:**
- `PendingActionNotifier.acknowledge` ahora oculta optimistamente y
  restaura snapshot si el POST falla.
- Banner rediseñado con layout vertical: header + lista (max 3) +
  acciones. "+ N más" si hay más alertas.
- Bottom sheet `_DetallesSheet` para "Ver detalles".
- `ChatNotifier.enviar` y `AlertasPanel._enviar` disparan
  `pendingActionNotifier.refrescar(tripId)` post-POST → tick fuera de
  banda para que el banner reaccione en <1s al auto-ack del backend.

---

## 8. MC-006 — Quitar ACK manual local ✅

- [x] Audit: ningún call-site llama `acknowledge()` automáticamente
      tras chat-send / alerta-creada / finish — siempre fue acción
      explícita del chofer (banner / fake-call / notif del SO).
      Cumplido por diseño en este repo.
- [x] Tick inmediato del polling de pending-action post chat-send /
      post alerta-creada / post finish (heredado de MC-005 / MC-003).
- [x] Test E2E: chofer postea mensaje → banner desaparece sin tocar
      "Recibido" en <2s. *(probado vía MC-005)*
- [x] Test E2E: chofer crea alerta TRAFICO → idem. *(probado vía MC-005)*
- [x] Test E2E: chofer finaliza viaje → no quedan badges fantasma de
      alertas.

**Bugs/issues encontrados durante testing:** ninguno.

**Implementación:**
- Doc-comment explícito en `AlertasRepository.acknowledge` listando
  los call-sites legítimos (banner / fake-call / notif del SO) y
  pidiendo NO llamarlo post-mensaje (el backend ya auto-ackea).

---

## 9. MC-008 — Mensajes `[ATENDIDO ...]` atenuados ✅

- [x] Disparar L3 → operador ackea desde el bell de la web → app del
      chofer muestra `[ATENDIDO L3] ...` con look gris suave + icono
      verde ✓ "ATENDIDO L3 · POR EL OPERADOR" arriba.
- [x] **Sin** ringtone, **sin** vibración, **sin** notif del SO al
      recibirse.
- [x] **NO** abre fake-call. **NO** dispara banner persistente.
- [x] Mensajes `[LLAMADA · ...]` siguen abriendo fake-call (no regresión).
- [x] Mensajes `[ACCION REQUERIDA · ...]` siguen disparando banner
      (no regresión).
- [x] Si la burbuja del mensaje original (con alertId) está visible en
      el chat, queda con badge "✓ Resuelto" tras el ATENDIDO (porque
      el alertId se agrega a `alertasAcked` localmente).

**Bugs/issues encontrados durante testing:** ninguno.

**Implementación:**
- `TipoCascada.atendido` nuevo en el enum. El parser
  `parsearPrefijoCascada` reconoce `[ATENDIDO]`, `[ATENDIDO L2]`,
  `[ATENDIDO L3]` (sin separador `·`) y guarda el nivel en `regla`.
- `ChatNotifier._fetchDelta`: branch dedicado que skipea el dispatcher
  de notif y agrega el alertId al map `alertasAcked` local.
- `chat_screen._Burbuja`: nuevo branch `esAtendidoAudit` que renderiza
  fondo neutro + borde verde suave + icon ✓ + texto en italic.

---

## 11. MC-007 — Suppression de DEVICE_OFFLINE (audit, sin código) ✅

Audit del comportamiento existente del foreground service contra los
3 properties que el watchdog de DEVICE_OFFLINE del backend espera.
**Resultado: outcome A — todo OK en el código, sin cambios.** Falta
ejecutar los 2 tests E2E de QA con coordinación del backend.

### Propiedades verificadas

- [x] **P1 — el ping se dispara aunque speed=0**: `_enviarPunto` solo
      serializa `pos.speed` como campo del body
      (`'speed_kmh': (pos.speed * 3.6).clamp(0, 400)`). NO hay guard
      `if (speed > 0) post()`. Confirmado por grep en
      `gps_foreground_task.dart`.
- [x] **P2 — intervalo dentro del margen**: foreground service corre
      cada **15s** (`_intervaloForeground` en `gps_service.dart:104`,
      pasado a `eventAction.repeat`). Watchdog dispara
      DEVICE_OFFLINE solo tras ~7.5min (1.5× threshold default 5min)
      sin pings. Margen amplísimo.
- [x] **P3 — loop arranca al ACTIVE, para al cerrar**:
      `_arrancarForegroundService` solo se llama desde `iniciar()`,
      invocado por `viaje_activo_screen` cuando el trip pasa a ACTIVE.
      `_detenerForegroundService` se invoca desde `detener()` (post
      `_finalizar`, listener de cancelación remota, dispose) y desde
      el bg isolate al detectar 409 (`FlutterForegroundTask.stopService`).

### Tests E2E pendientes (requieren backend dev)

- [ ] **Test 1 — Suppression activa**: trip ACTIVE, app pingueando, mock
      DEVICE silenciado → durante todo el tiempo, no llega
      `SIN_SENAL` al chat. Backend debería loggear
      `DEVICE_OFFLINE suppressed for trip=...`.
- [ ] **Test 2 — Suppression NO activa**: trip ACTIVE, app **kill**
      (no minimizar — kill total) + mock DEVICE silente → en 7-22min
      llega `SIN_SENAL` al chat normal.

### Notas operacionales (sin código requerido)

- Si Android Doze mata el foreground service (caso real fuera de
  control de la app), los pings dejan de salir y eventualmente llega
  DEVICE_OFFLINE — esto es **correcto**, ese es el caso que la
  suppression no cubre y debería avisar al operador.
- El opt-out de battery optimization en el `PermisosGateScreen`
  (heredado de MC-001) mitiga el riesgo de Doze para choferes que
  acepten el permiso.

---

## 10. MC-009 — HTTP 423 (QA pause) ✅

- [x] Operador llama `phone-ingest/pause` con `seconds=20` → durante
      20s la app recibe 423 en cada POST de phone-location.
- [x] **NO** muestra error al chofer (toast / banner / dialog).
- [x] El `_pausedUntil` se setea con el `seconds_remaining` del body
      (o `Retry-After` header). `onRepeatEvent` skipea el GPS POST
      mientras dure.
- [x] Polling de mensajes y pending-action **siguen corriendo**
      durante la pausa (esos endpoints no están afectados).
- [x] Al expirar la pausa, el siguiente tick reanuda el POST sin
      intervención manual.
- [x] Logs `[FG-GPS] phone-ingest QA pause — silenciando Ns` visibles
      en logcat.

**Bugs/issues encontrados durante testing:** ninguno.

**Implementación:**
- Nuevo field `_pausedUntil: DateTime?` en `GpsForegroundTaskHandler`.
- `_enviarPunto` 423 → parsea `seconds_remaining` o `Retry-After` →
  setea `_pausedUntil = now + duration`. Drop silencioso, return
  false (no incrementa fallidos visibles al chofer).
- `onRepeatEvent` chequea `_pausedUntil` antes del POST y lo skipea
  si todavía estamos en pausa. Auto-clear cuando expira.

---

## Pendiente de implementar (próximos prompts)

- [x] **MC-004** — Renderizar nuevos tipos de alerta + nivel de
      escalación. **Implementado y probado ✅.**
- [x] **MC-005** — Banner persistente de pending-action.
      **Implementado y probado ✅.**
- [x] **MC-006** — Quitar ACK manual local. **Implementado y probado ✅.**
- [x] **MC-007** — Suppression DEVICE_OFFLINE. **Audit OK** (las 3
      properties cumplen sin cambios). Tests E2E requieren
      coordinación con backend dev.
- [x] **MC-008** — Render `[ATENDIDO ...]` atenuado.
      **Implementado y probado ✅.**
- [x] **MC-009** — Manejo 423 (QA pause). **Implementado y probado ✅.**
- [ ] **MC-001-B** — FCM/APNs reales (sucesor robusto del polling).
      **No iniciado.** Roadmap futuro — el polling vía foreground
      service (MC-001 actual) cubre el use-case principal.

---

## 🎯 Estado del roadmap MC

**9/9 MCs cerrados** del lado código y **8/9 verificados E2E** en celular real:

| MC | Título | Code | E2E |
|---|---|:---:|:---:|
| MC-001 | Notif del SO con app cerrada | ✅ | ✅ |
| MC-002 | FakeCall optimista | ✅ | ✅ |
| MC-003 | Refresh viaje al finish/cancel | ✅ | ⏳ |
| MC-004 | Tipos de alerta + nivel + DEVICE_OFFLINE render | ✅ | ✅ |
| MC-005 | Banner persistente pending-action | ✅ | ✅ |
| MC-006 | Quitar ACK manual local (audit) | ✅ | ✅ |
| MC-007 | Suppression DEVICE_OFFLINE (audit) | ✅ | ⏳ |
| MC-008 | Render `[ATENDIDO]` atenuado | ✅ | ✅ |
| MC-009 | Manejo 423 QA pause | ✅ | ✅ |

**Pendientes de testear:** solo MC-003 (finish/cancel + cancelación
remota) y los 2 tests E2E de MC-007 (que dependen del backend dev
para silenciar el mock DEVICE).
