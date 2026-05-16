import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../uploads/data/upload_exceptions.dart';
import '../../uploads/models/checkpoint_evidence.dart';
import '../data/alerta_exceptions.dart';
import '../models/alerta.dart';

/// Velocidad (km/h) sobre la cual el backend rechaza PARADA_COMER /
/// PARADA_DESCANSAR con 422 `trip_not_stopped`. Pre-validamos local con
/// el GPS del telefono — si supera el umbral, deshabilitamos los botones
/// de descanso para evitar que el chofer reciba el 422.
const double _kPausaSpeedMaxKmh = 5;

/// Lista de alertas que el chofer puede reportar. TRAFICO/AVERIA/ACCIDENTE
/// piden foto; PARADA_COMER / PARADA_DESCANSAR no la requieren y ademas
/// disparan el modo pausa del lado backend (1h y 8h respectivamente).
class AlertasPanel extends ConsumerWidget {
  const AlertasPanel({super.key, required this.tripId});

  final String tripId;

  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    AlertaTipo tipo,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    File? foto;

    if (tipo.requiereFoto) {
      // Flujo TRAFICO / AVERIA / ACCIDENTE: cámara primero. Si el chofer
      // cancela la captura, abortamos la creación.
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        imageQuality: 85,
      );
      if (picked == null) return;
      foto = File(picked.path);
    }
    if (!context.mounted) return;

    final enviado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _ConfirmarAlertaSheet(
        tripId: tripId,
        tipo: tipo,
        foto: foto,
      ),
    );
    if (enviado == true) {
      messenger.showSnackBar(
        SnackBar(content: Text('Alerta "${tipo.label}" enviada')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch al servicio GPS para reaccionar a cambios de velocidad —
    // los botones de descanso se deshabilitan en vivo cuando el chofer
    // pasa los 5 km/h y se reactivan cuando frena.
    final gps = ref.watch(gpsServiceProvider);
    final pos = gps.ultimaPosicion;
    final kmh = pos == null
        ? 0.0
        : (pos.speed * 3.6).clamp(0.0, 400.0).toDouble();
    final enMovimiento = kmh > _kPausaSpeedMaxKmh;
    final tooltipMov =
        'Estás en movimiento (${kmh.toStringAsFixed(0)} km/h). Detené el '
        'camión antes de iniciar la parada.';

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final tipo in AlertaTipo.values)
          _AlertaBoton(
            icon: tipo.icon,
            label: tipo.label,
            descripcion: tipo.descripcion,
            enabled: tipo.esPausa ? !enMovimiento : true,
            tooltipDeshabilitado: tipo.esPausa ? tooltipMov : null,
            onTap: () => _onTap(context, ref, tipo),
          ),
      ],
    );
  }
}

class _ConfirmarAlertaSheet extends ConsumerStatefulWidget {
  const _ConfirmarAlertaSheet({
    required this.tripId,
    required this.tipo,
    required this.foto,
  });

  final String tripId;
  final AlertaTipo tipo;

  /// `null` cuando la alerta no requiere evidencia (descansos). El sheet
  /// adapta el render y omite el upload en ese caso.
  final File? foto;

  @override
  ConsumerState<_ConfirmarAlertaSheet> createState() =>
      _ConfirmarAlertaSheetState();
}

class _ConfirmarAlertaSheetState
    extends ConsumerState<_ConfirmarAlertaSheet> {
  final _msgCtrl = TextEditingController();
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _mostrarDialogTripEnMovimiento(
    TripNoDetenidoException e,
  ) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.directions_car_filled, size: 36),
        title: const Text('El camión está en movimiento'),
        content: Text(e.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<void> _enviar() async {
    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      final gps = ref.read(gpsServiceProvider);
      final uploads = ref.read(uploadsRepoProvider);
      final alertas = ref.read(alertasRepoProvider);

      // 1) GPS actual
      final pos = await gps.ubicacionActual();
      if (pos == null) {
        setState(() {
          _error = 'Sin ubicación GPS.';
          _enviando = false;
        });
        return;
      }

      // 2) Upload de la foto (solo si la alerta lleva evidencia).
      final List<CheckpointEvidence> evidences = [];
      if (widget.foto != null) {
        final upload = await uploads.subirEvidencia(
          tripId: widget.tripId,
          file: widget.foto!,
        );
        final note = _msgCtrl.text.trim();
        evidences.add(
          CheckpointEvidence(
            evidenceType: 'IMAGE',
            fileUrl: upload.url,
            description: note.isEmpty ? null : note,
          ),
        );
      }

      // 3) Crear la alerta. Para descansos viaja `evidences: []` — el
      //    backend lo acepta sin pedir foto. El backend tambien auto-postea
      //    el mensaje al chat con el prefijo correspondiente.
      final note = _msgCtrl.text.trim();
      await alertas.enviar(
        tripId: widget.tripId,
        payload: AlertaPayload(
          alertType: widget.tipo.apiValue,
          lat: pos.latitude,
          lon: pos.longitude,
          message: note.isEmpty ? null : note,
          evidences: evidences,
        ),
      );

      // 4) Refrescar el chat para que se vea el mensaje auto-posteado si el
      //    usuario ya tenia el notifier abierto.
      try {
        ref
            .read(chatNotifierProvider(widget.tripId).notifier)
            .refrescar(widget.tripId);
      } catch (_) {}
      // 5) El backend tambien auto-ackea las L2/L3 pendientes cuando el
      //    chofer crea una alerta nueva. Disparamos un tick inmediato del
      //    polling de pending-action para que el banner desaparezca de
      //    inmediato — sin esperar hasta 12s al proximo poll regular.
      try {
        ref
            .read(pendingActionNotifierProvider(widget.tripId).notifier)
            .refrescar(widget.tripId);
      } catch (_) {}
      // 6) Si la alerta es de pausa (PARADA_COMER / PARADA_DESCANSAR), el
      //    backend recien creo el timer de pausa. Forzamos un poll
      //    inmediato del TripPauseNotifier para que el banner de pausa
      //    aparezca sin esperar 30s al proximo poll regular.
      if (widget.tipo.esPausa) {
        try {
          ref
              .read(tripPauseNotifierProvider(widget.tripId).notifier)
              .refrescar(widget.tripId);
        } catch (_) {}
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } on TripNoDetenidoException catch (e) {
      // Caso "el chofer logro tocarlo aunque la pre-validacion local lo
      // dejaba habilitado" (GPS del telefono != GPS del DEVICE). Mostramos
      // un dialog con el mensaje del backend y dejamos el sheet abierto
      // para que el chofer pueda reintentar al detenerse.
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = null;
      });
      await _mostrarDialogTripEnMovimiento(e);
    } on ArchivoDemasiadoGrandeException catch (e) {
      setState(() {
        _error = e.message;
        _enviando = false;
      });
    } on TipoArchivoNoPermitidoException catch (e) {
      setState(() {
        _error = e.message;
        _enviando = false;
      });
    } on AlertaSinFotoException catch (e) {
      setState(() {
        _error = e.message;
        _enviando = false;
      });
    } on TipoAlertaNoPermitidaException catch (e) {
      setState(() {
        _error = e.message;
        _enviando = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _enviando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipo = widget.tipo;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  tipo.icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipo.label,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (tipo.descripcion != null)
                        Text(
                          tipo.descripcion!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.foto != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  widget.foto!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _msgCtrl,
              minLines: 2,
              maxLines: 4,
              enabled: !_enviando,
              decoration: InputDecoration(
                labelText: tipo.requiereFoto
                    ? 'Detalles (opcional)'
                    : 'Nota (opcional)',
                hintText: tipo.requiereFoto
                    ? 'Ej: derrape en km 245, auto volcado'
                    : 'Ej: parando en estacion de servicio',
                border: const OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _enviando
                        ? null
                        : () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _enviando ? null : _enviar,
                    icon: _enviando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(_enviando ? 'Enviando...' : 'Enviar alerta'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertaBoton extends StatelessWidget {
  const _AlertaBoton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.descripcion,
    this.enabled = true,
    this.tooltipDeshabilitado,
  });

  final IconData icon;
  final String label;
  final String? descripcion;
  final bool enabled;
  final String? tooltipDeshabilitado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final boton = Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: scheme.primary),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                if (descripcion != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    descripcion!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (!enabled && tooltipDeshabilitado != null) {
      return Tooltip(
        message: tooltipDeshabilitado!,
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(seconds: 3),
        child: boton,
      );
    }
    return boton;
  }
}
