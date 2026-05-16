import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

final _uuidRegex = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

bool _pareceUuid(String s) => _uuidRegex.hasMatch(s.trim());

/// Widget que resuelve un string que puede ser un UUID de location a su
/// nombre real. Si el string no es un UUID, lo muestra tal cual. Si la
/// resolucion falla, hace fallback al string original (mejor que nada).
///
/// Usa `FutureProvider.family` + `ref.keepAlive` para cachear el resultado
/// por UUID, asi multiples usos del mismo id comparten la request.
class NombreUbicacion extends ConsumerWidget {
  const NombreUbicacion({
    super.key,
    required this.valor,
    this.style,
    this.maxLines,
    this.overflow,
  });

  /// UUID o texto libre.
  final String? valor;

  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = valor?.trim() ?? '';
    if (v.isEmpty) {
      return Text('-', style: style, maxLines: maxLines, overflow: overflow);
    }
    if (!_pareceUuid(v)) {
      return Text(v, style: style, maxLines: maxLines, overflow: overflow);
    }
    final async = ref.watch(locationByIdProvider(v));
    return async.when(
      data: (loc) {
        final nombre = loc?.name.trim();
        if (nombre != null && nombre.isNotEmpty) {
          return Text(
            nombre,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          );
        }
        // Fallback al UUID si el backend no tiene el nombre.
        return Text(v, style: style, maxLines: maxLines, overflow: overflow);
      },
      loading: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (style?.fontSize ?? 14) * 0.9,
            width: (style?.fontSize ?? 14) * 0.9,
            child: const CircularProgressIndicator(strokeWidth: 1.5),
          ),
          const SizedBox(width: 6),
          Text(
            'Cargando...',
            style: style?.copyWith(
              color: (style?.color ?? Theme.of(context).hintColor)
                  .withValues(alpha: 0.7),
            ),
            maxLines: maxLines,
            overflow: overflow,
          ),
        ],
      ),
      error: (_, __) => Text(
        v,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
