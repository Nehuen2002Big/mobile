import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../uploads/models/checkpoint_evidence.dart';

part 'alerta.freezed.dart';
part 'alerta.g.dart';

// --- AlertaTipo: los 5 tipos que el chofer puede reportar. Los automaticos
//     (DESVIO, RECUPERA_RUTA, SIN_SENAL, RECUPERA_SENAL, EXCESO_VELOCIDAD,
//     DETENCION_PROLONGADA, DESVIO_HORARIO) los genera el backend desde
//     /ingest — no van por aca. ---

enum AlertaTipo {
  trafico(
    'TRAFICO',
    'Tráfico / Incidente',
    Icons.warning_amber,
    requiereFoto: true,
  ),
  paradaComer(
    'PARADA_COMER',
    'Parada para comer',
    Icons.restaurant,
    requiereFoto: false,
    descripcion: '1 h de descanso',
  ),
  paradaDescansar(
    'PARADA_DESCANSAR',
    'Parada para descansar',
    Icons.bedtime_outlined,
    requiereFoto: false,
    descripcion: '8 h de descanso',
  ),
  averia(
    'AVERIA',
    'Avería',
    Icons.build,
    requiereFoto: true,
  ),
  accidente(
    'ACCIDENTE',
    'Accidente',
    Icons.local_hospital,
    requiereFoto: true,
  );

  const AlertaTipo(
    this.apiValue,
    this.label,
    this.icon, {
    required this.requiereFoto,
    this.descripcion,
  });

  final String apiValue;
  final String label;
  final IconData icon;

  /// `true` si el backend exige al menos una imagen como evidencia
  /// (TRAFICO/AVERIA/ACCIDENTE responden 422 `image_required` sin foto).
  /// `false` para los tipos de descanso, que aceptan `evidences: []`.
  final bool requiereFoto;

  /// Texto chiquito de UX que aclara la "consecuencia" del tipo. Hoy
  /// solo lo usan los descansos para mostrar la duración. null para los
  /// que se autoexplican por su label.
  final String? descripcion;

  /// `true` si esta alerta dispara un timer de pausa del lado backend
  /// (PARADA_COMER 1h, PARADA_DESCANSAR 8h). El backend rechaza con
  /// 422 `trip_not_stopped` si el camion esta en movimiento al
  /// crearla — la app debe pre-validar speed local antes de habilitar
  /// el boton.
  bool get esPausa =>
      this == AlertaTipo.paradaComer || this == AlertaTipo.paradaDescansar;
}

// --- AlertaPayload ---

@freezed
class AlertaPayload with _$AlertaPayload {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AlertaPayload({
    required String alertType,
    required double lat,
    required double lon,
    String? message,
    @Default([]) List<CheckpointEvidence> evidences,
  }) = _AlertaPayload;

  factory AlertaPayload.fromJson(Map<String, dynamic> json) =>
      _$AlertaPayloadFromJson(json);
}
