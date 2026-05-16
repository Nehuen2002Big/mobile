import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre la app de navegacion nativa del telefono con `lat,lon` como
/// destino (MC-020 — boton "Llevarme al origen"). No embebimos mapa en
/// la app: deep link al SO y que el chofer use Google Maps / Waze /
/// Apple Maps segun lo que tenga.
///
/// - **Android**: URI `geo:` con query — el SO muestra el picker entre
///   Google Maps, Waze y cualquier otra app de mapas instalada. Si el
///   chofer marca un default, va directo.
/// - **iOS**: URI `maps.apple.com` con `daddr` y modo driving. Abre
///   Apple Maps (siempre disponible). Si el chofer prefiere Google
///   Maps / Waze tendra que abrirla manualmente — TODO futuro:
///   detectar comgooglemaps:// / waze:// instaladas y ofrecer picker.
///
/// Si por algun motivo no hay app que pueda manejar el URI (raro en
/// mobile), copiamos `lat,lon` al clipboard y mostramos un SnackBar
/// para que el chofer lo pegue donde quiera.
Future<void> abrirNavegacionAOrigen(
  BuildContext context, {
  required double lat,
  required double lon,
  String etiqueta = 'Origen del viaje',
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final esIos = defaultTargetPlatform == TargetPlatform.iOS;
  final uri = esIos
      ? Uri.parse('http://maps.apple.com/?daddr=$lat,$lon&dirflg=d')
      : Uri.parse('geo:$lat,$lon?q=$lat,$lon($etiqueta)');
  try {
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (ok) return;
  } catch (_) {
    // Cae al fallback de abajo.
  }
  // Fallback: copiar coords al clipboard.
  await Clipboard.setData(ClipboardData(text: '$lat,$lon'));
  if (!context.mounted) return;
  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(
          'No pudimos abrir la app de mapas. Copiamos las coordenadas '
          '($lat, $lon) al portapapeles — pegalas en tu app de mapas.',
        ),
        duration: const Duration(seconds: 5),
      ),
    );
}
