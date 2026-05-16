import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper sobre FlutterSecureStorage (Keychain en iOS,
/// EncryptedSharedPreferences en Android) para los datos sensibles del
/// chofer: access token, refresh token, su timestamp de expiracion, y
/// los IDs (user/person) que algunos features cachean.
///
/// Las keys `_kAccess` y `_kRefresh` son compartidas con el isolate
/// background del foreground service GPS — ver
/// `lib/features/ingest/service/gps_foreground_task.dart` (constantes
/// `_kAccess` y `_kRefresh` con los mismos string literals).
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const _kAccess = 'isatech_access_token';
  static const _kRefresh = 'isatech_refresh_token';
  static const _kExpiresAt = 'isatech_token_expires_at';
  static const _kUserId = 'isatech_user_id';
  static const _kPersonId = 'isatech_person_id';

  final FlutterSecureStorage _storage;

  /// Persiste el par de tokens y, opcionalmente, el timestamp absoluto
  /// de expiracion del access_token. El interceptor HTTP usa
  /// `expiresAt` para refrescar proactivamente cuando faltan <60s.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) async {
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
    if (expiresAt != null) {
      await _storage.write(
        key: _kExpiresAt,
        value: expiresAt.toUtc().toIso8601String(),
      );
    } else {
      // Si no nos dan expiresAt, borramos el viejo para no usar uno
      // stale del login anterior.
      await _storage.delete(key: _kExpiresAt);
    }
  }

  Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);

  /// Devuelve el timestamp absoluto en el que expira el access_token,
  /// o null si nunca fue persistido (ej. rebuild + token guardado por
  /// version vieja sin este campo).
  Future<DateTime?> readExpiresAt() async {
    final raw = await _storage.read(key: _kExpiresAt);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> saveUserId(String userId) =>
      _storage.write(key: _kUserId, value: userId);

  Future<String?> readUserId() => _storage.read(key: _kUserId);

  Future<void> savePersonId(String personId) =>
      _storage.write(key: _kPersonId, value: personId);

  Future<String?> readPersonId() => _storage.read(key: _kPersonId);

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kExpiresAt);
    await _storage.delete(key: _kUserId);
    await _storage.delete(key: _kPersonId);
  }
}
