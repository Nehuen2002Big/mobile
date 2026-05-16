import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

/// Carga una imagen del backend de tracking con header `Authorization`.
/// Acepta URL relativo (se antepone el host de tracking) o absoluto.
/// Gestiona loading y error placeholders.
class AuthImage extends ConsumerWidget {
  const AuthImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorIconSize = 32,
  });

  /// URL relativa ("/api/v1/...") o absoluta ("https://...").
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double errorIconSize;

  String _absoluteUrl(WidgetRef ref) {
    if (url.startsWith('http')) return url;
    final base = ref.read(dioClientProvider).config.trackingBaseUrl;
    return url.startsWith('/') ? '$base$url' : '$base/$url';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absoluteUrl = _absoluteUrl(ref);
    final tokenStorage = ref.read(tokenStorageProvider);
    return FutureBuilder<String?>(
      future: tokenStorage.readAccessToken(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _placeholder(context, cargando: true);
        }
        final token = snap.data;
        final headers =
            token != null ? {'Authorization': 'Bearer $token'} : null;
        return Image.network(
          absoluteUrl,
          headers: headers,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return _placeholder(context, cargando: true);
          },
          errorBuilder: (ctx, err, st) => _placeholder(context, error: true),
        );
      },
    );
  }

  Widget _placeholder(
    BuildContext context, {
    bool cargando = false,
    bool error = false,
  }) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: cargando
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              error ? Icons.broken_image_outlined : Icons.image_outlined,
              color: Theme.of(context).hintColor,
              size: errorIconSize,
            ),
    );
  }
}

/// Abre una imagen con `Authorization` en full-screen con zoom.
Future<void> abrirAuthImageFullscreen({
  required BuildContext context,
  required String url,
  String? title,
}) {
  return Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _AuthImageFullscreen(url: url, title: title),
    ),
  );
}

class _AuthImageFullscreen extends StatelessWidget {
  const _AuthImageFullscreen({required this.url, this.title});
  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title ?? 'Evidencia'),
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        child: Center(child: AuthImage(url: url, fit: BoxFit.contain)),
      ),
    );
  }
}
