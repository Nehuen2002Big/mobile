import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/alertas/data/notificaciones_alertas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Habilita el comm channel entre el isolate principal y el del foreground
  // service (el que reporta GPS cuando la app esta minimizada).
  FlutterForegroundTask.initCommunicationPort();
  // Canal de notificaciones del SO para alertas L2/L3.
  await NotificacionesAlertas.instance.inicializar();
  runApp(const ProviderScope(child: MobileIsaTechApp()));
}
