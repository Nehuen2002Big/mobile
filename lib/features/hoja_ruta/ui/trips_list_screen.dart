import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers.dart';
import '../models/trip.dart';

class TripsListScreen extends ConsumerStatefulWidget {
  const TripsListScreen({super.key});

  @override
  ConsumerState<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends ConsumerState<TripsListScreen> {
  late Future<List<Trip>> _future;

  @override
  void initState() {
    super.initState();
    _future = _cargar();
  }

  Future<List<Trip>> _cargar() {
    final auth = ref.read(authNotifierProvider);
    final repo = ref.read(tripsRepoProvider);
    return repo.listar(driverPersonId: auth.perfil?.person.id);
  }

  Future<void> _refrescar() async {
    setState(() {
      _future = _cargar();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    // Cuando alguien dispara `tripsListRefreshProvider++` (ej. al finalizar
    // un viaje o al recibir 409 desde phone-location), refetchamos.
    ref.listen<int>(tripsListRefreshProvider, (prev, next) {
      if (prev != next) {
        setState(() => _future = _cargar());
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis viajes'),
        actions: [
          IconButton(
            tooltip: 'Refrescar',
            onPressed: () => setState(() {
              _future = _cargar();
            }),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Salir',
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refrescar,
        child: FutureBuilder<List<Trip>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return _Error(
                message: '${snap.error}',
                onRetry: () => setState(() {
                  _future = _cargar();
                }),
              );
            }
            final trips = snap.data ?? const [];
            if (trips.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('No tenes viajes asignados')),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: trips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _TripTile(trip: trips[i]),
            );
          },
        ),
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  const _TripTile({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final fecha = trip.createdAt != null
        ? DateFormat('dd/MM HH:mm').format(trip.createdAt!.toLocal())
        : '-';
    final hoja = trip.hojaRuta;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/viaje/${trip.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.id,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _StatusChip(status: trip.status),
                ],
              ),
              const SizedBox(height: 8),
              if (hoja.origin != null || hoja.destination != null) ...[
                _Row(
                  icon: Icons.trip_origin,
                  text: trip.nombreOrigen,
                ),
                const SizedBox(height: 4),
                _Row(
                  icon: Icons.place,
                  text: trip.nombreDestino,
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(Icons.schedule,
                      size: 16, color: Theme.of(context).hintColor),
                  const SizedBox(width: 4),
                  Text(fecha,
                      style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  if (trip.activeAlerts > 0) ...[
                    Icon(Icons.notifications_active,
                        size: 16,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 4),
                    Text('${trip.activeAlerts}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final TripStatus status;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color color;
    switch (status) {
      case TripStatus.active:
        color = scheme.primary;
        break;
      case TripStatus.pending:
        color = scheme.tertiary;
        break;
      case TripStatus.finished:
        color = scheme.outline;
        break;
      case TripStatus.cancelled:
        color = scheme.error;
        break;
      case TripStatus.unknown:
        color = scheme.outline;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                    onPressed: onRetry, child: const Text('Reintentar')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
