import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../uploads/data/upload_exceptions.dart';
import '../../uploads/models/checkpoint_evidence.dart';
import '../models/checkpoint_info.dart';

/// Datos que recolectó el bottom sheet antes de llamar al endpoint.
class DatosMarcadoCheckpoint {
  const DatosMarcadoCheckpoint({this.notes, this.evidences = const []});
  final String? notes;
  final List<CheckpointEvidence> evidences;
}

/// Abre el bottom sheet apropiado segun el `action_type` del checkpoint y
/// devuelve los datos listos para llamar a `/reach` (o null si cancelo).
///
///   delivery / pickup → foto obligatoria
///   stop              → motivo obligatorio
///   rest / otro / null → confirmar directo con nota opcional
Future<DatosMarcadoCheckpoint?> showMarcarCheckpointSheet({
  required BuildContext context,
  required CheckpointInfo checkpoint,
  required String tripId,
}) {
  return showModalBottomSheet<DatosMarcadoCheckpoint>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _MarcarCheckpointContent(
      checkpoint: checkpoint,
      tripId: tripId,
    ),
  );
}

class _MarcarCheckpointContent extends ConsumerStatefulWidget {
  const _MarcarCheckpointContent({
    required this.checkpoint,
    required this.tripId,
  });

  final CheckpointInfo checkpoint;
  final String tripId;

  @override
  ConsumerState<_MarcarCheckpointContent> createState() =>
      _MarcarCheckpointContentState();
}

class _MarcarCheckpointContentState
    extends ConsumerState<_MarcarCheckpointContent> {
  final _picker = ImagePicker();
  final _notesCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  // Estado de la foto local antes/durante/después del upload.
  File? _fotoLocal;
  bool _subiendo = false;
  String? _urlSubido; // URL relativa devuelta por el backend tras upload OK.
  String? _errorUpload;

  @override
  void dispose() {
    _notesCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  CheckpointAction? get _accion => widget.checkpoint.accion;

  bool get _requierFoto =>
      _accion == CheckpointAction.delivery ||
      _accion == CheckpointAction.pickup;

  bool get _requiereMotivo => _accion == CheckpointAction.stop;

  bool get _puedeConfirmar {
    if (_subiendo) return false;
    if (_requierFoto) {
      return _urlSubido != null && _urlSubido!.isNotEmpty;
    }
    if (_requiereMotivo) {
      return _notesCtrl.text.trim().isNotEmpty;
    }
    return true;
  }

  Future<void> _tomarFoto({required ImageSource source}) async {
    setState(() {
      _errorUpload = null;
    });
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() {
        _fotoLocal = File(picked.path);
        _urlSubido = null;
      });
      await _subir();
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorUpload = '$e');
    }
  }

  Future<void> _subir() async {
    final file = _fotoLocal;
    if (file == null) return;
    setState(() {
      _subiendo = true;
      _errorUpload = null;
    });
    try {
      final repo = ref.read(uploadsRepoProvider);
      final res = await repo.subirEvidencia(tripId: widget.tripId, file: file);
      if (!mounted) return;
      setState(() {
        _urlSubido = res.url;
        _subiendo = false;
      });
    } on ArchivoDemasiadoGrandeException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorUpload = e.message;
        _subiendo = false;
        _fotoLocal = null;
      });
    } on TipoArchivoNoPermitidoException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorUpload = e.message;
        _subiendo = false;
        _fotoLocal = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorUpload = '$e';
        _subiendo = false;
      });
    }
  }

  void _confirmar() {
    final evidences = <CheckpointEvidence>[];
    if (_urlSubido != null && _urlSubido!.isNotEmpty) {
      evidences.add(
        CheckpointEvidence(
          evidenceType: 'IMAGE',
          fileUrl: _urlSubido,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
        ),
      );
    }
    final notes = _notesCtrl.text.trim();
    Navigator.pop(
      context,
      DatosMarcadoCheckpoint(
        notes: notes.isEmpty ? null : notes,
        evidences: evidences,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cp = widget.checkpoint;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              cp.name ?? 'Checkpoint ${cp.index + 1}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 2),
            Text(
              _accionSubtitulo(cp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
            const SizedBox(height: 14),
            if (_requierFoto) ..._buildFotoSection(),
            if (_requiereMotivo) ..._buildMotivoSection(),
            if (!_requierFoto && !_requiereMotivo) ..._buildNotaOpcional(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _subiendo ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _puedeConfirmar ? _confirmar : null,
                    icon: _subiendo
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_subiendo ? 'Subiendo...' : 'Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _accionSubtitulo(CheckpointInfo cp) {
    switch (_accion) {
      case CheckpointAction.delivery:
        return 'Entrega — foto obligatoria';
      case CheckpointAction.pickup:
        return 'Retiro — foto obligatoria';
      case CheckpointAction.stop:
        return 'Parada — motivo obligatorio';
      case CheckpointAction.rest:
        return 'Descanso — confirmar llegada';
      case CheckpointAction.otro:
      case null:
        return 'Confirmar llegada';
    }
  }

  List<Widget> _buildFotoSection() {
    final scheme = Theme.of(context).colorScheme;
    final cp = widget.checkpoint;
    final cargo = cp.cargoDescription;
    return [
      if (cargo != null && cargo.isNotEmpty) ...[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.inventory_2_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(cargo)),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
      _FotoPreview(
        file: _fotoLocal,
        subiendo: _subiendo,
        urlSubido: _urlSubido,
      ),
      if (_errorUpload != null) ...[
        const SizedBox(height: 6),
        Text(
          _errorUpload!,
          style: TextStyle(color: scheme.error, fontSize: 12),
        ),
      ],
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _subiendo
                  ? null
                  : () => _tomarFoto(source: ImageSource.camera),
              icon: const Icon(Icons.photo_camera),
              label: Text(_fotoLocal == null ? 'Tomar foto' : 'Otra foto'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Elegir de galeria',
            onPressed: _subiendo
                ? null
                : () => _tomarFoto(source: ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
      const SizedBox(height: 10),
      TextField(
        controller: _descCtrl,
        minLines: 1,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Descripción (opcional)',
          hintText: 'Ej: recibió María López',
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    ];
  }

  List<Widget> _buildMotivoSection() {
    return [
      TextField(
        controller: _notesCtrl,
        autofocus: true,
        minLines: 3,
        maxLines: 5,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          labelText: 'Motivo de la parada (obligatorio)',
          hintText: 'Ej: carga de combustible en YPF km 245',
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }

  List<Widget> _buildNotaOpcional() {
    return [
      TextField(
        controller: _notesCtrl,
        minLines: 2,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Nota (opcional)',
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }
}

/// Thumbnail de la foto seleccionada con overlay de estado.
class _FotoPreview extends StatelessWidget {
  const _FotoPreview({
    required this.file,
    required this.subiendo,
    required this.urlSubido,
  });

  final File? file;
  final bool subiendo;
  final String? urlSubido;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 36,
                color: Theme.of(context).hintColor,
              ),
              const SizedBox(height: 4),
              Text(
                'Todavía no tomaste foto',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Image.file(
            file!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          if (subiendo)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        'Subiendo foto...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!subiendo && urlSubido != null)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Subida',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
