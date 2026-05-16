import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authNotifierProvider.notifier);
    // El error ya se rendea como banner persistente arriba del form
    // (ver el `_ErrorBanner` en build), no necesita snackbar duplicado.
    await notifier.login(
      _identifierCtrl.text.trim(),
      _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'IsaTech',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'App del conductor',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    // Banner de error persistente: lo seteo cuando login()
                    // falla y tambien cuando bootstrap() rechaza al user
                    // (ej. logueo OK pero no es chofer) — en ese ultimo
                    // caso el chofer abre la app y ve directamente el
                    // motivo del logout automatico.
                    if (auth.error != null) ...[
                      _ErrorBanner(
                        message: auth.error!,
                        onDismiss: () => ref
                            .read(authNotifierProvider.notifier)
                            .limpiarError(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _identifierCtrl,
                      autofillHints: const [AutofillHints.username],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email o usuario',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      autofillHints: const [AutofillHints.password],
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Contrasena',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: auth.loading ? null : _submit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: auth.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Ingresar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Banner de error en rojo claro arriba del form. Lo cierra el chofer
/// con la X (limpia `state.error` sin tocar el resto).
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline,
              color: theme.colorScheme.onErrorContainer, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: theme.colorScheme.onErrorContainer,
            visualDensity: VisualDensity.compact,
            onPressed: onDismiss,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}
