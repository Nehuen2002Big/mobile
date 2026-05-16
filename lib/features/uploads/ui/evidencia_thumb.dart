import 'package:flutter/material.dart';

import '../models/checkpoint_evidence.dart';
import 'auth_image.dart';

/// Thumbnail de una evidencia IMAGE. Toca para abrir el visor full-screen
/// con zoom.
class EvidenciaThumb extends StatelessWidget {
  const EvidenciaThumb({
    super.key,
    required this.evidence,
    this.size = 84,
  });

  final CheckpointEvidence evidence;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = evidence.fileUrl ?? '';
    if (evidence.evidenceType != 'IMAGE' || url.isEmpty) {
      return const SizedBox.shrink();
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => abrirAuthImageFullscreen(
          context: context,
          url: url,
          title: evidence.description,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AuthImage(url: url, width: size, height: size),
        ),
      ),
    );
  }
}
