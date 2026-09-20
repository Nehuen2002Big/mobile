import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/api_config.dart';
import 'network/dio_client.dart';
import 'storage/token_storage.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/state/auth_state.dart';
import '../features/perfil/data/perfil_repository.dart';
import '../features/hoja_ruta/data/trips_repository.dart';
import '../features/alertas/data/alertas_repository.dart';
import '../features/alertas/state/pending_action_state.dart';
import '../features/ingest/data/ingest_repository.dart';
import '../features/ingest/service/gps_service.dart';
import '../features/chat/data/chat_repository.dart';
import '../features/chat/state/chat_state.dart';
import '../features/chat/state/operator_directive.dart';
import '../features/checkpoints/data/checkpoints_repository.dart';
import '../features/checkpoints/state/checkpoints_state.dart';
import '../features/locations/data/locations_repository.dart';
import '../features/locations/models/location_info.dart';
import '../features/navegacion/data/navigation_repository.dart';
import '../features/navegacion/state/navegacion_state.dart';
import '../features/uploads/data/uploads_repository.dart';
import '../features/viaje/state/trip_checklist_state.dart';
import '../features/viaje/state/trip_pause_state.dart';

// --- Core ---

final tokenStorageProvider = Provider<TokenStorage>((_) => TokenStorage());

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    config: ApiConfig.current,
    tokenStorage: ref.watch(tokenStorageProvider),
    onUnauthorized: () async {
      ref.read(authNotifierProvider.notifier).logout();
    },
  );
});

// --- Auth ---

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthStateData>(() => AuthNotifier());

// --- Repositorios ---

final authRepoProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.watch(dioClientProvider)));

final perfilRepoProvider = Provider<PerfilRepository>(
    (ref) => PerfilRepository(ref.watch(dioClientProvider)));

final tripsRepoProvider = Provider<TripsRepository>(
    (ref) => TripsRepository(ref.watch(dioClientProvider)));

/// Contador que se incrementa cuando algo invalida la lista de viajes
/// (ej. el chofer finaliza un viaje, el monitor lo cancela remotamente y
/// el backend devuelve 409 a un phone-location). La pantalla de
/// "Mis viajes" lo watch-ea y refetcha la lista.
final tripsListRefreshProvider = StateProvider<int>((_) => 0);

final alertasRepoProvider = Provider<AlertasRepository>(
    (ref) => AlertasRepository(ref.watch(dioClientProvider)));

final ingestRepoProvider = Provider<IngestRepository>(
    (ref) => IngestRepository(ref.watch(dioClientProvider)));

final chatRepoProvider = Provider<ChatRepository>(
    (ref) => ChatRepository(ref.watch(dioClientProvider)));

final checkpointsRepoProvider = Provider<CheckpointsRepository>(
    (ref) => CheckpointsRepository(ref.watch(dioClientProvider)));

final locationsRepoProvider = Provider<LocationsRepository>(
    (ref) => LocationsRepository(ref.watch(dioClientProvider)));

final uploadsRepoProvider = Provider<UploadsRepository>(
    (ref) => UploadsRepository(ref.watch(dioClientProvider)));

final navigationRepoProvider = Provider<NavigationRepository>(
    (ref) => NavigationRepository(ref.watch(dioClientProvider)));

/// Resuelve un UUID de location a su LocationInfo. Cacheado por Riverpod por
/// key (el UUID), de modo que multiples widgets que pidan el mismo id
/// reusan la misma Future. Devuelve null si falla (por ej. 404 o red caida)
/// para que la UI haga fallback.
final locationByIdProvider =
    FutureProvider.family.autoDispose<LocationInfo?, String>((ref, id) async {
  try {
    ref.keepAlive();
    return await ref.read(locationsRepoProvider).obtenerPorId(id);
  } catch (_) {
    return null;
  }
});

// --- Servicios ---

final gpsServiceProvider = ChangeNotifierProvider<GpsService>(
    (ref) => GpsService(
          ref.watch(ingestRepoProvider),
          ref.watch(dioClientProvider).config,
        ));

// --- Chat (family por tripId) ---

final chatNotifierProvider =
    NotifierProvider.family<ChatNotifier, ChatState, String>(
  ChatNotifier.new,
);

// --- Pending action alerts (family por tripId) ---

final pendingActionNotifierProvider =
    NotifierProvider.family<PendingActionNotifier, PendingActionState, String>(
  PendingActionNotifier.new,
);

// --- Trip pause status (family por tripId, MC-015) ---

final tripPauseNotifierProvider =
    NotifierProvider.family<TripPauseNotifier, TripPauseState, String>(
  TripPauseNotifier.new,
);

// --- Checklist de salida (family por tripId, MC-022) ---

final tripChecklistNotifierProvider = NotifierProvider.family<
    TripChecklistNotifier, TripChecklistState, String>(
  TripChecklistNotifier.new,
);

// --- Directiva preset del operador (MC-018) ---
//
// State global (no por tripId): solo puede haber una directiva
// pendiente en pantalla a la vez. Si el operador toca varios chips
// seguidos, el ChatNotifier sobreescribe el provider y el overlay
// muestra solo la ultima — los anteriores quedan en el chat con su
// render distintivo.
final pendingOperatorDirectiveProvider =
    StateProvider<OperatorDirective?>((_) => null);

// --- Navegacion (family por tripId) ---

final navegacionNotifierProvider =
    NotifierProvider.family<NavegacionNotifier, NavegacionState, String>(
  NavegacionNotifier.new,
);

// --- Checkpoints (family por tripId) ---

final checkpointsNotifierProvider = NotifierProvider.family<
    CheckpointsNotifier, CheckpointsState, String>(
  CheckpointsNotifier.new,
);
