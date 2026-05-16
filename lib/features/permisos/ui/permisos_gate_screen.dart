import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Pantalla que se muestra al arrancar la app y bloquea el acceso al resto
/// hasta que el chofer otorgue los permisos crítical:
///
///   1. **Notifications** (Android 13+ requiere request explicito) —
///      sin esto la app no puede avisar de alertas L2/L3 cuando esta
///      minimizada.
///   2. **Location** — sin GPS no se puede iniciar viaje ni reportar.
///
/// Si el chofer rechaza definitivamente (deniedForever), ofrecemos abrir
/// Configuración y, si insiste, cerramos la app — IsaTech no funciona sin
/// estos permisos.
class PermisosGateScreen extends StatefulWidget {
  const PermisosGateScreen({super.key, required this.onListo});

  /// Callback que se llama una vez que ambos permisos estan otorgados.
  /// La UI principal se construye recien despues.
  final VoidCallback onListo;

  @override
  State<PermisosGateScreen> createState() => _PermisosGateScreenState();
}

class _PermisosGateScreenState extends State<PermisosGateScreen> {
  bool _checking = true;
  bool _notifOk = false;
  bool _locOk = false;
  bool _notifDenegadoParaSiempre = false;
  bool _locDenegadoParaSiempre = false;
  // Battery optimization: NO bloqueante. Si el chofer dice que no, la
  // app igual arranca; solo mostramos un aviso de que el SO puede
  // matar el polling de alertas en background. Lo guardamos para
  // pintar un warning en la lista de items.
  bool _battOptIgnored = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluarTodo());
  }

  Future<void> _evaluarTodo() async {
    setState(() => _checking = true);

    // Notifications: Android 13+ requiere request en runtime.
    var notif = await Permission.notification.status;
    if (notif.isDenied) {
      notif = await Permission.notification.request();
    }

    // Location: pedimos whileInUse — alcanza para foreground service de GPS.
    var loc = await Permission.locationWhenInUse.status;
    if (loc.isDenied) {
      loc = await Permission.locationWhenInUse.request();
    }

    // Battery optimization: pedimos opt-out una sola vez. Si el chofer
    // rechaza, igual avanzamos (no bloqueante). Sin esto, Android Doze
    // puede pausar el foreground service de GPS y el polling de alertas
    // L2/L3 en background.
    var batt = await Permission.ignoreBatteryOptimizations.status;
    if (batt.isDenied) {
      batt = await Permission.ignoreBatteryOptimizations.request();
    }

    if (!mounted) return;
    setState(() {
      _notifOk = notif.isGranted;
      _locOk = loc.isGranted;
      _notifDenegadoParaSiempre = notif.isPermanentlyDenied;
      _locDenegadoParaSiempre = loc.isPermanentlyDenied;
      _battOptIgnored = batt.isGranted;
      _checking = false;
    });

    // Solo bloqueamos si faltan los dos criticos (notif + ubicacion).
    // Battery opt-out es un nice-to-have — la app funciona sin el,
    // solo que Android puede pausarla en background prolongado.
    if (_notifOk && _locOk) {
      widget.onListo();
    }
  }

  Future<void> _abrirSettings() async {
    await openAppSettings();
    // Cuando el usuario vuelve, reevaluamos.
    if (mounted) await _evaluarTodo();
  }

  void _cerrarApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final algunoBloqueado =
        _notifDenegadoParaSiempre || _locDenegadoParaSiempre;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.shield_outlined,
                size: 72,
                color: scheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Necesitamos algunos permisos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'IsaTech Conductor no puede funcionar sin estos permisos. '
                'Avisanos al monitoreo y reportar tu ubicación es lo que '
                'asegura que llegues bien.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
              const SizedBox(height: 24),
              _ItemPermiso(
                icono: Icons.notifications_active_outlined,
                titulo: 'Notificaciones',
                descripcion:
                    'Recibís avisos del monitoreo aunque tengas la app cerrada.',
                granted: _notifOk,
                denegadoParaSiempre: _notifDenegadoParaSiempre,
              ),
              const SizedBox(height: 12),
              _ItemPermiso(
                icono: Icons.location_on_outlined,
                titulo: 'Ubicación',
                descripcion:
                    'Reporta tu posición al monitoreo durante el viaje.',
                granted: _locOk,
                denegadoParaSiempre: _locDenegadoParaSiempre,
              ),
              const SizedBox(height: 12),
              _ItemPermiso(
                icono: Icons.battery_charging_full_outlined,
                titulo: 'Ignorar ahorro de batería',
                descripcion:
                    'Recomendado: sin esto, Android puede pausar las '
                    'alertas urgentes cuando la app está en background.',
                granted: _battOptIgnored,
                denegadoParaSiempre: false,
                opcional: true,
              ),
              const Spacer(),
              if (algunoBloqueado) ...[
                Text(
                  'Alguno de estos permisos fue rechazado de forma '
                  'permanente. Tenés que habilitarlos manualmente desde '
                  'Configuración de Android.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.error),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _abrirSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Abrir Configuración'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _cerrarApp,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Cerrar app'),
                ),
              ] else ...[
                FilledButton.icon(
                  onPressed: _evaluarTodo,
                  icon: const Icon(Icons.check),
                  label: const Text('Permitir'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPermiso extends StatelessWidget {
  const _ItemPermiso({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.granted,
    required this.denegadoParaSiempre,
    this.opcional = false,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool granted;
  final bool denegadoParaSiempre;
  /// Si es true, "rechazado" se renderea como warning amarillo
  /// (con texto "Recomendado") en vez de bloqueante rojo.
  final bool opcional;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color color;
    final IconData estadoIcon;
    final String estadoText;
    if (granted) {
      color = Colors.green;
      estadoIcon = Icons.check_circle;
      estadoText = 'Otorgado';
    } else if (opcional) {
      // No bloqueante: amarillo + texto suave.
      color = Colors.orange.shade700;
      estadoIcon = Icons.warning_amber_outlined;
      estadoText = 'Recomendado';
    } else if (denegadoParaSiempre) {
      color = scheme.error;
      estadoIcon = Icons.block;
      estadoText = 'Bloqueado — abrir Configuración';
    } else {
      color = scheme.outline;
      estadoIcon = Icons.radio_button_unchecked;
      estadoText = 'Pendiente';
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icono, size: 28, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  descripcion,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(estadoIcon, color: color, size: 22),
              const SizedBox(height: 2),
              SizedBox(
                width: 90,
                child: Text(
                  estadoText,
                  style: TextStyle(color: color, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
